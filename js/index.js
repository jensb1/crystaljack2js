//const addon = require('./test.node');

const addon = require('../build/libjack2.node');



var time = 0
async function process_callback(nframes, out1, out2)  {
	console.log("time" + time)
	f = 440.0;
	sr = 44000;

	for (var i=0; i<nframes; i++) {

		val = (Math.sin( time/(sr/f) * (2*Math.PI) )+1)/2;
		out1[i]=val;
		time+=1
	}
}

console.log(addon.setup(process_callback));

setInterval(function() {
  
}, 1000000);