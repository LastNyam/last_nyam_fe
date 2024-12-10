import 'dart:async';
import 'package:flutter/material.dart';
import 'package:last_nyam/colors.dart';

class CustomCircularTimer extends StatefulWidget {
  final int remainingMinutes;
  final VoidCallback onTimerComplete;

  const CustomCircularTimer({
    Key? key,
    required this.remainingMinutes,
    required this.onTimerComplete,
  }) : super(key: key);

  @override
  _CustomCircularTimerState createState() => _CustomCircularTimerState();
}

class _CustomCircularTimerState extends State<CustomCircularTimer> {
  late int remainingSeconds;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    remainingSeconds = widget.remainingMinutes * 60;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        timer.cancel();
        widget.onTimerComplete();
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int minutes = remainingSeconds ~/ 60;
    int seconds = remainingSeconds % 60;
    double percentage = remainingSeconds / (widget.remainingMinutes * 60);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 55,
          height: 55,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: percentage,
                color: AppColors.greenColor,
                backgroundColor: AppColors.grayColor.withOpacity(0.2),
                strokeWidth: 3.0,
              ),
              Text(
                remainingSeconds >= 60
                    ? '$minutes분'
                    : '$seconds초',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
