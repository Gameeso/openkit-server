module.exports = class DuplicatePreventer

  constructor: ->
    @arr = []

  isDuplicate: (val) ->
    if val == null
      return no
    else
      log @arr
      if @arr.indexOf(val) is -1
        @arr.push(val)
        return no
      else
        return yes
