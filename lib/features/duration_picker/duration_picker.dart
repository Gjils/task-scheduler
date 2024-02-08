import 'package:flutter/cupertino.dart';

class DurationPicker extends StatelessWidget {
  const DurationPicker({super.key, required this.durationController});

  final ValueNotifier<Duration> durationController;

  @override
  Widget build(BuildContext context) {
    return CupertinoTimerPicker(
      mode: CupertinoTimerPickerMode.hm,
      initialTimerDuration: durationController.value,
      onTimerDurationChanged: (Duration newDuration) {
        durationController.value = newDuration;
      },
    );
  }
}
