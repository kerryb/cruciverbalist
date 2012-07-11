addStylesheet = ->
  $("head").append '<link rel="stylesheet" href="/assets/css/cruciverbalist.css" type="text/css" />'

addHeader = ->
  $("#wrapper").prepend '<div id="cruciverbalist-header"></div>'
  $("#cruciverbalist-header").load "/header"

setupPage = ->
  $("#header, #promo, .more-in-series, .discussion, .crossword-spoiler, .discussion-pagination").hide()
  $("#box").after "<div id=\"cruciverbalist-sidebar\"></div>"
  $("#cruciverbalist-sidebar").load "/sidebar#{location.pathname}", ->
    crosswordID = $("#cruciverbalist-sidebar #info").attr("data-crossword-id")
    setupChat crosswordID
    setupGrid crosswordID

$ ->
  addStylesheet()
  addHeader()
  setupPage() unless $("#crossword").length is 0
