md_file_path = process.argv[2]
if md_file_path is undefined then process.exit(0)

fs   = require 'fs'
util = require 'util'

OBJECT     = {}
JSONSTRING = {}
TAGS       = []
STATS      = {}
STATS.tags =
  count: 0
STATS.links =
  count: 0
STATS.part =
  count: 0

showJson = ->
  OBJECT.items = JSONSTRING
  OBJECT.tags = TAGS.sort()
  OBJECT.stats = STATS
  console.log JSON.stringify(OBJECT)
  return

findTag = (rows, index, tag) ->
  index += 1
  row = rows[index]
  if /^\*\s/.test(row)
    tag_name = row.replace /^\*\s/, ""
    if TAGS.indexOf(tag_name) is -1
      TAGS.push(tag_name)
      STATS.tags.count += 1

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
    JSONSTRING[item.name] = item
    STATS.links.count += 1
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
    STATS.links.count += 1
    findItem rows, index, item

  else if /^#\s[A-Za-zА-Яа-я0-9]/.test(row)
    JSONSTRING[item.name] = item
    STATS.part.count += 1
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

  if /^#\s[A-Za-zА-Яа-я0-9]/.test(row)
    item = {}
    item.name = row.replace(/^#\s/, '')
    item.links = []
    findItem rows, index, item
  return

startFind = (content) ->
  rows = content.split /\n/
  findHead rows, -1
  return

fs.readFile md_file_path, 'utf8', (err, content) ->
  startFind content
  return
