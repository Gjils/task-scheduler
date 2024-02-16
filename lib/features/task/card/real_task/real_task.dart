import 'dart:async';
import 'dart:math';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_scheduler/features/remaining_time_string/remaining_time_string.dart';
import 'package:task_scheduler/features/task/edit/edit_real/edit_real.dart';
import 'package:task_scheduler/features/task/task.dart';
import 'package:task_scheduler/features/time_status_sheet/time_status_sheet.dart';
import 'package:task_scheduler/state/state.dart';

class RealTaskCard extends StatefulWidget {
  const RealTaskCard({super.key, required this.task, required this.index});

  final TaskReal task;
  final int index;

  @override
  State<RealTaskCard> createState() => _RealTaskCardState();
}

class _RealTaskCardState extends State<RealTaskCard> {
  var timerStatus = "";
  Timer? timer;
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
    final updateTask = context.watch<AppState>().updateTask;

    Widget? leading;
    Widget? trailing;
    switch (widget.task.status) {
      case "not started":
        {
          leading = RunTaskButton(task: widget.task, updateTask: updateTask);
          trailing = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                color: Theme.of(context).colorScheme.onTertiary,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: RemainingTimeString(duration: widget.task.duration),
                  ),
                ),
              ),
            ],
          );
        }
      case "doing":
        {
          leading = Card(
            color: Theme.of(context).colorScheme.onTertiary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                PauseTaskButton(
                    timer: timer, task: widget.task, updateTask: updateTask),
                DoneTaskButton(
                  timer: timer,
                  task: widget.task,
                  updateTask: updateTask,
                ),
              ],
            ),
          );
          trailing = TimeStatusCard(task: widget.task);
        }
      case "paused":
        {
          leading = Card(
            color: Theme.of(context).colorScheme.onTertiary,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RunTaskButton(
                  task: widget.task,
                  updateTask: updateTask,
                ),
                DoneTaskButton(
                  timer: timer,
                  task: widget.task,
                  updateTask: updateTask,
                )
              ],
            ),
          );
          trailing = TimeStatusCard(task: widget.task);
        }
      case "done":
        {
          leading = Padding(
            padding:
                const EdgeInsets.only(left: 10) + EdgeInsets.only(right: 7),
            child: Icon(
              Icons.check_circle_outline_rounded,
              size: 28,
            ),
          );
          trailing = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Card(
                color: Theme.of(context).colorScheme.onTertiary,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Center(
                    child: RemainingTimeString(
                      duration: widget.task.duration,
                    ),
                  ),
                ),
              ),
            ],
          );
        }
    }

    return ReorderableDelayedDragStartListener(
      index: widget.index,
      child: Opacity(
        opacity: widget.task.status == "done" ? 0.5 : 1.0,
        child: GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              useSafeArea: true,
              isScrollControlled: true,
              showDragHandle: true,
              builder: (context) => EditRealTask(task: widget.task),
            );
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 4),
                leading: leading,
                title: Text(
                  widget.task.title,
                  style: TextStyle(fontSize: 17),
                ),
                trailing: trailing,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TimeStatusCard extends StatelessWidget {
  TimeStatusCard({
    super.key,
    required this.task,
  });

  final TaskReal task;

  final CountDownController countDownController = CountDownController();

  @override
  Widget build(BuildContext context) {
    int initialDuration;
    Duration remainingDuration;
    if (task.status == "doing") {
      initialDuration =
          (task.completedPart + DateTime.now().difference(task.lastActionTime))
              .inSeconds;
      remainingDuration = task.lastActionTime
          .add(task.duration - task.completedPart)
          .difference(
            DateTime.now(),
          );
    } else {
      initialDuration = task.completedPart.inSeconds;
      remainingDuration = task.duration - task.completedPart;
    }
    initialDuration = min(task.duration.inSeconds, initialDuration);

    if (task.status == "paused") {
      Timer.run(() {
        countDownController.pause();
      });
    }
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          useSafeArea: true,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (context) => TimeStatus(
            task: task,
          ),
        );
      },
      child: Card(
        color: Theme.of(context).colorScheme.onTertiary,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Center(
                child: RemainingTimeString(
                  duration: remainingDuration,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: CircularCountDownTimer(
                controller: countDownController,
                width: 25,
                height: 25,
                initialDuration: initialDuration,
                duration: task.duration.inSeconds,
                fillColor: Theme.of(context).colorScheme.onPrimaryContainer,
                ringColor: Theme.of(context).colorScheme.onTertiary,
                isTimerTextShown: false,
                isReverse: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DoneTaskButton extends StatelessWidget {
  const DoneTaskButton({
    super.key,
    required this.timer,
    required this.task,
    required this.updateTask,
  });

  final Timer? timer;
  final TaskReal task;
  final void Function({required TaskReal task}) updateTask;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        timer?.cancel();
        if (task.status == "running") {
          task.completedPart = task.completedPart +
              DateTime.now().difference(task.lastActionTime);
        }
        task.status = "done";
        task.lastActionTime = DateTime.now();
        updateTask(task: task);
      },
      icon: Icon(
        Icons.done_rounded,
      ),
    );
  }
}

class PauseTaskButton extends StatelessWidget {
  PauseTaskButton({
    super.key,
    required this.timer,
    required this.task,
    required this.updateTask,
  });

  final Timer? timer;
  final TaskReal task;
  final void Function({required TaskReal task}) updateTask;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        timer?.cancel();
        task.status = "paused";
        task.completedPart =
            task.completedPart + DateTime.now().difference(task.lastActionTime);
        task.lastActionTime = DateTime.now();
        updateTask(task: task);
      },
      icon: Icon(
        Icons.pause_rounded,
      ),
    );
  }
}

// class EditRealButton extends StatelessWidget {
//   const EditRealButton({
//     super.key,
//     required this.task,
//   });

//   final TaskReal task;

//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//       onPressed: () {
//         showModalBottomSheet(
//           context: context,
//           useSafeArea: true,
//           isScrollControlled: true,
//           showDragHandle: true,
//           builder: (context) => EditRealTask(task: task),
//         );
//       },
//       icon: Icon(
//         Icons.edit,
//       ),
//     );
//   }
// }

class RunTaskButton extends StatelessWidget {
  const RunTaskButton({
    super.key,
    required this.task,
    required this.updateTask,
  });

  final TaskReal task;
  final void Function({required TaskReal task}) updateTask;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        task.status = "doing";
        task.lastActionTime = DateTime.now();
        updateTask(task: task);
      },
      icon: Icon(
        Icons.play_arrow,
        size: 28,
      ),
    );
  }
}
