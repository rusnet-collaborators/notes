md_file_path = process.argv[2]
if md_file_path is undefined then process.exit(0)

fs   = require 'fs'
util = require 'util'
url  = require 'url'

OBJECT = {}
ITEMS  = {}
TAGS   = []
LINKS  = []
STATS =
  tags:  count: 0
  links: count: 0
  part:  count: 0
  host:
    count_all: 0
    count: {}

compare = (object) ->
  (a, b) ->
    if object[a] < object[b] then return -1
    if object[a] > object[b] then return 1
    return 0

showJson = ->
  OBJECT.items = ITEMS
  OBJECT.tags  = TAGS.sort()
  OBJECT.links = LINKS.sort()

  _count = STATS.host.count
  STATS.host.count = {}

  keys = Object.keys _count
  keys.sort compare(_count)
  keys.reverse()
  for key in keys
    STATS.host.count[key] = _count[key]

  OBJECT.stats = STATS
  console.log JSON.stringify(OBJECT)
  return

findTag = (rows, index, tag) ->
  index += 1
  row = rows[index]
  if /^\*\s/.test(row)
    tag_name = row.replace(/^\*\s/, "").trim()
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
  if /^[A-Za-zА-Яа-яЁё0-9]+/.test(row)
    desc += row
    findDesc rows, index, desc

  else
    return desc: desc, index: index

findItem = (rows, index, item) ->
  if index + 1 >= rows.length
    ITEMS[item.name] = item
    STATS.links.count += 1
    findHead rows, index
    return

  index += 1
  row = rows[index]

  if /^http/.test(row)
    _url = url.parse(row)

    link = {}
    link.href     = _url.href
    link.hostname = _url.hostname
    link.pathname = _url.pathname

    LINKS.push _url.href

    desc = findDesc rows, index, ""
    link.desc = desc.desc
    index = desc.index

    index -= 1
    tags = findTag rows, index, []
    link.tags = tags.tag
    index = tags.index

    item.links.push link
    STATS.links.count += 1
    STATS.host.count_all += 1
    STATS.host.count[link.hostname] = STATS.host.count[link.hostname] ? 1
    STATS.host.count[link.hostname] += 1
    findItem rows, index, item

  else if /^#\s[A-Za-zА-Яа-яЁё0-9]/.test(row)
    ITEMS[item.name] = item
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

  if /^#\s[A-Za-zА-Яа-яЁё0-9]/.test(row)
    item = {}
    item.name = row.replace(/^#\s/, '').trim()
    item.plain_name = item.name.toLowerCase()
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
