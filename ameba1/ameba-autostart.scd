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
		| value, buf |
		var sig;
		sig = PlayBuf.ar(2, buf, rate: (value*2).max(1.0), trigger: 1.0, startPos: 0.0, loop: 1, doneAction:2) * value;
		Out.ar(0,sig*8)
	}).add;

	s. sync;

	~palabras1 = [
		Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/palabras1/Chromatics.wav"),
		Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/palabras1/Claire_edit_1.wav"),
		Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/palabras1/Fran_6.wav"),
		Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/palabras1/Fran_10.wav"),
		Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/palabras1/Fran_14.wav"),
		Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/palabras1/Marta_6.wav"),
		Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/palabras1/Marta_11.wav"),
		Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/palabras1/Nuria_2.wav"),
		Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/palabras1/Nuria_5.wav"),
		Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/palabras1/Silvia_1.wav"),
		Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/palabras1/Silvia_3.wav"),
	];
	~palabras2 = [
		Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/palabras2/Claire_3.wav"),
		Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/palabras2/Fran_3.wav"),
		Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/palabras2/Fran_8.wav"),
		Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/palabras2/Fran_13.wav"),
		Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/palabras2/Marta_4.wav"),
		Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/palabras2/Marta_8.wav"),
		Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/palabras2/Nuria_1.wav"),
		Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/palabras2/Nuria_3.wav"),
		Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/palabras2/Nuria_4.wav"),
		Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/palabras2/Nuria_6.wav"),
		Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/palabras2/Silvia_2.wav"),
		Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/palabras2/Silvia_4.wav"),
	];
	~ballenas = [
		Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/Ballenas.wav"),

	];
	~pajaros = [
		Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/Pajaros.wav"),

	];
	~texturas = [
		Buffer.read(s, Platform.userHomeDir ++ "/ameba/samples/Textura.wav"),
	];

	// s.freeAll;
	~synths.do{|x| x.free};
	~synths = [
		Synth(\playbufstereo, [\buf: ~ballenas[0]]),
		Synth(\playbufstereo, [\buf: ~pajaros[0]]),
		Synth(\playbufstereo, [\buf: ~texturas[0]]),
		Array.fill(~palabras1.size, {|i|Synth(\playbufstereo, [buf:~palabras1[i]])}),
		Array.fill(~palabras2.size, {|i|Synth(\playbufstereo, [buf:~palabras2[i]])})
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
					// one sample
					if(i<3) {
						// i.debug;
						~synths[i].set(\value, x.asInteger.linexp(0,150,1.0,0.1));
					};
					// suenan varios con la porximidad
					if(i == 3) {
						~palabras1.size.do{|n|
							~synths[i][n].set(\value, ( n > (x.asInteger/(n+1) )));//.debug(n));
						}
					};
					// suenan varios con la porximidad
					if(i == 4) {
						~palabras2.size.do{|n|
							~synths[i][n].set(\value, ( n > (x.asInteger/(n+1) )));//.debug(n));
						}
					};

				};
			});
		};
	}).play;

};
)

