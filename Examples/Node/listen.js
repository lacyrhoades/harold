var harold = require('harold')
var listener = new harold()
// listener.listen(function (host, message) {
// 	console.log(host + " says: " + message)
// })
listener.on('message', function (host, message) {
	console.log(host)
	console.log(message)
})
listener.listen()