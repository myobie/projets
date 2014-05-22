@app or= {}

class app.DiscussionsShowView extends Backbone.View
  className:    "discussions-show"

  templatePath: "templates/discussions/show"
  template: (stuff) -> JST[@templatePath](stuff)

  events:
    "submit .comments-form form": "create_new_comment"

  initialize: ->
    @listenTo @model,          "change", @render
    @listenTo @model.comments, "reset",  @reset_comments
    @listenTo @model.comments, "add",    @add_comment
    @comment_views = []

  create_new_comment: (e) =>
    e.preventDefault()

    parent = { id: @model.id, type: "Discussion" }
    content = @$(".comments-form textarea").val()
    attributes = parent: parent, content: content
    comment = @model.comments.create attributes, wait: true
    console.log comment

    @$(".comments-form textarea").val "" # clear the input

  reset_comments: ->
    view.remove() for view in @comment_views

    @comment_views = []
    @model.comments.each (comment) => @add_comment comment

  add_comment: (comment) =>
    view = new app.DiscussionCommentView model: comment
    view.render()
    @$(".comments-list").append view.$el
    @comment_views.push view

  render: ->
    result = @template
      discussion: @model
      avatar_url: "/people/#{window.current_user_id}/avatar"
    @$el.html result
    @reset_comments()
    @


class app.DiscussionCommentView extends Backbone.View
  tagName: "article"

  templatePath: "templates/discussions/_comment"
  template: (stuff) -> JST[@templatePath](stuff)

  initialize: ->
    @listenTo @model, "change", @render
    @listenTo @model, "remove", @remove

  render: ->
    result = @template
      avatar_url: "/people/#{@model.get("created_by_id")}/avatar"
      content: @model.get("content")

    @$el.html result
    @
