# Module dependencies

express = require 'express'
app = express.createServer()
io = require('socket.io').listen app

app.configure ->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'jade'
  app.set 'view options', {layout: false}
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static __dirname + '/public'
  app.use express.errorHandler({ dumpExceptions: true, showStack: true })

app.get '/', (req, res) ->
  res.render 'index', {title: 'Hello'}

app.listen 3000

io.sockets.on 'connection', (socket) ->
  socket.send 'Your adventure awaits...'
  socket.on 'message', (message) ->
    io.sockets.send message
