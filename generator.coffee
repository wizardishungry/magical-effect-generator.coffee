fs = require 'fs'

class Generator

  constructor: () ->
    @MAX_FIELDS = 16
    @_load()


  log2: (v) -> # http://graphics.stanford.edu/~seander/bithacks.html#IntegerLogObvious
    r = 0
    while v >>= 1
      r++
    return r
  
  generate: (mask=@MAX_FIELDS) ->
    search = @_search[mask]
    if not search
      return '@@'
    i = Math.floor(Math.random()*search.length)
    str = search[i]
    str = str.replace /\\(\d+)/gim, (match, num) =>
      return @generate @log2 num
    return str

  _register: (data) ->
    @_data = []
    for mask, values of data
      for i,value of values
        @_data.push [mask,value]

    @_search = []
    mask = (x) -> (1<<x)
    fields = [0..@MAX_FIELDS].map mask
    for v,i in fields
      @_search[i] = []

    for tuple, i in @_data
      [bitField, str] = tuple
      for bitMask, i in fields
        if (bitField & bitMask) == bitMask
          @_search[i].push str
          #console.log "#{bitField} & #{bitMask}: #{str}"

  _load: () ->
    filename = "#{__dirname}/magic.json"
    contents = fs.readFileSync filename
    #@_register JSON.parse contents.toString()
    data = eval '('+contents.toString()+')'
    @_register data

class Magic extends Generator

magi = new Magic
console.log magi.generate()
