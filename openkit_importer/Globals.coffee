global.argv = process.argv

global.log = (msg) ->
    arguments_ = ['Gameeso-Importer -> ']
    for arg in arguments
      arguments_.push arg

    console.log.apply console, arguments_

global.connectToDB = ->
  redis = require("redis")
  global.redis = redis.createClient()
  global.knex = require("knex")(
    client: "mysql"
    debug: yes
    connection:
      host: argv[2]
      user: argv[3]
      password: argv[4]
      database: argv[5]
  )
