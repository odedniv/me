class Experience
  constructor: (@title, @start, @end, @skills, @link, @details) ->
    for skill in @skills
      skill.experiences.push(@)

  duration: ->
    @end - @start if @end?

module.exports = Experience
