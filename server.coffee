express = require 'express'
morgan = require 'morgan'
instagram = require 'instagram-node-lib'
bodyParser = require 'body-parser'
twitterAPI = require 'twitter'

config = require './config.js'

instagram.set 'client_id', config.INSTAGRAM_CLIENT_ID
instagram.set 'client_secret', config.INSTAGRAM_CLIENT_SECRET
instagram.set 'callback_url', config.INSTAGRAM_CALLBACK_URL


app = express()
server = require('http').createServer(app)
io = require('socket.io').listen(server, path: "/StreamPanel/socket.io")

io.on 'connection', (socket)->
    console.log "New socket connected #{socket.id}"

    twitter.get 'search/tweets', 
        q: '#'+config.HASHTAG
        #result_type: 'recent'
        count: 15
        include_entities: false
        , (error, tweets, response) ->
            if not error
                socket.emit 'tweets', tweets.statuses.filter tweet_filter
            else
                console.log "Error Twitter:"
                console.log error

    socket.on 'disconnect', (socket)->
        console.log "Socket disconnected #{socket.id}"

app.use bodyParser.json()  # for parsing application/json
app.use bodyParser.urlencoded extended: true  # for parsing application/x-www-form-urlencoded
app.use morgan ':method :url :status :response-time ms - :res[content-length]'
app.use express.static __dirname + '/public'

app.get '/hashtag', (req, res) ->
    res.send config.HASHTAG

# TWITTER PART

tweet_filter = (t)->
    #console.log 'tweet_filter'
    #console.log t
    t.source?.indexOf('instagram') == -1 and
    typeof t.retweeted_status is 'undefined'

twitter = new twitterAPI
    consumer_key: config.TWITTER_CONSUMER_KEY
    consumer_secret: config.TWITTER_CONSUMER_SECRET
    access_token_key: config.TWITTER_ACCESS_TOKEN
    access_token_secret: config.TWITTER_ACCESS_SECRET

twitter.stream 'statuses/filter', 
    track: '#'+config.HASHTAG
    , (stream) ->
      stream.on 'data', (tweet)->
        if tweet_filter tweet
            io.emit 'newTweet', tweet

      stream.on 'error', (error)->
        console.error error

# END OF TWITTER

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