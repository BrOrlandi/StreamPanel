app = angular.module 'streamPanelApp',['btford.socket-io']
app.factory 'mySocket', ['socketFactory', (socketFactory)->
    socketFactory()
]