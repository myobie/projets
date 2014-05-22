#= require ./discussion

@app or= {}

class app.ProjectsShowView extends Backbone.View
  className:    "projects-show"

  templatePath: "templates/projects/show"
  template: (stuff) -> JST[@templatePath](stuff)

  initialize: ->
    @listenTo @model.discussions, "reset",  @reset_discussions
    @listenTo @model.discussions, "add",    @add_discussion
    @discussion_views = []

  reset_discussions: ->
    view.remove() for view in @discussion_views

    @discussion_views = []
    @model.discussions.map (discussion) => @add_discussion discussion

  add_discussion: (discussion) =>
    view = new app.ProjectsShowDiscussionView model: discussion
    view.render()
    @$(".discussions-list").append view.el
    @discussion_views.push view

  render: ->
    result = @template()
    @$el.html result
    @reset_discussions()
    @

