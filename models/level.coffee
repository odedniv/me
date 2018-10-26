class Level
  constructor: (@name, @description) ->

  @beginner: new Level('beginner', "I have scratched the surface.")
  @adept:    new Level('adept',    "I can use it with my eyes closed.")
  @expert:   new Level('expert',   "I can reassemble it.")

module.exports = Level
