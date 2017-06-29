var dgram = require('dgram');
var os = require('os');

const DEFAULT_PORT = 4545;
const ALL_INTERFACES_ADDR = "0.0.0.0";
const BROADCAST_ADDR = "255.255.255.255";

var harold = function Harold(port) {
  if (port == null || isNaN(port)) {
    this.port = DEFAULT_PORT;
  } else {
    this.port = port;
  }
  this.listeningSocket = null;
  this.broadcastSockets = [];
  this.boundAddresses = [];
}

harold.prototype.listen = function() {
  var self = this

  if (self.listeningSocket) {
    self.listeningSocket.close();
  }

  self.listeningSocket = dgram.createSocket({type: "udp4", reuseAddr: true});

  self.listeningSocket.on('message', (msg, rinfo) => {
    console.log(`socket received: ${msg} from ${rinfo.address}:${rinfo.port}`);
  });

  self.listeningSocket.bind(self.port, ALL_INTERFACES_ADDR, function() {
    self.listeningSocket.setBroadcast(true);
  });

  console.log(`Listening to: ${ALL_INTERFACES_ADDR}:${self.port}`);
}

harold.prototype.setupBroadcasting = function() {
  self = this;

  var ifaceGroups = os.networkInterfaces();
  var keys = Object.keys(ifaceGroups);
  keys.forEach(function (ifname) {
    ifaceGroups[ifname].filter(function (iface) {
      return iface.family == 'IPv4';
    }).forEach(function(iface) {
      self.bindToAddress(iface.address)
    })
  });
}

harold.prototype.bindToAddress = function(address) {
  self = this;

  if (self.boundAddresses.includes(address)) {
    return;
  }

  self.boundAddresses.push(address);
  var socket = dgram.createSocket({type: "udp4", reuseAddr: true});
  console.log(`Binding to ${address}`);
  socket.bind(self.port, address, function() {
    socket.setBroadcast(true);
  });
  self.broadcastSockets.push(socket);
}

harold.prototype.broadcast = function(message) {
  var self = this;

  if (message == null) {
    message = "";
  }
  var callback = null;
  self.broadcastSockets.forEach(function (socket) {
    var buffer = new Buffer(message);
    socket.send(buffer, 0, buffer.length, self.port, BROADCAST_ADDR, callback);
  });
}

module.exports = harold;
