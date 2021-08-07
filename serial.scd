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
}).add;
SynthDef(\electro,{
	// infinite loop, the value controls the amplitude
	| value = 1, buf, amp = 0.2, threshold=0.3 |
	var sig, env;
	amp = 0.1;
	env = EnvGen.ar(Env.perc, Impulse.kr(value));
	sig = VarSaw.ar(200 * buf !2);
	Out.ar(0, sig * env * amp);
}).add;
)
(
~bufs = [
	Buffer.read(s, Platform.userHomeDir ++ "/alla/samples/Nuria_edit_1.wav"),
	Buffer.read(s, Platform.userHomeDir ++ "/alla/samples/Nuria_edit_2.wav"),
	Buffer.read(s, Platform.userHomeDir ++ "/alla/samples/Nuria_edit_3.wav"),
	Buffer.read(s, Platform.userHomeDir ++ "/alla/samples/Nuria_edit_4.wav"),
	Buffer.read(s, Platform.userHomeDir ++ "/alla/samples/Nuria_edit_5.wav"),
	Buffer.read(s, Platform.userHomeDir ++ "/alla/samples/Nuria_edit_6.wav"),
	Buffer.read(s, Platform.userHomeDir ++ "/alla/samples/Silvia_edit_1.wav"),
	Buffer.read(s, Platform.userHomeDir ++ "/alla/samples/Silvia_edit_2.wav"),
	Buffer.read(s, Platform.userHomeDir ++ "/alla/samples/Silvia_edit_3.wav"),
	Buffer.read(s, Platform.userHomeDir ++ "/alla/samples/Silvia_edit_4.wav"),
];
)
(
// if this block is evaluated with ~bufs delcaration it doesn't work
~synths = Array.fill(5, {|i|
	// var buf = ~bufs[i];
	// buf.numChannels.debug("buf" + i + "channels");
	// [
	// 	Synth(\playbufmono, [buf: buf]),
	// 	Synth(\playbufstereo, [buf: buf]),
	// 	].at(buf.numChannels - 1)
	Synth(\electro, [buf: i])
});
)
(
// w.close;
"gui.scd".loadRelative;
~values = Array.fill(5,0); // gui
~serial.clear;
~serial = Tdef(\serialreceiver, {
	var byte, str, res;
	inf.do{
		var val;
		var byteindex = 0;
		var bytes = Array.fill(5);
		while({byte = p.read; byte !=255}, {
			byteindex = byteindex + 1;
			~values[byteindex - 1] = byte;
			// val = byte.linexp(0,150, 4.0,0.01);
			val = byte.linlin(0,150, 10.0, 0.1);
			// val = 150 - byte / 100;
			// val = byte + 100;
			// val = byte;
			~synths[byteindex].set(\value, val);
			val.debug(byteindex);
			// ~values[byteindex - 1] = val; // GUI
			// byte.debug(byteindex);
		});
		0.1.wait;
	};
});

~serial.play;
);
)
(
~serial.stop;
~serial.clear;
p.close;
s.freeAll
)
(
)