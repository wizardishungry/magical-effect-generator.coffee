Generator = require './generator'
module.exports = class Outfit extends Generator
  _register: (data) ->
    @COLOR_IDX = 1
    super data
    @moreColors
    @moreMonsters 'monsters.txt', 1024
    @moreMonsters 'pokemon.txt', 1024
