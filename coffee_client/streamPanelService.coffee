app = angular.module 'streamPanelApp'

app.factory 'streamPanelService', ['$http','$q', ($http,$q)->

    hashtag = ""

    initialize: ->
        defer = $q.defer()
        $http.get('/hashtag').success (data)->
            hashtag = data
            defer.resolve(hashtag)
        defer.promise
    getHashtag: ->
        hashtag
]