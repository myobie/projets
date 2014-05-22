#= require ./avatar

@app or= {}

class app.ProjectsShowDiscussionView extends Backbone.View
  tagName:      "article"
  className:    "discussion"

  templatePath: "templates/projects/_discussion"
  template: (stuff) -> JST[@templatePath](stuff)

  initialize: ->
    @listenTo @model, "change", @render
    @listenTo @model, "remove", @remove
    @listenTo @model.comments, "add", @add_avatar
    @listenTo @model.comments, "reset", @reset_avatars
    @listenTo @model.comments, "add remove reset", @render_comments_count
    @listenTo @model.comments, "add remove reset", @render_summary
    @avatar_views = []

  reset_avatars: ->
    view.remove() for view in @avatar_views

    @avatar_views = []
    @model.comments.each (comment) => @add_avatar comment

  add_avatar: (comment) =>
    already_there = _.find(@avatar_views, (v) -> v.model.get("created_by_id") is comment.get("created_by_id"))
    unless already_there
      view = new app.ProjectsShowAvatarView model: comment
      view.render()
      @$(".avatars-list").append view.$el
      @avatar_views.push view

  render_comments_count: ->
    @$(".comments-count").html @model.comments_count()

  render_summary: ->
    @$(".summary").html @model.summary()

  render: ->
    result = @template discussion: @model
    @$el.html result
    @reset_avatars()
    @

