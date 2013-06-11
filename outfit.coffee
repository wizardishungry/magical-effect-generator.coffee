Generator = require './generator'
module.exports = class Outfit extends Generator
  constructor: ->
    super
    @COLOR_IDX = @log2 2

  _register: (data) ->
    super data
    @moreColors 2
    @moreMonsters 'monsters.txt', 1024
    @moreMonsters 'pokemon.txt', 1024
