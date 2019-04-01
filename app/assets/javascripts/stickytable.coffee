#= require jquery-sticky-table-header/build/jquery.stickyTableHeader

window.initializeStickyTable = ->
  # Если вернуться на страницу с таблицей через кнопку (back)
  # то появляются дубли заголовков
  $('.StickyTableHeader').remove()

  $('.table-sticky-container').stickyTableHeader
    outsideViewportOnly: false
    topOffset: $('.navbar').height()
