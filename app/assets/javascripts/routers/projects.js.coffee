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
        current = 0
        total   = project.discussions.length

        next = ->
          if current < total
            setTimeout ->
              project.discussions.models[current].comments.fetch()
              current += 1
              setTimeout next, 5
            , 30

        next()

app.projects_router = new app.ProjectsRouter
