# Stream Panel
> Stream Instagram photos and tweets tagged in real time.

## Configuration
The `config.coffee` file has all settings for Instagram and Twitter API and also the Hashtag to stream.

## Running
Install dependencies

    npm install 
    bower install

This project uses Gulp to run tasks. Run Gulp to compile CoffeeScript and Sass files and watch for modifications.
    
    gulp
Finnaly you can run the application.
    
    node server.js

## Testing locally
To receive stream updates from Instagram, it needs to access your server to post updates.
You can use [localtunnel.me](https://localtunnel.me/) to create a tunnel to serve your localhost to the Internet.

