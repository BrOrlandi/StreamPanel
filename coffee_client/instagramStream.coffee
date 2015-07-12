app = angular.module 'streamPanelApp'

app.controller 'instagramStreamController', ['$scope','streamPanelService','mySocket','instagramService', 
($scope,streamPanelService,mySocket,instagramService) ->

    $scope.data = []

    instagramService.getPhotos().then (data)->
        $scope.data = data

    mySocket.on 'instagramUpdate', (_data)->
        instagramService.getPhotos().then (data)->
            $scope.data.unshift item for item in data.reverse()


    return
]
###
    mySocket.on 'instagramFirst', (data)->
        console.log data
        $scope.data = data.firstData
###
app.factory 'instagramService', ['$http','$q','streamPanelService', ($http,$q,streamPanelService)->
    client_id = ''

    next_min_id = 0

    getClient = ->
        defer = $q.defer()
        $http.get('/instagram_client').success (data)->
            client_id = data
            defer.resolve()
        defer.promise
    getClientPromise = getClient()

    getPhotos: ->
        defer = $q.defer()
        getClientPromise.then ->
            endPoint = "https://api.instagram.com/v1/tags/#{streamPanelService.getHashtag()}/media/recent?client_id=#{client_id}&min_tag_id=#{next_min_id}&callback=JSON_CALLBACK"
            $http.jsonp(endPoint).success (data)->
                next_min_id = data.pagination.min_tag_id
                console.log data
                defer.resolve(data.data)
        defer.promise
]