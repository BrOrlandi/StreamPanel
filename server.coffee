express = require 'express'
morgan = require 'morgan'
instagram = require 'instagram-node-lib'
bodyParser = require 'body-parser'
config = require './config.js'

instagram.set 'client_id', config.INSTAGRAM_CLIENT_ID
instagram.set 'client_secret', config.INSTAGRAM_CLIENT_SECRET
instagram.set 'callback_url', config.INSTAGRAM_CALLBACK_URL

app = express()
server = require('http').createServer(app)
io = require('socket.io').listen(server)

io.on 'connection', (socket)->
    console.log "New socket connected #{socket.id}"

    instagram.tags.recent 
        name: config.HASHTAG
        complete: (data)->
            socket.emit 'instagramFirst', firstData: data

    socket.on 'sendServer', (data)->
        console.log "Data sent by client: #{data}"
        socket.emit 'callClient','you called Server'


io.on 'disconnect', (socket)->
    console.log "Socket disconnected #{socket.id}"

app.use bodyParser.json()  # for parsing application/json
app.use bodyParser.urlencoded extended: true  # for parsing application/x-www-form-urlencoded
app.use morgan ':method :url :status :response-time ms - :res[content-length]'
app.use express.static __dirname + '/public'

app.get '/hashtag', (req, res) ->
    res.send config.HASHTAG


# INSTAGRAM PART

app.get '/instagram_callback', (req,res)->
    handshake =  instagram.subscriptions.handshake req, res

app.get '/instagram_client', (req,res) ->
    res.send config.INSTAGRAM_CLIENT_ID

app.post '/instagram_callback', (req, res) ->
    io.emit 'instagramUpdate', {}
    res.end();

instagram.subscriptions.subscribe 
    object: 'tag'
    object_id: config.HASHTAG
    aspect: 'media'
    type: 'subscription'
    id: '#'

# END OF INSTAGRAM

server.listen 8000
console.log 'Server started at port 8000'