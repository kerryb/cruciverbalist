addStylesheet = ->
  $("head").append '<link rel="stylesheet" href="/assets/css/cruciverbalist.css" type="text/css" />'

addHeader = ->
  $("#wrapper").prepend '<div id="cruciverbalist-header"></div>'
  $("#cruciverbalist-header").load "/header"

setupPage = ->
  $("#header, #promo, .more-in-series, .discussion, .crossword-spoiler, .discussion-pagination").hide()
  $("#box").after "<div id=\"chat\"></div>"
  $("#chat").load "/chat", setupChat

$ ->
  addStylesheet()
  addHeader()
  setupPage() unless $("#crossword").length is 0
