#= require socket

@app or= {}

app.bootstrap = _.once ->
  # setup master collections
  app.accounts    = new app.Accounts
  app.comments    = new app.Comments
  app.discussions = new app.Discussions
  app.people      = new app.People
  app.projects    = new app.Projects

  app.setup_preloader app.accounts
  app.setup_preloader app.projects

  app.accounts.fetch()
  app.projects.fetch()

  app.socket.connect()
