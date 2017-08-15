gen_url = (pattern) ->
  if typeof(pattern) is 'number'
    count = pattern ? 6
    str = ""
    for i in [0...count]
      str += "x"

  else if typeof(pattern) is 'string'
    if pattern.length is 0 then pattern = "abcdef"
    str = pattern.replace /\w/g, 'x'

  else
    str = "xxxxxx"

  url = str.replace /x/g, (c) ->
    r = Math.random() * 16 | 0
    v = if c is 'x' then r else r & 0x3 | 0x8
    v = v.toString 16
    v

  url

# TODO - need testing
module.exports = gen_url
