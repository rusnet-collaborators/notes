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
  cache = window.cache = {}
  names = window.names = []

  headers = $('h1.custom-h1-block').get()
  headers.forEach (el) ->
    text = $(el).text().trim().toLowerCase()
    names.push text
    cache[text] = el
    return
  return

Rusnet.search_engine = ->
  debounce = (fn, delay) ->
    timer = null
    ->
      context = this
      args = arguments
      clearTimeout timer
      timer = setTimeout((->
        fn.apply context, args
        return
      ), delay)
      
  headers = $('h1.custom-h1-block')
  $wrap = $('.wrap')
  $search_string = $('#findString')
  
  $('#findString').on 'keyup', debounce(((e) ->
    code = e.keyCode or e.which
    search = $search_string.val()
    if search
      headers.each (index, item) ->
        $item = $(item)
        text = $item.find('a').text()
        $wrap_inner = $item.next('.wrap')
        if new RegExp(search, 'i').test(text)
          $item.show 0
        else
          $wrap_inner.removeClass 'show', 0
          $item.hide 0
        return
    else
      headers.show 0
      $wrap.removeClass 'show', 0
    return
  ), 300)

$ ->
  Rusnet.init_view()
  Rusnet.add_target_link()
  Rusnet.add_tag_link()
  Rusnet.wrap_content()
  #Rusnet.search_engine()
  Rusnet.research_engine()
