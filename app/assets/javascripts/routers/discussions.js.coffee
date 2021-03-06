#= require ./main

@app or= {}

class app.DiscussionsRouter extends app.Main
  routes:
    "discussions/:id": "show"

  execute: (callback, args) =>
    app.bootstrap()
    callback.apply @, args

  show: (id) ->
    app.projects.preloaded ->
      discussion = app.discussions.get(id)

      unless discussion
        # fetch the discussion if it's not already in memory
        discussion = new app.Discussion id: id
        app.discussions.add discussion
        discussion.fetch()

      view = new app.DiscussionsShowView model: discussion
      app.present view

      # load all the comments for this discussion
      discussion.comments.fetch()

app.discussions_router = new app.DiscussionsRouter
