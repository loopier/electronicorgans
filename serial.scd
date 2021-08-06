// =====================================================================
// Play buffers with serial data
// =====================================================================

s.boot;

SerialPort.devices;
p = SerialPort("/dev/ttyACM0", 115200, stopbit:true, crtscts:false);
(
SynthDef(\playbufmono,{
	// infinite loop, the value controls the amplitude
	| value, buf |
	var sig;
	sig = PlayBuf.ar(1, buf, rate: 1, trigger: 1.0, startPos: 0.0, loop: 1, doneAction:2) * value;
	Out.ar(0,sig)
}).add;
SynthDef(\playbufstereo,{
	// infinite loop, the value controls the amplitude
	| value, buf |
	var sig;
	sig = PlayBuf.ar(2, buf, rate: 1, trigger: 1.0, startPos: 0.0, loop: 1, doneAction:2) * value;
	Out.ar(0,sig)
}).add
)
(
~bufs = [
	Buffer.read(s, Platform.userHomeDir ++ "/electronicorgans/samples/1silvia_01.wav"),
	Buffer.read(s, Platform.userHomeDir ++ "/electronicorgans/samples/2silvia_01.wav"),
	Buffer.read(s, Platform.userHomeDir ++ "/electronicorgans/samples/3silvia_01.wav"),
	// Buffer.read(s, Platform.userHomeDir ++ "/electronicorgans/samples/4silvia_01.wav"),
	// Buffer.read(s, Platform.userHomeDir ++ "/electronicorgans/samples/5silvia_01.wav"),
	Buffer.read(s, Platform.userHomeDir ++ "/electronicorgans/samples/6silvia_01.wav"),
	Buffer.read(s, Platform.userHomeDir ++ "/electronicorgans/samples/olas_01.wav"),
];
)
(
// if this block is evaluated with ~bufs delcaration it doesn't work
~synths = Array.fill(5, {|i|
	var buf = ~bufs[i];
	buf.numChannels.debug("buf" + i + "channels");
	[
		Synth(\playbufmono, [buf: buf]),
		Synth(\playbufstereo, [buf: buf]),
		].at(buf.numChannels - 1)
});
)
(
~serial.clear;
~serial = Tdef(\serialreceiver, {
	var byte, str, res;
	inf.do{
		var val;
		var byteindex = 0;
		var bytes = Array.fill(5);
		while({byte = p.read; byte !=255}, {
			byteindex = byteindex + 1;
			val = byte.linexp(0,150, 4.0,0.01);
			~synths[byteindex].set(\value, val);
			val.debug(byteindex);
		});
		0.1.wait;
	};
});

~serial.play;
)
~serial.stop;
~serial.clear;
s.freeAll
