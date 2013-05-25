class Generator
  constructor: () ->
  
  generate: () ->
    "hello world"

class Magic extends Generator

magi = new Magic
console.log magi.generate()
