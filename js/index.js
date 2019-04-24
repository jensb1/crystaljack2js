//const addon = require('./test.node');
const addon = require('../build/libjack2.node');

const http = require('http')
const port = 3000

async function process_callback() {
	console.log("asdf")
}

console.log(addon.setup(process_callback));

setInterval(function() {
  
}, 1000000);