app = angular.module 'streamPanelApp',['btford.socket-io','yaru22.angular-timeago','twitterFilters']

app.factory 'mySocket', ['socketFactory', (socketFactory)->
    ioSocket = io.connect window.location.href
    socketFactory(ioSocket: ioSocket)
]