require "./Globals"
fs = require "fs"

argv = process.argv
if argv.length == 9
  app_id = argv[6]
  data_file = argv[7]
  secure_key = argv[8]
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
    redis.set "secure_key:#{secure_key}", "importing"
    importData(
      app_id: app_id
      data: json
      secure_key: secure_key
      callback: ->
        # Delete temporary upload (we dont need it anymore)
        fs.unlink(data_file)
        process.exit 0
    )

    return

else
  log "Error: not enough arguments"
  process.exit 1
