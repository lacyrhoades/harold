var harold = require('harold')
var broadcaster = new harold()
broadcaster.setupBroadcasting()

setInterval(function() {
	var message = "Hello!!"
	console.log("Sending: " + message)
	broadcaster.broadcast(message)
}, 1000)

