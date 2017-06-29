# Harold

### UDP-based discoverability tool. Say hello to all devices on your subnet, without having to find or type in IP addresses.

* Easy UDP messages: Send fast broadcasts to all local clients with a string body. This string message body could be anything; JSON, for example, or it could just be "Hello". The message has to be under 64k in length. The recipient gets the sender's IP for free, so don't bother including that
* Zero configuration integrations: When a device comes on WiFi (i.e. iPad, Raspberry Pi, etc.) it will be assigned an address. Typically a step in setting up a device to work with some other device locally will be to manually enter the IP address somewhere. With harold you can simply advertise availability, and the recipient can initiate a two-way conversation.
* Bonjour-ish: For more serious use-cases check out Bonjour.

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
  console.log(host)
  console.log(message)
})
```
