$ ->
  window.Message = Backbone.Model.extend
    url: "/chat/messages"

  window.Conversation = Backbone.Collection.extend
    model: Message

    initialize: (models, options) ->
      @bind "add", options.view.addMessage

  MessageView = Backbone.View.extend
    tagname: "li"
    template: $("#message-template").template()

    render: ->
      conversation_list = $("#conversation")
      element = jQuery.tmpl(@template, @model.toJSON())
      $(@el).html element
      conversation_list.scrollTop(conversation_list.attr("scrollHeight") - conversation_list.height())
      this

  AppView = Backbone.View.extend
    el: $("#chat")

    initialize: ->
      _.bindAll this, "addMessage"
      @conversation = new Conversation null, view: this
      @input = @$("#new-message")
      @input.focus()

    events:
      "keypress #new-message": "createOnEnter"

    createOnEnter: (e) ->
      return unless e.keyCode is 13
      value = @input.val()
      return unless value
      @conversation.create content: value
      @input.val ""
      e.preventDefault()

    addMessage: (message) ->
      view = new MessageView(model: message)
      @$("#conversation").append view.render().el

  appview = new AppView
