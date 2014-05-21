#= require ../models/account

@app or= {}

class app.Accounts extends Backbone.Collection
  model: app.Account
  url: "/accounts"
