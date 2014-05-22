@app or= {}

app.events =
  process: (payload) ->
    message    = JSON.parse(payload)
    data       = message.data
    type       = data?.type
    operation  = @operations[message.operation]
    collection = @collection_types[type]

    if collection and operation
      operation(collection(), data)
    else
      console.error "I don't know what to do with this", message

  collection_types:
    account:    -> app.accounts
    comment:    -> app.comments
    discussion: -> app.discussions
    person:     -> app.people
    project:    -> app.projects

  operations:
    create: (collection, data) ->
      app.events.operations.update(collection, data)

    update: (collection, data) ->
      collection.add data, merge: true

    delete: (collection, data) ->
      collection.remove data.id
