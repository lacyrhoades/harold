# Harold

### UDP-based discoverability tool. A way to start conversations in your projects.

Say hello to all devices on your subnet at once, without having to find or type in IP addresses.

* **Easy UDP messages**: Send fast broadcasts to all local clients with a string body. This string message body could be anything; JSON, for example, or it could just be "Hello". The message has to be under 64k in length. The recipient gets the sender's IP for free, so don't bother including that.
* **Zero configuration integration between devices**: When a device comes on WiFi (i.e. iPad, Raspberry Pi, etc.) it will be assigned an address. The first step in setting up local devices is often finding or configuring the device address information. With Harold you can simply advertise availability as an initial volley and the recipient can decide to initiate a two-way conversation from there.
* **iOS devices and hardware gadgets**: Talk directly from iOS-to-iOS or integrate Node.js projects talking Swift-to-Node or vice-versa.
* **Bonjour-ish**: For more serious use-cases check out Bonjour.

## Say hello from Node.js

```node
var broadcaster = require('harold')()
broadcaster.setupBroadcasting()
broadcaster.broadcast("Hello!!") // goes to everyone on the subnet
```

## Get messages in Swift

```Swift
self.scanner = Harold()
scanner?.addListener(self)

func haroldReceived(fromHost host: String, message: String) {
  print(host) // 192.168.1...
  print(message) // "Hello!!"
}
```
    
## Say hello from Swift

```Swift
var broadcaster = Harold()
broadcaster.setupBroadcast()
broadcaster.broadcast(message: "Hello!!")
```

## Get messages in Node.js

```node
var listener = new require('harold')()
listener.listen(function (host, message) {
  console.log(host)      // 10.0.1.2 etc
  console.log(message)   // "Hello!!"
})
```

or

```node
var listener = new require('harold')()
listener.on('message', function (host, message) {
  console.log(host)      // 10.0.1.2 etc
  console.log(message)   // "Hello!!"
})
listener.listen()
```
