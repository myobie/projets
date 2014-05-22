@app or= {}

class app.AccountsView extends Backbone.View
  templatePath: "templates/accounts_list"
  template: (stuff) -> JST[@templatePath](stuff)

  initialize: ->
    @listenTo @collection, "add", @add_account
    @listenTo @collection, "reset", @reset_accounts
    @account_item_views = []

  add_account: (account) ->
    view = new app.AccountItemView model: account
    view.render()
    @$(".accounts-list").append view.$el
    @account_item_views.push view

  reset_accounts: ->
    view.remove() for view in @account_item_views
    @collection.each (account) => @add_account account

  render: ->
    result = @template accounts: @collection
    @$el.html result
    @reset_accounts()
    @

class app.AccountItemView extends Backbone.View
  templatePath: "templates/account_item"
  template: (stuff) -> JST[@templatePath](stuff)

  initialize: ->
    @listenTo @model, "change", @render
    @listenTo @model, "remove", @remove

  render: ->
    result = @template account: @model
    @$el.html result
    @
