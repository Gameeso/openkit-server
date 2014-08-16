require "./Globals"
fs = require "fs"

argv = process.argv
if argv.length == 4
  app_id = argv[2]
  data_file = argv[3]
  importData = require "./Importer"

  log "App id: ", app_id, "\nData file: ", data_file

  fs.readFile data_file, (err, data) ->
    throw err  if err

    importData(
      app_id: app_id
      data: data.toString()
    )

    return

else
  log "Error: not enough arguments"
