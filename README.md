# Harold

UDP-based discoverability tool. Say hello to any device on your subnet, without knowing its address.

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
