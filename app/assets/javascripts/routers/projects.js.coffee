#= require ./main
#= require ../views/projects/show

@app or= {}

class app.ProjectsRouter extends app.Main
  routes:
    "projects/:id": "show"

  show: (id) ->
    app.projects.preloaded ->
      project = app.projects.get(id)

      view = new app.ProjectsShowView model: project
      app.present view

      # load all discussions for this project
      project.discussions.fetch success: ->
        project.discussions.models[0].comments.fetch()

app.projects_router = new app.ProjectsRouter
