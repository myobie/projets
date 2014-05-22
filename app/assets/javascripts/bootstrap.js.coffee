#= require socket
#= require views/accounts
#= require views/projects

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

  app.accounts_view = new app.AccountsView collection: app.accounts
  app.accounts_view.setElement $("#accounts").get(0)
  app.accounts_view.render()

  app.projects_view = new app.ProjectsView collection: app.projects
  app.projects_view.setElement $("#projects").get(0)
  app.projects_view.render()

  app.accounts.fetch()
  app.projects.fetch()

  app.socket.connect()
