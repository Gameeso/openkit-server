Mapper = require "./Mapper"
DuplicatePreventer = require "./DuplicatePreventer"
mapper = new Mapper
async = require "async"

extendWithoutID = (obj1, obj2) ->
  result = obj1
  val = undefined
  for val of obj2
    result[val] = obj2[val]  if val isnt "id" and obj2.hasOwnProperty(val)
  result

deleteKeys = (obj, keysToDelete) ->

  obj2 = {}

  for key, val of obj
    if keysToDelete.indexOf(key) is -1
      obj2[key] = val

  return obj2

module.exports = (attrs) ->

  # trx: mysql transaction
  # multi: redis transaction

  multi = redis.multi()
  knex.transaction((trx) ->

    defaultCatch = (error) ->
      trx.rollback()
      log "Error:", error, "\nRolled back."
      process.exit 1

    mapper.defaultCatch = defaultCatch

    app_id = attrs.app_id
    data = attrs.data
    importData = {}

    async.waterfall [
      (callback) ->
        trx("apps").where(
          id: app_id
        ).then (rows) ->
          log "Apps Rows: ", rows

          if rows.length > 0
            # app exists, now loop over data to import
            importData.app = rows[0]
            callback(null)

          else
            callback "App not found"

      (callback) ->
        trx("tags").where("name", "v1").then((rows) ->
          if rows.length > 0
            importData.leaderboardTagID = rows[0].id
            callback null
          else
            callback "v1-tag not found"
        )

      (callback) ->
        callbackCount = 0
        fbIDPreventer = new DuplicatePreventer()
        googleIDPreventer = new DuplicatePreventer()
        gameCenterIDPreventer = new DuplicatePreventer()

        # create a queue object with concurrency 2
        q = async.queue((user, next) ->

          log "Doing user: ", user

          if fbIDPreventer.isDuplicate(user.fb_id) or googleIDPreventer.isDuplicate(user.google_id) or gameCenterIDPreventer.isDuplicate(user.gamecenter_id)
            defaultCatch()

          callbackCount++

          trx("users").where(->
              @where(->
                @where "fb_id", user.fb_id
                @whereNotNull "fb_id"

                return null
              ).orWhere(->
                @where "google_id", user.google_id
                @whereNotNull "google_id"

                return null
              ).orWhere(->
                @where "gamecenter_id", user.gamecenter_id
                @whereNotNull "gamecenter_id"

                return null
              )
          )
          .andWhere(->
            @where "developer_id", importData.app.developer_id
            return null
          )
          .then (rows) ->
            log "user rows: ", rows
            if rows.length == 0
              # 0 rows means we have to insert a new user
              obj = extendWithoutID {}, user
              obj.developer_id = importData.app.developer_id

              trx.insert(obj).into("users").then((inserts) ->
                callbackCount--
                log "inserts: ", inserts
                for id in inserts
                  mapper.map "user", user.id, id

                next()

                return null
              ).catch defaultCatch

            else
              callbackCount--
              for row in rows
                mapper.map "user", user.id, row.id

              next()

            return null

          return
        , 2)

        q.drain = ->
          log "all user items have been processed"
          callback(null)

        for user in data.users
          q.push user

      (callback) ->
        createScoreQueue = ->
          # create a queue object with concurrency 10
          return async.queue((score, next) ->
            log "Processing Score: ", score
            obj = extendWithoutID({}, score)
            obj.sort_value = obj.value
            obj = deleteKeys obj, ["is_users_best", "meta_doc_url", "rank", "value"]

            obj.leaderboard_id = mapper.is("leaderboard", obj.leaderboard_id)
            log "obj.user_id", obj.user_id
            obj.user_id = mapper.is("user", obj.user_id)
            log "obj.user_id", obj.user_id

            insertScore = ->
              trx.insert(obj).into("scores").then((inserts) ->
                log "inserts: ", inserts
                for id in inserts
                  mapper.map "score", score.id, id

                next()

                return null
              ).catch defaultCatch

            trx("scores")
            .where("leaderboard_id", obj.leaderboard_id)
            .andWhere("user_id", obj.user_id)
            .then (rows) ->
              if rows.length == 0
                # just insert
                insertScore()
              else
                # check if larger than score we import now, if not then we replace the value (highest score counts)
                row = rows[0]
                log "row.sort_value: #{row.sort_value}"
                log "obj.sort_value: #{obj.sort_value}"
                if row.sort_value < obj.sort_value
                  trx("scores")
                  .where("leaderboard_id", obj.leaderboard_id)
                  .andWhere("user_id", obj.user_id)
                  .del()
                  .then(->
                    insertScore()
                  )
                else
                  next()
          , 10)

        # create a queue object with concurrency 2
        q = async.queue((leaderboard, next) ->
          obj = extendWithoutID({}, leaderboard)
          obj = deleteKeys obj, ["icon_url", "player_count", "scores"]
          obj.app_id = app_id

          if obj.sort_type != "HighValue" and obj.sort_type != "LowValue"
            obj.sort_type = "HighValue"

          trx("leaderboards")
          .where("name", obj.name)
          .andWhere("app_id", app_id)
          .then (rows) ->
            scoreQueue = createScoreQueue()
            scoreQueue.drain = ->
              log "All scores are done!"
              next()

            if rows.length == 0
              trx.insert(obj).into("leaderboards").then((inserts) ->
                log "leaderboard inserts: ", inserts
                for id in inserts
                  mapper.map "leaderboard", leaderboard.id, id
                  tagObj =
                    tag_id: importData.leaderboardTagID
                    taggable_id: id
                    taggable_type: "Leaderboard"
                    context: "tags"
                    created_at: new Date

                  trx.insert(tagObj).into("taggings").then((inserts) ->
                    for score in leaderboard.scores
                      scoreQueue.push score

                    if leaderboard.scores.length == 0
                      next()
                  )

                return null
              ).catch defaultCatch
            else
              id = rows[0].id
              mapper.map "leaderboard", leaderboard.id, id

              for score in leaderboard.scores
                scoreQueue.push score

              if leaderboard.scores.length == 0
                next()
        , 2)

        q.drain = ->
          log "All leaderboards are imported!"
          callback null

        for leaderboard in data.leaderboards
          q.push leaderboard

    ], (err, result) ->
      log "error: ", err
      log "result: ", result

      if error?
        defaultCatch()
        return

      trx.commit()
      log "Done!"
      mapper.dump()

      attrs.callback() if attrs.callback?

    return null

  ).then((inserts) ->
  ).catch (error) ->
    log "Error:", error, "\nRolled back."
    return
