#= require ../models/discussion

@app or= {}

class app.Discussions extends Backbone.Collection
  model: app.Discussion
