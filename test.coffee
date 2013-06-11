Magic = require './magic'
Outfit = require './outfit'
outfit = new Outfit
console.log outfit.generate()
magic = new Magic
console.log magic.generate()
str = ''
while not str.match /wikipedia/
  str = magic.generate()
console.log str
