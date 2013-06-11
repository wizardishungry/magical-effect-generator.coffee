Generator = require './generator'
module.exports = class Magic extends Generator
  _register: (data) ->
    super data
    @MONSTER_PREFIX = "you turn into a "
    @moreColors 2
    @moreMonsters 'monsters.txt', 128
    @moreMonsters 'pokemon.txt', 128
