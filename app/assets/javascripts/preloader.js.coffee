@app or= {}

app.setup_preloader = (collection) ->
  collection.preloaded_callbacks or= []

  collection.preloaded = (cb) ->
    collection.preloaded_callbacks.push cb

  collection.on "sync", (again_collection, response, options) ->
    for cb in collection.preloaded_callbacks
      do (cb) -> cb(collection, response, options)
    collection.preloaded = (cb) -> cb(collection, response, options)
