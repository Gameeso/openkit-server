require "./Globals"
fs = require "fs"

argv = process.argv
if argv.length == 8
  app_id = argv[6]
  data_file = argv[7]
  importData = require "./Importer"

  log "App id: ", app_id, "\nData file: ", data_file

  fs.readFile data_file, (err, data) ->
    throw err  if err

    json = null
    try
      json = JSON.parse data.toString()
    catch
      process.exit 1


    # Connect to MySQL to handle the importing
    connectToDB()

    importData(
      app_id: app_id
      data: json
    )

    return

else
  log "Error: not enough arguments"
  process.exit 1
