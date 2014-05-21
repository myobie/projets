#= require ./main

@app or= {}

class app.HomeRouter extends app.Main
  routes:
    "": "home"

  home: ->
    # go the first project so we have something to look at
    app.projects.preloaded ->
      first_project = app.projects.models[0]
      app.navigate "projects/#{first_project.id}" if first_project

app.home_router = new app.HomeRouter
