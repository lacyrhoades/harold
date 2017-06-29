# Harold

UDP-based discoverability tool. Say hello to any device on your subnet, without knowing its address.

## Say hello from Node.js

    var broadcaster = require('harold')()
	broadcaster.setupBroadcasting()

	setInterval(function() {
		broadcaster.broadcast("Hello!!") // goes to everyone on the subnet
	}, 1000)

## Get messages in Swift

	self.scanner = Harold()
    scanner?.addListener(self)

    func haroldReceived(fromHost host: String, message: String) {
        print(host) // 192.168.1...
        print(message) // "Hello!!"
    }
    
## Say hello from Swift

    var broadcaster = Harold()
    broadcaster.broadcast(message: "Hello!!")

## Get messages in Node.js

    var listener = new require('harold')()
    listener.listen(function (host, message) {
    	console.log(host)
    	console.log(message)
    })
