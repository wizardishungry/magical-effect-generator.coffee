fs = require 'fs'

class Generator
  constructor: () ->
    @_load()
  
  generate: () ->
    "#{@constructor.name} hello world"

  _register: (data) ->
    console.log data
    @_data = []
    for mask, values of data
      for i,value of values
        @_data.push [mask,value]

  _load: () ->
    filename = "#{__dirname}/magic.json"
    fs.readFile filename, (err, contents) =>
        #@_register JSON.parse contents.toString()
        data = eval '('+contents.toString()+')'
        @_register data

class Magic extends Generator

magi = new Magic
console.log magi.generate()
console.log magi.data
