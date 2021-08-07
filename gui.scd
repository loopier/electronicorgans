(
var numvalues = 5;
var gap = 2;
var width = 40;
var height = 300;
var ctlspec = ControlSpec(0, 150, step: 1);
w = Window.new.front;
w.bounds = Rect(760, 377, (width + gap) * (numvalues + 1), 400);
w.view.decorator = FlowLayout(w.view.bounds);
w.view.decorator.gap = gap@gap;
~sliders = Array.fill(numvalues, {|i|
	EZSlider( w,
		width@height,
		i + 1,
		ctlspec, // control spec
		// nil, // control spec
		layout: \vert,
	)
	.action_({ |ez| ez.value.asString.debug(i + 1)})
	.setColors(Color.grey, Color.white);
});
// )
// (
AppClock.clear;
r = Routine({ arg appClockTime;
	// ["AppClock has been playing for secs:",appClockTime].postln;
	// inf.do{
		// var val;
		// var byteindex = 0;
		// var bytes = Array.fill(5);
		// var byte;
		// while({byte = p.read; byte !=255}, {
		// 	byteindex = byteindex + 1;
		// 	// val = byte.linexp(0,150, 4.0,0.01);
		// 	// ~synths[byteindex].set(\value, val);
		// 	// val = byte.linlin(0,150, 1.5, 0.0);
		// 	// val = 150 - byte / 100;
		// 	// val = byte + 100;
		// 	val = byte;
		// 	// ~synths[byteindex].set(\value, val);
		// 	val.debug(byteindex);
		// 	if(byte < 150) {
		// 		~sliders[byteindex - 1].value_(val);
		// 	}{
		// 		~sliders[byteindex - 1].value_(150);
		// 	};
		// 	// ~values[byteindex - 1] = val; // GUI
		// 	// byte.debug(byteindex);
		// });
		// 0.05.yield;
	// }
	inf.do({
		~values.do{|val, i|
			~sliders[i].value_(val);
		};
	    0.05.yield;
	    // w.bounds = w.bounds.moveBy(10.rand2, 10.rand2);
	    // w.alpha = cos(i*0.1pi)*0.5+0.5;

	});
});
AppClock.play(r);
)
// Window.closeAll
// w.close
// ~sliders[1].value_(0.2)