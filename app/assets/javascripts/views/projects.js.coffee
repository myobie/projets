@app or= {}

class app.ProjectsView extends Backbone.View
  templatePath: "templates/projects_list"
  template: (stuff) -> JST[@templatePath](stuff)

  initialize: ->
    @listenTo @collection, "add", @add_project
    @listenTo @collection, "reset", @reset_projects
    @project_item_views = []

  add_project: (project) ->
    view = new app.ProjectItemView model: project
    view.render()
    @$(".projects-list").append view.$el
    @project_item_views.push view

  reset_projects: ->
    view.remove() for view in @project_item_views
    @collection.each (project) => @add_project project

  render: ->
    result = @template projects: @collection
    @$el.html result
    @reset_projects()
    @

class app.ProjectItemView extends Backbone.View
  templatePath: "templates/project_item"
  template: (stuff) -> JST[@templatePath](stuff)

  initialize: ->
    @listenTo @model, "change", @render
    @listenTo @model, "remove", @remove

  render: ->
    result = @template project: @model
    @$el.html result
    @
