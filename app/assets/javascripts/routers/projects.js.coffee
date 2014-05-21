#= require ./main

@app or= {}

class app.ProjectsRouter extends app.Main
  routes:
    "projects/:id": "show"

  show: (id) ->
    app.projects.preloaded ->
      # load all discussions for this project
      project = app.projects.get(id)
      project.discussions.fetch()

app.projects_router = new app.ProjectsRouter
