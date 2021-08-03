// =====================================================================
// SuperCollider Workspace
// =====================================================================

Loopier.boot;

SerialPort.devices;
p = SerialPort("/dev/ttyACM0", 115200, stopbit:true, crtscts:false);
(
SynthDef(\amplitude,{
	// infinite loop, the value controls the amplitude
	| value, buf |
	var sig;
	sig = PlayBuf.ar(2, buf, rate: 1, trigger: 1.0, startPos: 0.0, loop: 1, doneAction:2) * value.lag(2);
	Out.ar(0,sig)
}).add
)
(
~bufs = [
	Buffer.read(s, Platform.userHomeDir ++ "/loopier/samples/misc/decima.wav"),
	Buffer.read(s, Platform.userHomeDir ++ "/loopier/samples/misc/ovni.wav"),
	Buffer.read(s, Platform.userHomeDir ++ "/loopier/samples/misc/onda.wav"),
	Buffer.read(s, Platform.userHomeDir ++ "/loopier/samples/misc/inia.wav"),
	Buffer.read(s, Platform.userHomeDir ++ "/loopier/samples/misc/somni.wav"),
];
~sensorsynths = [\loopier, \loopier_rate, \loopier_rate, \notloopier, \notloopier_rate];
~synths = Array.fill(5, {|i| Synth(\amplitude, [buf: ~bufs[i]]) });
)
(
~serial.clear;
~serial = Tdef(\serialreceiver, {
	var byte, str, res;
	inf.do{
		// p.read.postln;
		// if(p.read == 255) {
			var val;
		var byteindex = 0;
		var bytes = Array.fill(5);
			// str = [];
			while({byte = p.read; byte !=255}, {
				// str = str ++ [byte];
				// byte.debug();
				byteindex = byteindex + 1;
				val = byte.linlin(0,100, 1.0,0.0);
				~synths[byteindex].set(\value, val);
				val.debug(byteindex);
			});
			// val = str.split($,)[0];
			// val.debug();
			// str.split($,).do{|value, index|
			// 	var val = value.asInteger;
			// 	// value[2].asInteger.linlin(1,140,0.01,1.4).debug(index);
			// 	// ~synths[index].set(\amp, value.map(0, 150, 1.0, 0.0));
			// 	val.debug(index)
			// };
		};
		0.1.wait;
	// };
});

~serial.play;
)
~serial.stop;

"10".asFloat
p.close()
~synths[0].set(\amp, 0.3)
Synth(\amplitude, [buf: ~bufs[0], value:0.4])
s.freeAll
s.meter
~bufs[4].numChannels
().play