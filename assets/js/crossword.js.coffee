addHeader = ->
  $("#header").before '<div id="cruciverbalist-header"></div>'
  $("#cruciverbalist-header").load "/header"

setupPage = ->
  $("head").append '<link rel="stylesheet" href="/assets/css/cruciverbalist.css" type="text/css" />'
  $("#header, #promo, .more-in-series, .discussion, .crossword-spoiler, .discussion-pagination").hide()
  $("#box").after "<div id=\"chat\"></div>"
  $("#chat").load "/chat", setupChat

$ ->
  addHeader()
  setupPage() unless $("#crossword").length is 0
