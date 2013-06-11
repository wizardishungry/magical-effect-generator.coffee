Generator = require './generator'
module.exports = class Magic extends Generator
  _register: (data) ->
    @MONSTER_PREFIX = "you turn into a "
    @moreColors 2
    super data
    @moreMonsters 'monsters.txt', 128
    @moreMonsters 'pokemon.txt', 128
