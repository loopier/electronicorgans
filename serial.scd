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
	sig = PlayBuf.ar(2, buf, rate: 1, trigger: 1.0, startPos: 0.0, loop: 1, doneAction:2) * value;
	Out.ar(0,sig)
}).add
)
(
~bufs = [
	Buffer.read(s, Platform.userHomeDir ++ "/loopier/samples/misc/decima.wav"),
	Buffer.read(s, Platform.userHomeDir ++ "/loopier/samples/misc/ovni.wav"),
	// Buffer.read(s, Platform.userHomeDir ++ "/loopier/samples/misc/onda.wav"),
	Buffer.read(s, Platform.userHomeDir ++ "/loopier/samples/misc/inia.wav"),
	Buffer.read(s, Platform.userHomeDir ++ "/loopier/samples/misc/somni.wav"),
	// Buffer.read(s, "samples/1silvia_01.wav"),
	// Buffer.read(s, "samples/2silvia_01.wav"),
	Buffer.read(s, "samples/3silvia_01.wav"),
	// Buffer.read(s, "samples/4silvia_01.wav"),
	// Buffer.read(s, "samples/5silvia_01.wav"),
];
~sensorsynths = [\loopier, \loopier_rate, \loopier_rate, \notloopier, \notloopier_rate];
~synths = Array.fill(5, {|i| Synth(\amplitude, [buf: ~bufs[i]]) });
// )
// (
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
				val = byte.linexp(0,150, 4.0,0.01);
				~synths[byteindex].set(\value, val);
				val.debug(byteindex);
			});
		};
		0.1.wait;
	// };
});

~serial.play;
)
~serial.stop;
s.freeAll