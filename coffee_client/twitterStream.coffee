app = angular.module 'streamPanelApp'

app.controller 'twitterStreamController', ['$scope','mySocket','$timeout'
($scope,mySocket,$timeout) ->

    $scope.tweets = []

    mySocket.on 'tweets', (data)->
        $scope.tweets = data
        applyTooltip()

    mySocket.on 'newTweet', (data)->
        $scope.tweets.unshift data
        $scope.tweets.splice 15
        applyTooltip()

    applyTooltip = ->
        $timeout ->
            $('.tooltipped').tooltip delay:50
        , 0

    return
]