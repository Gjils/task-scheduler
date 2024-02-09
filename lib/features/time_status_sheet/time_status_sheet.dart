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
            width: 200,
            height: 200,
            strokeWidth: 20,
            initialDuration: min(
                widget.task.completedPart.inSeconds +
                    DateTime.now()
                        .difference(
                            widget.task.lastActionTime ?? DateTime.now())
                        .inSeconds,
                widget.task.duration.inSeconds),
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
            "Remaining: ${getTimeString(
              widget.task.lastActionTime
                  ?.add(widget.task.duration - widget.task.completedPart)
                  .difference(
                    DateTime.now(),
                  ),
            )}\nSpent: ${getTimeString(DateTime.now().difference(widget.task.lastActionTime ?? DateTime.now()) + widget.task.completedPart)}",
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
  return "${hours == 0 ? "" : "${hours}h "}${minutes == 0 ? "" : "${minutes}m "}${seconds == 0 ? "" : "${seconds}s "}";
}
