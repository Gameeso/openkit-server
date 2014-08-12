extendWithoutID = (obj1, obj2) ->
  result = obj1
  val = undefined
  for val of obj2
    result[val] = obj2[val]  if val isnt "id" and obj2.hasOwnProperty(val)
  result

module.exports = (attrs) ->
  app_id = attrs.app_id
  data = attrs.data

  knex("apps").where(
    id: app_id
  ).then (rows) ->
    log "Rows: ", rows

    if rows.length > 0
      # app exists, now lop over data to import

      for user_ in data.users
        ((user) ->
          knex("users").where(->
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
              knex.insert(extendWithoutID {}, user).into("users").then (inserts) ->
                log "inserts: ", inserts

        )(user_)

    else
      log "Error: no such app"
