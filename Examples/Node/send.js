var harold = require('harold')
var broadcaster = new harold()
broadcaster.setupBroadcasting()

var arg = process.argv[2]
var message = arg
if (arg == null) {
	message = "Hello!!"
}
console.log("Sending: " + message)

broadcaster.broadcast(message, function () {
	broadcaster.endBroadcast()
})
