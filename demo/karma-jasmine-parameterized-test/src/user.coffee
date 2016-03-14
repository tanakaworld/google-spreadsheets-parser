class User
  # constructor
  constructor: (@NAME, @age) ->

  canDrink: ->
    parseInt(@age) >= 20
