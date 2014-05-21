#= require ../bootstrap

@app or= {}

class app.Main extends Backbone.Router
  execute: (callback, args) =>
    app.bootstrap()
    callback.apply @, args

app.navigate = (path) ->
  Backbone.history.navigate path, trigger: true
