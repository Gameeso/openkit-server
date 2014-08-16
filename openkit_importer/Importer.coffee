Mapper = require "./Mapper"
DuplicatePreventer = require "./DuplicatePreventer"
mapper = new Mapper

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
  knex.transaction((trx) ->

    defaultCatch = (error) ->
      trx.rollback()
      log "Error:", error, "\nRolled back."
      return

    lastObjectHasBeenSaved = ->
      trx.commit()
      log "Done!"
      mapper.dump()
      process.exit 0

    app_id = attrs.app_id
    data = attrs.data

    trx("apps").where(
      id: app_id
    ).then (rows) ->
      log "Rows: ", rows

      if rows.length > 0
        # app exists, now loop over data to import

        doScores = (leaderboard) ->
          callbackCount = 0
          for score_ in leaderboard.scores
            ((score) ->
              log "Score: ", score
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

                  callbackCount--
                  lastObjectHasBeenSaved() if callbackCount == 0

                  return null
                ).catch defaultCatch

              callbackCount++
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
                    callbackCount--
                    lastObjectHasBeenSaved() if callbackCount == 0

            )(score_)

          return null

        startOnLeaderboard = ->
          for leaderboard_ in data.leaderboards
            ((leaderboard) ->
              obj = extendWithoutID({}, leaderboard)
              obj = deleteKeys obj, ["icon_url", "player_count", "scores"]
              obj.app_id = app_id

              if obj.sort_type != "HighValue" and obj.sort_type != "LowValue"
                obj.sort_type = "HighValue"

              trx("leaderboards")
              .where("name", obj.name)
              .andWhere("app_id", app_id)
              .then (rows) ->
                if rows.length == 0
                  trx.insert(obj).into("leaderboards").then((inserts) ->
                    log "inserts: ", inserts
                    for id in inserts
                      mapper.map "leaderboard", leaderboard.id, id
                      doScores leaderboard

                    return null
                  ).catch defaultCatch
                else
                  id = rows[0].id
                  mapper.map "leaderboard", leaderboard.id, id
                  doScores leaderboard

            )(leaderboard_)

        startOnUsers = ->
          callbackCount = 0
          fbIDPreventer = new DuplicatePreventer()
          googleIDPreventer = new DuplicatePreventer()
          gameCenterIDPreventer = new DuplicatePreventer()

          for user_ in data.users
            ((user) ->
              if fbIDPreventer.isDuplicate(user.fb_id) or googleIDPreventer.isDuplicate(user.google_id) or gameCenterIDPreventer.isDuplicate(user.gamecenter_id)
                defaultCatch()
                process.exit 1

              callbackCount++
              trx("users").where(->
                @where "fb_id", user.fb_id
                @whereNotNull "fb_id"

                return null
              ).orWhere(->
                @where "google_id", user.google_id
                @whereNotNull "google_id"

                return null
              )
              .orWhere(->
                @where "gamecenter_id", user.gamecenter_id
                @whereNotNull "gamecenter_id"

                return null
              )
              .then (rows) ->
                log "user rows: ", rows.length
                if rows.length == 0
                  # 0 rows means we have to insert a new user
                  trx.insert(extendWithoutID {}, user).into("users").then((inserts) ->
                    callbackCount--
                    log "inserts: ", inserts
                    for id in inserts
                      mapper.map "user", user.id, id

                    startOnLeaderboard() if callbackCount is 0

                    return null
                  ).catch defaultCatch

                else
                  callbackCount--
                  for row in rows
                    mapper.map "user", user.id, row.id

                  startOnLeaderboard() if callbackCount is 0

                return null

            )(user_)

        startOnUsers()

      else
        log "Error: no such app"

      return null

    return null

  ).then((inserts) ->

  ).catch (error) ->
    log "Error:", error, "\nRolled back."
    return
