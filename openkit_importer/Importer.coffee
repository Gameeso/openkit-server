module.exports = (attrs) ->

  log "importData: ", attrs

  app_id = attrs.app_id
  knex("apps").where(
    id: app_id
  ).then (rows) ->
    log "Rows: ", rows

    if rows.length > 0
      # app exists, now lop over data to import


    else
      log "Error: no such app"
