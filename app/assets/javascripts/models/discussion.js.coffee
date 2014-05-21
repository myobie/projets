#= require ../subcollection

@app or= {}

class app.Discussion extends Backbone.Model
  initialize: ->
    @subcollection_filter = (model) =>
      id = if model.attributes
        model.attributes.parent.id
      else
        model.parent.id

      type = if model.attributes
        model.attributes.parent.type
      else
        model.parent.type

      id is @id and type is "discussion"
    @comments = new app.Subcollection
      parent: app.comments,
      filter: @subcollection_filter
    @comments.url = "/discussions/#{@id}/comments"
  urlRoot: "/discussions"
