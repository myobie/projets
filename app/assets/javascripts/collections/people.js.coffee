#= require ../models/person

@app or= {}

class app.People extends Backbone.Collection
  model: app.Person
