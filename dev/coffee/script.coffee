get_random = (min, max) ->
  min = min ? 0
  max = max ? 0

  if typeof(min) is 'number' and typeof(max) is 'number'
    random = Math.floor(Math.random() * (max - min + 1) + min)
  else
    random = null
  random

class Rusnet

  @init_view = ->
    items = $('#notes_wrap h1').addClass 'custom-h1-block'
    menu = $('#menu').find('ul')
    for i in items
      do (i) ->
        text_wrap = i.textContent
        link_wrap = text_wrap.trim()
        link_wrap = link_wrap.replace /(\s|\.|,|:)/g, '_'
        link_wrap = link_wrap.replace(/_{2,}/g, '_').replace(/_$/g, '')
        link_wrap = link_wrap.replace /_$/g, ''
        link_wrap = link_wrap.toLowerCase()
        li = document.createElement 'li'
        $(li).attr 'role', 'presentation'

        count_link = document.createElement 'span'
        $(count_link)
          .attr 'class', 'badge pull-right'
          .text( $(i).nextUntil('h1').find('a').length )

        link_menu = document.createElement 'a'
        $(link_menu)
          .attr 'href', '#' + link_wrap
          .attr 'role', 'menuitem'
          .attr 'tabindex', '-1'
          .text text_wrap
          .append count_link

        link_anchor = document.createElement 'a'
        $(link_anchor)
          .attr 'name', link_wrap
          .attr 'href', '#' + link_wrap
          .attr 'class', 'block'
          .text text_wrap

        $(i).text('')
        $(i).append(link_anchor)

        $(li).append(link_menu)
        $(menu).append(li)
        return
    return
        
  @add_target_link = ->
    items = $('#notes_wrap p a')
    for i in items
      do (i) ->
        $(i).attr('target', '_blank')
          .text( i.textContent.replace(/(http|https):\/\/(www){0,1}\.{0,1}/, '') )
          .text( i.textContent.replace(/\/$/, '') )
        $('<br/>').insertAfter(i)
        return
    return

  @add_tag_link = ->
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

  @wrap_content = ->
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

  @research_engine = ->
    rowsing = (_count_row, _order, _hash, _string, cb) ->
      array = _string.split("")

      [0..._count_row].forEach (index) ->
        index_1 = 0 + index
        index_2 = _order + index
        row = array.slice(index_1, index_2).join("")
        database[_order + ""][_hash]['list'].push row
        database[_order + "g"].push row
        return

      if cb
        cb()
      return

    scan = (_string, _el) ->
      length = _string.length
      [1..length].forEach (order) ->
        count_row = length - (order - 1)

        database[order + ""] = database[order + ""] or {}
        database[order + "g"] = database[order + "g"] or []
        database[order + ""][_string] = database[order + ""][_string] or {}
        database[order + ""][_string]['list'] = database[order + ""][_string]['list'] or []
        database[order + ""][_string]['el'] = database[order + ""][_string]['el'] or _el
        database['elements'] = database['elements'] or []
        if database['elements'].indexOf(_el) is -1
          database['elements'].push _el

        rowsing count_row, order, _string, _string
        return
      return

    headers = window.headers = $('#notes_wrap h1.custom-h1-block').get()
    headers.forEach (el) ->
      text = $(el).text().trim().toLowerCase()
      scan text, el
      return
    return

  @bind = ->
    $('#findString').on 'keyup', (event) ->
      event = event or window.event
      target = event.target or event.srcElement
      value = $(target).val().trim().toLowerCase()

      if value isnt "" and value isnt undefined and value isnt null
        Rusnet.search value

      else
        Rusnet.show_all()
      return

    $('#top').on 'click', (event) ->
      event = event or window.event
      target = event.target or event.srcElement

      if settings.images.index < (settings.images.count - 1) then settings.images.index += 1 else settings.images.index = 0

      url = settings.images.list[settings.images.index]

      $('#top').html """
<div class="cssload-wrap">
  <div class="cssload-container">
  <span class="cssload-dots"></span>
  <span class="cssload-dots"></span>
  <span class="cssload-dots"></span>
  <span class="cssload-dots"></span>
  <span class="cssload-dots"></span>
  <span class="cssload-dots"></span>
  <span class="cssload-dots"></span>
  <span class="cssload-dots"></span>
  <span class="cssload-dots"></span>
  <span class="cssload-dots"></span>
</div>
</div>
      """

      img_w = new Image()
      $(img_w).on 'load', (event) ->
        $('#top').html img_w
        return

      img_w.src = ['/img/', url].join("")
      return
    return

  @show_all = ->
    database.elements.forEach (el) ->
      $(el).show()
      return
    return

  @search = (string) ->
    length = string.length
    find = []
    hide = []

    database.elements.forEach (el) ->
      $(el).hide()
      return

    if database[length + "g"].indexOf(string) > -1
      keys = Object.keys database[length + ""]
      keys.forEach (key) ->
        database[length + ""][key]['list'].forEach (item, index, arr) ->
          if item is string
            if find.indexOf(key) is -1
              find.push key
              $(database[length + ""][key]['el']).show()

            if hide.indexOf(key) > -1
              hide.splice hide.indexOf(key), 1

          else
            if find.indexOf(key) is -1 and hide.indexOf(key) is -1
              hide.push key
              $(database[length + ""][key]['el']).hide()
          return
        return
    return

  @set_img = ->
    $.ajax
      url: '/json/config.json'
      type: 'get'
      dataType: 'json'
      async: false
      success: (data) ->
        if data.images
          length = data.images.length
          settings.images.list = data.images
          settings.images.count = length
          settings.images.index = get_random 0, length - 1
          img = data.images[ settings.images.index ]
          $('img').attr 'src', ["/img/", img].join("")
          $('img').removeClass 'hide'

      error: (err) ->
        return
    return

$ ->
  settings = window.settings =
    images:
      index: 0
      count: 0
      list: []

  database = window.database = {}

  Rusnet.init_view()
  Rusnet.add_target_link()
  Rusnet.add_tag_link()
  Rusnet.wrap_content()
  Rusnet.research_engine()
  Rusnet.set_img()
  Rusnet.bind()
