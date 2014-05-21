#= require ../subcollection

@app or= {}

class app.Discussion extends Backbone.Model
  initialize: ->
    @subcollection_filter = (model) =>
      id = if model.attributes
        model.attributes.parent.id
      else
        model.parent.id
      id is @id
    @comments = new app.Subcollection
      parent: app.comments,
      filter: @subcollection_filter
    @comments.url = "/discussions/#{@id}/comments"
  urlRoot: "/discussions"
