# Key Codes
ENTER = 13
BACKSPACE = 8

# Updates Status
status = (status) ->
  $('#status').text status

# Appends a new message
output = (message) ->
  $('<p>').text(message).appendTo $('#output-container')

window.onload = ->

  # Socket IO
  socket = io.connect()
  socket.on 'connect', -> status 'Connected'
  socket.on 'disconnect', -> status 'Disconnected'
  socket.on 'reconnecting', (seconds) -> status "Reconnecting in #{seconds/1000}"
  socket.on 'reconnect', -> status 'Reconnected'
  socket.on 'reconnect_failed', -> status 'Failed to reconnect'
  socket.on 'message', (message) -> output message

  # Key Down
  $(document).keydown (event)->
    input = $('#input')
    text = input.text()
    if event.which is BACKSPACE
      event.preventDefault()
      input.text text.substring(0, text.length - 1)

  # Key Press
  $(document).keypress (event)->
    code = event.which
    input = $('#input')
    text = input.text()
    switch code
      when BACKSPACE then event.preventDefault() # firefox
      when ENTER
        output '> ' + text
        socket.send text
        input.text ''
      else input.text text + String.fromCharCode(code)
