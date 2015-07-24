app = angular.module 'streamPanelApp'

app.controller 'instagramStreamController', ['$scope','mySocket','instagramService', '$timeout',
($scope,mySocket,instagramService,$timeout) ->

    $scope.photos = []

    updateAllPhotos = (min_tag_id)->
        instagramService.getPhotos(min_tag_id).then (data)->
            $scope.photos = data.reverse()
            applyTooltip()

    mySocket.on 'connect', ->
        updateAllPhotos(0)

    mySocket.on 'reconnect', ->
        updateAllPhotos(0)

    mySocket.on 'instagramUpdate', (_data)->
        instagramService.getPhotos().then (data)->
            $scope.photos.unshift item for item in data
            $scope.photos.splice 15
            applyTooltip()

    applyTooltip = ->
        $timeout ->
            $('.tooltipped').tooltip delay:50
        , 0


    return
]

app.factory 'instagramService', ['$http','$q','streamPanelService', ($http,$q,streamPanelService)->
    client_id = ''

    next_min_id = 0
    count = 15

    getClient = ->
        defer = $q.defer()
        $http.get('/instagram_client').success (data)->
            client_id = data
            defer.resolve()
        defer.promise
    getClientPromise = getClient()

    getPhotos: (min_tag_id)->
        next_min_id = min_tag_id if min_tag_id?
        defer = $q.defer()
        getClientPromise.then ->
            endPoint = "https://api.instagram.com/v1/tags/#{streamPanelService.getHashtag()}/media/recent?client_id=#{client_id}&min_tag_id=#{next_min_id}&count=#{count}&callback=JSON_CALLBACK"
            $http.jsonp(endPoint).success (data)->
                next_min_id = data.pagination.min_tag_id
                defer.resolve(data.data)
        defer.promise
]