class app.ProjectsShowAvatarView extends Backbone.View
  tagName:      "li"
  className:    "avatar"

  templatePath: "templates/projects/_avatar"
  template: (stuff) -> JST[@templatePath](stuff)

  initialize: ->
    @listenTo @model, "change", @render
    @listenTo @model, "remove", @remove

  render: ->
    result = @template avatar_url: "/people/#{@model.get("created_by_id")}/avatar"
    @$el.html result
    @
