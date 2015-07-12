app = angular.module 'streamPanelApp'

app.controller 'mainController', ['$scope','streamPanelService', 
($scope,streamPanelService) ->
    $scope.hashtag = ""
    streamPanelService.initialize().then (data)->
        $scope.hashtag = data

    return
]