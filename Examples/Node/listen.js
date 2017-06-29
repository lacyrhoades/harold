var harold = require('harold')
var listener = new harold()
listener.listen(function (host, message) {
	console.log(host + " says: " + message)
})
