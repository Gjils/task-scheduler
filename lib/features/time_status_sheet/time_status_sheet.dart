import 'dart:async';
import 'dart:math';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:task_scheduler/features/task/task.dart';

class TimeStatus extends StatefulWidget {
  const TimeStatus({super.key, required this.task});

  final TaskReal task;

  @override
  State<TimeStatus> createState() => _TimeStatusState();
}

class _TimeStatusState extends State<TimeStatus> {
  var timerStatus = "";
  dynamic timer;
  @override
  void initState() {
    if (widget.task.status == "doing") {
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        try {
          setState(() {
            timerStatus = timer.tick.toString();
          });
        } catch (e) {
          timer.cancel();
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Duration initialDuration;
    Duration remainingDuration;
    if (widget.task.status == "doing") {
      initialDuration = (widget.task.completedPart +
          DateTime.now().difference(widget.task.lastActionTime));
      remainingDuration = widget.task.lastActionTime
          .add(widget.task.duration - widget.task.completedPart)
          .difference(
            DateTime.now(),
          );
    } else {
      initialDuration = widget.task.completedPart;
      remainingDuration = widget.task.duration - widget.task.completedPart;
    }
    int initialDurationSeconds =
        min(widget.task.duration.inSeconds, initialDuration.inSeconds);

    initialDuration += Duration(seconds: 1);

    CountDownController countDownController = CountDownController();
    if (widget.task.status == "paused") {
      Timer.run(
        () {
          countDownController.pause();
        },
      );
    }
    return Container(
      height: 650,
      padding:
          EdgeInsets.only(bottom: 30) + EdgeInsets.symmetric(horizontal: 30),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircularCountDownTimer(
            controller: countDownController,
            width: 200,
            height: 200,
            strokeWidth: 20,
            initialDuration: initialDurationSeconds,
            duration: widget.task.duration.inSeconds,
            fillColor: Theme.of(context).colorScheme.onPrimaryContainer,
            ringColor: Theme.of(context).colorScheme.onTertiary,
            isTimerTextShown: false,
            isReverse: false,
          ),
          SizedBox(
            height: 50,
          ),
          Text(
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
            "Remaining: ${getTimeString(remainingDuration)}\nSpent: ${getTimeString(initialDuration)}",
          ),
        ],
      ),
    );
  }
}

String getTimeString(duration) {
  int hours = duration.inHours;
  int minutes = duration.inMinutes;
  int seconds = duration.inSeconds;
  minutes -= hours * 60;
  seconds -= minutes * 60 + hours * 60 * 60;
  return "${hours == 0 ? "" : "${hours}h "}${minutes == 0 ? "" : "${minutes}m "} ${seconds}s";
}
