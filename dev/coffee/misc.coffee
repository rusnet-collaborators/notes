get_random = (min, max) ->
  min = min or 0
  max = max or 0

  if typeof(min) is 'number' and typeof(max) is 'number'
    random = Math.floor(Math.random() * (max - min + 1) + min)
  else
    random = false
  random
