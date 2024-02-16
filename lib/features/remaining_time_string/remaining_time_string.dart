import 'package:flutter/material.dart';

class RemainingTimeString extends StatelessWidget {
  const RemainingTimeString({super.key, required this.duration, this.style});

  final Duration duration;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Text(
      getTimeString(duration),
      style: style,
    );
  }
}

String getTimeString(duration) {
  int hours = duration.inHours;
  int minutes = duration.inMinutes;
  int seconds = duration.inSeconds;
  minutes -= hours * 60;
  seconds -= hours * 60 * 60 - minutes * 60;
  return "${hours == 0 ? "" : "${hours}h "}${minutes == 0 ? "${seconds}s" : "${minutes}m"}";
}
