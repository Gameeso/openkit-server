module.exports = class Mapper

  # mapper.map("user", "2393", "39")
  # mapper.is("user", "2393") # returns 39

  constructor: ->
    @defaultCatch = null
    @mapping = {}

  map: (objName, openkitID, gameesoID) ->

    @mapping[objName] = {} if not @mapping[objName]?

    if @mapping[objName][openkitID]
      log "ID #{openkitID} on #{objName} already exists!"
      if @defaultCatch != null
        @defaultCatch()

    @mapping[objName][openkitID] = gameesoID

    return null

  is: (objName, openkitID) ->
    return @mapping[objName][openkitID]

  dump: ->
    log "Mapper Dump:\n", @mapping
