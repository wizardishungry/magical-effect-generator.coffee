Generator = require './generator'
module.exports = class Magic extends Generator
  _register: (data) ->
    super data
    @moreColors 2
    @moreMonsters 'monsters.txt', 128, 2
    @moreMonsters 'pokemon.txt', 128, 2
