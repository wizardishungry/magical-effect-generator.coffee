fs = require 'fs'

module.exports = class Generator

  constructor: () ->
    @MAX_FIELDS = 16
    @_load()

  log2: (v) -> # http://graphics.stanford.edu/~seander/bithacks.html#IntegerLogObvious
    r = 0
    while v >>= 1
      r++
    return r
  
  generate: () ->
    str = @_generate @MAX_FIELDS
    sens = str.split '. '
    sens = sens.map (string) =>
       return  string.charAt(0).toUpperCase() + string.slice 1
    str = sens.join '. '
    return str

  _generate: (mask) ->
    search = @_search[mask]
    if not search
      return '@@'
    i = Math.floor(Math.random()*search.length)
    str = search[i]
    str = str.replace /\\(\d+)/gim, (match, num, offset) =>
      return @_generate @log2 num
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
    filename = "#{__dirname}/magic-data.json"
    contents = fs.readFileSync filename
    #@_register JSON.parse contents.toString()
    data = eval '('+contents.toString()+')'
    @_register data

  moreMonsters: (filename, idx, color_idx) ->
    array = fs.readFileSync("#{__dirname}/#{filename}").toString().split "\n"
    idx = @log2 idx
    for line,i in array
      if line
        @_search[idx].push "you turn into a #{line}"
        @_search[idx].push "you turn into a \\2 #{line}"

  moreColors: (idx) ->
    array = fs.readFileSync("#{__dirname}/colors.txt").toString().split "\n"
    idx = @log2 idx
    colors = {}
    for line in array
      if line
        line =  line.toLowerCase().replace /\(.*/, ''
        colors[line] = line
    for color,i in colors
        @_search[idx].push color
