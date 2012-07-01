setupPage = ->
  $("head").append '<link rel="stylesheet" href="/assets/css/cruciverbalist.css" type="text/css" />'
  $("#promo, .more-in-series, .discussion, .crossword-spoiler, .discussion-pagination").hide()
  $("#box").after "<div id=\"chat\"></div>"
  $("#header").load "/header"
  $("#chat").load "/chat", setupChat

$ ->
  setupPage() unless $("#crossword").length is 0
