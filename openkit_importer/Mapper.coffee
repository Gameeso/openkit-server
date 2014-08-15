module.exports = class Mapper

  # mapper.map("user", "2393", "39")
  # mapper.is("user", "2393") # returns 39

  constructor: ->
    @mapping = {}

  map: (objName, openkitID, gameesoID) ->

    @mapping[objName] = {} if not @mapping[objName]?
    @mapping[objName][openkitID] = gameesoID

    return null

  is: (objName, openkitID) ->
    return @mapping[objName][openkitID]

  dump: ->
    log "Mapper Dump:\n", @mapping
