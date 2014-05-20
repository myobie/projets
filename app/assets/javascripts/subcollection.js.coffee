@app or= {}

class app.Subcollection extends Backbone.Collection
  constructor: (options) ->
    @parent = options.parent
    @filter = options.filter
    delete options.parent
    delete options.filter

    filtered_models = _.filter @parent.models, @filter
    @model = @parent.model

    @setupListeners()

    super filtered_models, options

  add: (model, options) ->
    if @filter model
      super model, options

  push: (model, options) ->
    if @filter model
      super model, options

  unshift: (model, options) ->
    if @filter model
      super model, options

  reset: (models, options) ->
    models = _.filter(models, @filter)
    super models, options

  set: (models, options) ->
    models = _.filter(models, @filter)
    super models, options

  setupListeners: ->
    @listenTo @parent, "add", (model, collection, options) =>
      if @filter(model)
        options.fromParent = true
        @add model, options

    @on "add", (model, collection, options) =>
      unless options.fromParent
        @parent.add model, options

    @listenTo @parent, "remove", (model, collection, options) =>
      options.fromParent = true
      @remove model, options

    @on "remove", (model, collection, options) =>
      unless options.fromParent
        @parent.remove model, options

    @listenTo @parent, "reset", (collection, options) =>
      options.fromParent = true
      @reset collection.models, options

    @on "reset", (collection, options) =>
      unless options.fromParent
        @parent.reset @models

    # not doing "sort" for now
