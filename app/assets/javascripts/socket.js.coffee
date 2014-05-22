#= require events

@app or= {}

app.socket =
  callbacks:
    onopen: (event) ->
      console.log "Websocket connection opened", event
    onclose: (event) ->
      console.log "Websocket connection closed", event
    onerror: (event) ->
      console.error "There was an error with the websocket connection", event
    onmessage: (event) ->
      console.log "Recieved message", event.data
      app.events.process(event.data, event)

  connect: _.once ->
    host                  = window.location.host
    port                  = window.websockets_port
    user_id               = window.current_user_id
    token                 = encodeURIComponent window.current_access_token
    url                   = "ws://#{host}:#{port}/users/#{user_id}?access_token=#{token}"

    @connection           = new WebSocket url

    @connection.onopen    = @callbacks.onopen
    @connection.onclose   = @callbacks.onclose
    @connection.onmessage = @callbacks.onmessage
    @connection.onerror   = @callbacks.onerror

    @connection
