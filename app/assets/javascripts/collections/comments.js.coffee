#= require ../models/comment

@app or= {}

class app.Comments extends Backbone.Collection
  model: app.Comment
