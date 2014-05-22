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

  name: ->
    @get "name"

  summary: ->
    last_comment = @comments.last()
    last_comment.excerpt() if last_comment

  comments_count: ->
    if @comments.length > 0
      word = if @comments.length == 1 then "comment" else "comments"
      "#{@comments.length} #{word}"
