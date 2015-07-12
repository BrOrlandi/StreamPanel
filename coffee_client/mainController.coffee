app = angular.module 'streamPanelApp'

app.controller 'mainController', ['$scope','streamPanelService', 
($scope,streamPanelService) ->

    $ ->
        if window.innerHeight > window.innerWidth
            # vertical orientation
            $('.smart-col').addClass 'l12'
        else
            # horizontal orientation
            $('.smart-col').addClass 'l6'

    $scope.hashtag = ""
    streamPanelService.initialize().then (data)->
        $scope.hashtag = data

    return
]