$ ->
  window.Message = Backbone.Model.extend content: ""

  window.Conversation = Backbone.Collection.extend(
    initialize: (models, options) ->
      @bind "add", options.view.addMessage
  )

  AppView = Backbone.View.extend(
    el: $("#chat")
    initialize: ->
      @conversation = new Conversation null, view: this
      @input = @$("#new-message")

    events:
      "keypress #new-message": "createOnEnter"

    createOnEnter: (e) ->
      return  unless e.keyCode is 13
      value = @input.val()
      return  unless value
      message = new Message(content: value)
      @conversation.add message
      @input.val ""
      e.preventDefault()

    addMessage: (model) ->
      conversation_list = $("#conversation")
      conversation_list.append "<li>#{model.get "content"}</li>"
      conversation_list.scrollTop(conversation_list.attr("scrollHeight") - conversation_list.height())
  )
  appview = new AppView
  $("#new-message").focus()
