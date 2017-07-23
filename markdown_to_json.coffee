fs = require 'fs'
util = require 'util'

JSONSTRING = []

showJson = ->
  console.log JSON.stringify(JSONSTRING)
  return

findTag = (rows, index, tag) ->
  index += 1
  row = rows[index]
  if /^\*\s/.test(row)
    tag_name = row.replace /^\*\s/, ""
    tag.push tag_name
    findTag rows, index, tag

  else
    return tag: tag, index: index

findDesc = (rows, index, desc) ->
  index += 1
  row = rows[index]
  if /^[A-Za-zА-Яа-я0-9]+/.test(row)
    desc += row
    findDesc rows, index, desc

  else
    return desc: desc, index: index

findItem = (rows, index, item) ->
  if index + 1 >= rows.length
    JSONSTRING.push item
    findHead rows, index
    return

  index += 1
  row = rows[index]

  if /^http/.test(row)
    link = {}
    link.href = row

    desc = findDesc rows, index, ""
    link.desc = desc.desc
    index = desc.index

    index -= 1
    tags = findTag rows, index, []
    link.tags = tags.tag
    index = tags.index

    item.links.push link
    findItem rows, index, item

  else if /^#\s\w/.test(row)
    JSONSTRING.push item
    index -= 1
    findHead rows, index

  else
    findItem rows, index, item
  return

findHead = (rows, index) ->
  if index + 1 >= rows.length
    showJson()
    return

  index += 1
  row = rows[index]

  if /^#\s\w/.test(row)
    item = {}
    item.name = row.replace(/^#\s/, '')
    item.links = []
    findItem rows, index, item
  return

startFind = (content) ->
  rows = content.split /\n/
  findHead rows, -1
  return

fs.readFile 'copy.md', 'utf8', (err, content) ->
  startFind content
  return
