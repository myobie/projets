#= require ../subcollection

@app or= {}

class app.Project extends Backbone.Model
  initialize: ->
    @subcollection_filter = (model) =>
      id = if model.attributes
        model.attributes.project_id
      else
        model.project_id
      id is @id
    @discussions = new app.Subcollection
      parent: app.discussions,
      filter: @subcollection_filter
    @discussions.url = "/projects/#{@id}/discussions"
