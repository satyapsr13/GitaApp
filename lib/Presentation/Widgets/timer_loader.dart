import 'dart:async';
import 'package:flutter/material.dart';

class TimerLoader extends StatefulWidget {
  @override
  _TimerLoaderState createState() => _TimerLoaderState();
}

class _TimerLoaderState extends State<TimerLoader> {
  int _secondsRemaining = 15;
  double _progress = 1.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (timer) {
        setState(() {
          if (_secondsRemaining <= 0) {
            timer.cancel();
          } else {
            _secondsRemaining--;
            _progress = _secondsRemaining / 15; // Assuming 15 seconds timer
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      width: 75,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircularProgressIndicator(
              value: _progress,
              strokeWidth: 10,
              backgroundColor: Colors.grey,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            Text(
              '$_secondsRemaining',
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
