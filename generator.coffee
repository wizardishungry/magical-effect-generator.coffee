fs = require 'fs'

module.exports = class Generator

  constructor: () ->
    @MAX_FIELDS = 16
    @COLOR_IDX = 2
    @MONSTER_PREFIX = ""
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
      throw "Unknown mask #{mask}"
    i = Math.floor(Math.random()*search.length)
    str = search[i]
    str = str.replace /\\(\d+)/gi, (match, num, offset) =>
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
    filename = "#{__dirname}/#{@constructor.name.toLowerCase()}-data.json"
    contents = fs.readFileSync filename
    #@_register JSON.parse contents.toString()
    data = eval '('+contents.toString()+')'
    @_register data

  moreMonsters: (filename, idx) ->
    array = fs.readFileSync("#{__dirname}/#{filename}").toString().split "\n"
    idx = @log2 idx
    for line,i in array
      colored = (string) =>
        for color in @_search[@log2 @COLOR_IDX]
          r = new RegExp "^#{color} "
          if string.match color
            return true
        return false
      if line
        @_search[idx].push "#{@MONSTER_PREFIX}#{line}"
        if not colored(line)
          @_search[idx].push "#{@MONSTER_PREFIX}\\#{@COLOR_IDX} #{line}"

  moreColors: ->
    idx = @log2 @COLOR_IDX
    array = fs.readFileSync("#{__dirname}/colors.txt").toString().split "\n"
    colors = {}
    for line in array
      if line
        line =  line.toLowerCase().replace /\(.*/, ''
        colors[line] = line
    for color,i in colors
        @_search[idx].push color
