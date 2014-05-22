@app or= {}

class app.Account extends Backbone.Model
  name: -> @get "name"
