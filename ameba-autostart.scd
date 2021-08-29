// =====================================================================
// Play buffers with serial data
// =====================================================================
(
s.waitForBoot {
	SerialPort.devices;
	p = SerialPort("/dev/ttyACM0", 115200, stopbit:true, crtscts:false);

	SynthDef(\playbufmono,{
		// infinite loop, the value controls the amplitude
		| value, buf |
		var sig;
		sig = PlayBuf.ar(1, buf, rate: value.max(1.0), trigger: 1.0, startPos: 0.0, loop: 1, doneAction:2) * value;
		Out.ar(0,sig)
	}).add;
	SynthDef(\playbufstereo,{
		// infinite loop, the value controls the amplitude
		| value, buf |
		var sig;
		// sig = PlayBuf.ar(2, buf, rate: value.max(1.0), trigger: 1.0, startPos: 0.0, loop: 1, doneAction:2) * value;
		sig = PlayBuf.ar(2, buf, rate: 1, trigger: 1.0, startPos: 0.0, loop: 1, doneAction:2) * value;
		Out.ar(0,sig)
	}).add;
	SynthDef(\beat,{
		// infinite loop, the value controls the amplitude
		| value, buf, amp=0 |
		var sig;
		sig = PlayBuf.ar(2, buf, rate: (value*2).max(1.0), trigger: 1.0, startPos: 0.0, loop: 1, doneAction:2);
		Out.ar(0,sig*value)
	}).add;

	s. sync;

	~beatbuf = Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/Corazon_nuevo.wav");
	~voices = [
		Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/Medico_1.wav"),
		Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/Medico_2.wav"),
		Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/Medico_3.wav"),
		Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/MsNina.wav"),
		// Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/Rafaella.wav"),
		Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/Boogie.wav"),
		// Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/Willi.wav"),

	];
	~sounds = [
		Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/Squish_1.wav"),
		// Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/Squish_2.wav"),
		// Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/Squish_3.wav"),
		Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/Suspiros_mezcla_01.wav"),
		// Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/pasos_1.wav"),
		// Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/MsNina.wav"),
		// Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/Rafaella.wav"),
		Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/Willi.wav"),

	];

	// s.freeAll;
	~synths.do{|x| x.free};
	~synths = [
		Synth(\beat, [buf: ~beatbuf]),
		Synth(\playbufstereo),
		Synth(\playbufstereo),
		Synth(\playbufstereo),
		Array.fill(~voices.size, {|i|Synth(\playbufstereo, [buf:~voices[i]])})
	];

	s.sync;

	r.stop;
	r= Routine({
		var byte, str, res;
		var values = Array.fill(5);
		inf.do{|i|
			if(p.read==10, {
				str = "";
				while({byte = p.read; byte !=13 }, {
					str= str++byte.asAscii;
				});
				values = str.split($,);
				// ("read value:"+values).postln;
				values.do{|x, i|
					// corazon
					if(i==0) {
						//i.debug;
						~synths[0].set(\value, x.asInteger.linexp(0,150,1.0,0.1));
					};
					// paisajes sonoros
					if((i >= 1) && (i <= 3)) {
						~synths[i].set(\value, x.asInteger.linexp(0,150,1.0,0.01) * 2, \buf, ~sounds[i-1]);
					};
					// suenan varios con la porximidad
					if(i == 4) {
						5.do{|n|
							~synths[4][n].set(\value, ( n > (x.asInteger/30) ));//.debug(n));
						}
					}

				};
			});
		};
	}).play;

};
)

