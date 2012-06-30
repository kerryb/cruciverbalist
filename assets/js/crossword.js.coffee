setupPage = ->
  $("head").append '<link rel="stylesheet" href="/assets/css/cruciverbalist.css" type="text/css" />'
  $("#box").siblings().hide()
  $(".discussion, .crossword-spoiler, .discussion-pagination").hide()
  $("#box").after "<div id=\"chat\"></div>"
  $("#chat").load "/chat", setupChat

$ ->
  setupPage() unless $("#crossword").length is 0
