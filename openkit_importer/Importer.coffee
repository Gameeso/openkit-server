Mapper = require "./Mapper"
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
          for score in leaderboard.scores
            log "Score: ", score
            obj = extendWithoutID({}, score)
            obj.sort_value = obj.value
            obj = deleteKeys obj, ["is_users_best", "meta_doc_url", "rank", "value"]

            obj.leaderboard_id = mapper.is("leaderboard", obj.leaderboard_id)
            obj.user_id = mapper.is("user", obj.user_id)

            callbackCount++
            trx.insert(obj).into("scores").then((inserts) ->
              log "inserts: ", inserts
              for id in inserts
                mapper.map "score", score.id, id

              callbackCount--
              lastObjectHasBeenSaved() if callbackCount == 0

              return null
            ).catch defaultCatch

          return null

        startOnLeaderboard = ->
          for leaderboard_ in data.leaderboards
            ((leaderboard) ->
              obj = extendWithoutID({}, leaderboard)
              obj = deleteKeys obj, ["icon_url", "player_count", "scores"]
              obj.app_id = app_id

              if obj.sort_type != "HighValue" and obj.sort_type != "LowValue"
                obj.sort_type = "HighValue"

              trx.insert(obj).into("leaderboards").then((inserts) ->
                log "inserts: ", inserts
                for id in inserts
                  mapper.map "leaderboard", leaderboard.id, id
                  doScores leaderboard

                return null
              ).catch defaultCatch
            )(leaderboard_)

        startOnUsers = ->
          callbackCount = 0
          for user_ in data.users
            ((user) ->
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
                  log "rows: ", rows
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
