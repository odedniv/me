class Skill
  constructor: (@title, @level) ->
    @experiences = []

  class @ProgrammingLanguage extends Skill
  class @Framework extends Skill
  class @Platform extends Skill
  class @CodingStyle extends Skill
  class @Service extends Skill
  class @Language extends Skill

module.exports = Skill
