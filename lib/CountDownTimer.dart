
import 'package:flutter/material.dart';


class CountDownTimer extends StatefulWidget {
  CountDownTimer({
    Key? key,
    required int secondsRemaining,
    required this.countDownTimerStyle,
    required this.whenTimeExpires,
  })  : secondsRemaining = secondsRemaining,
        super(key: key);

  final int secondsRemaining;
  final Function whenTimeExpires;
  final TextStyle countDownTimerStyle;


  State createState() => new _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Duration duration;


  int get timerDisplayString {
    Duration duration = (_controller.duration! * _controller.value);
    return duration.inSeconds;
    // In case user doesn't provide formatter use the default one
    // for that create a method which will be called formatHHMMSS or whatever you like
  }

  @override
  void initState() {
    super.initState();
    duration = new Duration(seconds: widget.secondsRemaining);
    _controller = new AnimationController(
      vsync: this,
      duration: duration,
    );
    _controller.reverse(from: widget.secondsRemaining.toDouble());
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        widget.whenTimeExpires();
      }
    });
  }




  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: AnimatedBuilder(
            animation: _controller,
            builder: (context,_widget) {
              return Text(
                timerDisplayString.toString(),
                style: widget.countDownTimerStyle,
              );
            },
        ));
  }

  }
