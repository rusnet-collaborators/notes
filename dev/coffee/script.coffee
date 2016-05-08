Rusnet = {}

Rusnet.init_view = ->
  items = $('#notes_wrap h1').addClass 'custom-h1-block'
  menu = $('#menu').find('ul')
  for i in items
    do (i) ->
      text_wrap = i.textContent
      link_wrap = text_wrap.trim()
      link_wrap = link_wrap.replace(/(\s|\.|,|:)/g, '_')
      link_wrap = link_wrap.replace(/_{2,}/g, '_').replace(/_$/g, '')
      link_wrap = link_wrap.replace(/_$/g, '')
      link_wrap = link_wrap.toLowerCase()
      li = $('<li>').attr('role', 'presentation')

      count_link = $('<span>')
        .attr('class', 'badge pull-right')
        .text( $(i).nextUntil('h1').find('a').length )

      link_menu = $('<a>')
        .attr('href', '#' + link_wrap )
        .attr('role', 'menuitem')
        .attr('tabindex', '-1')
        .text(text_wrap)
        .append(count_link)

      link_anchor = $('<a>')
        .attr('name', link_wrap)
        .attr('href', '#' + link_wrap)
        .attr('class', 'block')
        .text(text_wrap)

      $(i).text('')
      $(i).append(link_anchor)

      $(li).append(link_menu)
      $(menu).append(li)
      return
  return
        
Rusnet.add_target_link = ->
  items = $('#notes_wrap p a')
  for i in items
    do (i) ->
      $(i).attr('target', '_blank')
        .text( i.textContent.replace(/(http|https):\/\/(www){0,1}\.{0,1}/, '') )
        .text( i.textContent.replace(/\/$/, '') )
      $('<br/>').insertAfter(i)
      return
  return

Rusnet.add_tag_link = ->
  tags = $('#notes_wrap ul li')
  for i in tags
    do (i) ->
      link_tag = $('<a>')
        .attr('href', '#tag-' + i.textContent)
        .attr('class', 'white')
        .text(i.textContent)
      $(i)
        .attr('class', 'label label-primary')
        .text('')
        .append(link_tag)
      return
  return

Rusnet.wrap_content = ->
  $items = $('#notes_wrap h1')
  for i in $items
    do (i) ->
      $(i)
        .on 'click', (event) ->
          event.preventDefault
          $(@).next('.wrap').toggleClass 'show', 500
        .nextUntil('h1')
        .wrapAll $('<div>').attr('class', 'wrap')
      return
  return

Rusnet.research_engine = ->
  result = window.result = {}

  rowsing = (_count_row, _order, _hash, _string, cb) ->
    array = _string.split("")

    [0..._count_row].forEach (index) ->
      index_1 = 0 + index
      index_2 = _order + index
      row = array.slice(index_1, index_2).join("")
      result[_order + ""][_hash]['list'].push row
      result[_order + "g"].push row
      return

    if cb
      cb()
    return

  scan = (_string, _el) ->
    length = _string.length
    [1..length].forEach (order) ->
      count_row = length - (order - 1)

      result[order + ""] = result[order + ""] or {}
      result[order + "g"] = result[order + "g"] or []
      result[order + ""][_string] = result[order + ""][_string] or {}
      result[order + ""][_string]['list'] = result[order + ""][_string]['list'] or []
      result[order + ""][_string]['el'] = result[order + ""][_string]['el'] or _el
      result['elements'] = result['elements'] or []
      if result['elements'].indexOf(_el) is -1
        result['elements'].push _el

      rowsing count_row, order, _string, _string
      return
    return

  headers = $('#notes_wrap h1.custom-h1-block').get()
  headers.forEach (el) ->
    text = $(el).text().trim().toLowerCase()
    scan text, el
    return
  return

Rusnet.bind = ->
  $('#findString').on 'keyup', (event) ->
    event = event or window.event
    target = event.target or event.srcElement
    value = $(target).val().trim().toLowerCase()

    if value isnt "" and value isnt undefined and value isnt null
      Rusnet.search value

    else
      Rusnet.show_all()
    return

  $('img').on 'click', (event) ->
    event = event or window.event
    target = event.target or event.srcElement
    if settings.img.index < (settings.img.count - 1) then settings.img.index += 1 else settings.img.index = 0
    img = settings.img.list[settings.img.index]
    $(target).attr 'src', ["/img/", img].join("")
  return

Rusnet.show_all = ->
  result.elements.forEach (el) ->
    $(el).show()
    return
  return

Rusnet.search = (string) ->
  length = string.length
  find = []
  hide = []

  result.elements.forEach (el) ->
    $(el).hide()
    return

  if result[length + "g"].indexOf(string) > -1
    keys = Object.keys result[length + ""]
    keys.forEach (key) ->
      result[length + ""][key]['list'].forEach (item, index, arr) ->
        if item is string
          if find.indexOf(key) is -1
            find.push key
            $( result[length + ""][key]['el'] ).show()

          if hide.indexOf(key) > -1
            hide.splice hide.indexOf(key), 1

        else
          if find.indexOf(key) is -1 and hide.indexOf(key) is -1
            hide.push key
            $( result[length + ""][key]['el'] ).hide()
        return
      return
  return

Rusnet.get_random = (min, max) ->
  random = Math.floor(Math.random() * (max - min + 1) + min)
  return random

Rusnet.set_img = ->
  $.ajax
    url: '/json/config.json'
    type: 'get'
    dataType: 'json'
    success: (data) ->
      if data.images
        length = data.images.length
        settings.img.list = data.images
        settings.img.count = length
        settings.img.index = Rusnet.get_random 0, length
        img = data.images[ settings.img.index ]
        $('img').attr 'src', ["/img/", img].join("")
        $('img').removeClass 'hide'

    error: (err) ->
      console.log "err:", err
      return
  return

$ ->
  settings = window.settings =
    img:
      index: 0
      count: 0
      list: []

  Rusnet.init_view()
  Rusnet.add_target_link()
  Rusnet.add_tag_link()
  Rusnet.wrap_content()
  Rusnet.research_engine()
  Rusnet.bind()
  Rusnet.set_img()
