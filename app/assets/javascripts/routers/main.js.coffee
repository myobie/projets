#= require ../bootstrap

@app or= {}

class app.Main extends Backbone.Router
  execute: (callback, args) =>
    app.bootstrap()
    callback.apply @, args

app.$main_el = $("#main")
app.main_el  = app.$main_el.get(0)
app.currently_presented_view = null

app.present = (view) ->
  if app.currently_presented_view
    app.currently_presented_view.remove()
    app.currently_presented_view = null

  app.currently_presented_view = view
  view.setElement app.main_el
  view.render()

app.navigate = (path) ->
  Backbone.history.navigate path, trigger: true
