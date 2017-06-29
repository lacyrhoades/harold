var Netmask = require('netmask').Netmask
var dgram = require('dgram');
var os = require('os');

const BRAIN_PORT = 3001;
const APP_PORT = 3009;
const ALL_INTERFACES_ADDR = "0.0.0.0";
const BROADCAST_ADDR = "255.255.255.255";

var domestica = function Domestica() {
  this.timer = null;
  this.interval = 1;
  this.listeningSocket = null;
  this.broadcastSockets = [];
  this.boundAddresses = [];
  this.messageCallback = function() {
    return {}
  }
}

domestica.prototype.listen = function() {
  var self = this

  if (self.listeningSocket) {
    self.listeningSocket.close();
  }

  self.listeningSocket = dgram.createSocket({type: "udp4", reuseAddr: true});

  self.listeningSocket.on('message', (msg, rinfo) => {
    console.log(`socket received: ${msg} from ${rinfo.address}:${rinfo.port}`);
  });

  self.listeningSocket.bind(BRAIN_PORT, ALL_INTERFACES_ADDR, function() {
    self.listeningSocket.setBroadcast(true);
  });

  console.log(`Listening to: ${ALL_INTERFACES_ADDR}:${BRAIN_PORT}`);
}

domestica.prototype.listenForApp = function() {
  var self = this

  if (self.listeningSocket) {
    self.listeningSocket.close();
  }

  self.listeningSocket = dgram.createSocket({type: "udp4", reuseAddr: true});

  self.listeningSocket.on('message', (msg, rinfo) => {
    console.log(`socket received: ${msg} from ${rinfo.address}:${rinfo.port}`);
  });

  self.listeningSocket.bind(APP_PORT, ALL_INTERFACES_ADDR, function() {
    self.listeningSocket.setBroadcast(true);
  });

  console.log(`Listening to: ${ALL_INTERFACES_ADDR}:${APP_PORT}`);
}

domestica.prototype.startBroadcasting = function(messageCallback) {
  var self = this;

  if (self.timer) {
    clearInterval(self.timer);
  }

  console.log(`Broadcasting to: ${BROADCAST_ADDR}:${BRAIN_PORT}`);

  self.messageCallback = messageCallback;

  self.timer = setInterval(function() {
    self.bindAllAddresses();
    self.broadcast();
  }, self.interval * 1000);
}

domestica.prototype.bindAllAddresses = function() {
  self = this;

  var ifaceGroups = os.networkInterfaces();
  var keys = Object.keys(ifaceGroups);
  keys.filter(function (ifacename) {
    return ifacename == "wlan0" || ifacename == "eth0"
  }).forEach(function (ifname) {
    var filtered = ifaceGroups[ifname].filter(function (iface) {
      var isLocal = iface.address.includes('192.');
      return iface.family == 'IPv4' && iface.internal == false && isLocal;
    });
    filtered.forEach(function(iface) {
      self.bindToAddress(iface.address)
    })
  });
}

domestica.prototype.bindToAddress = function(address) {
  self = this;

  if (self.boundAddresses.includes(address)) {
    return;
  }

  self.boundAddresses.push(address);

  var socket = dgram.createSocket({type: "udp4", reuseAddr: true});

  console.log(`Binding to ${address}`);

  socket.bind(BRAIN_PORT, address, function() {
    socket.setBroadcast(true);
  });

  self.broadcastSockets.push(socket);
}

domestica.prototype.broadcast = function() {
  var self = this;
  var callback = null;
  self.broadcastSockets.forEach(function (socket) {
    var message = new Buffer(JSON.stringify(self.messageCallback()));
    socket.send(message, 0, message.length, BRAIN_PORT, BROADCAST_ADDR, callback);
  });
}

module.exports = domestica;
