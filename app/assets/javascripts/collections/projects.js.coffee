#= require ../models/project

@app or= {}

class app.Projects extends Backbone.Collection
  model: app.Project
