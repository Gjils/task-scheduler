import 'dart:async';
import 'dart:math';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_scheduler/features/task/edit/edit_real/edit_real.dart';
import 'package:task_scheduler/features/task/task.dart';
import 'package:task_scheduler/state/state.dart';

class RealTaskCard extends StatefulWidget {
  const RealTaskCard({super.key, required this.task});

  final TaskReal task;

  @override
  State<RealTaskCard> createState() => _RealTaskCardState();
}

class _RealTaskCardState extends State<RealTaskCard> {
  var timerStatus = "";
  String getTimeString(duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes;
    minutes -= hours * 60;
    return "${hours == 0 ? "" : "${hours}h "}${minutes}m";
  }

  dynamic timer;
  @override
  void initState() {
    print(widget.task.status);
    if (widget.task.status == "doing") {
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        print(timer.tick);
        setState(() {
          timerStatus;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final replaceTask = context.watch<AppState>().replaceTask;

    Widget? leading;
    Widget? trailing;
    switch (widget.task.status) {
      case "not started":
        {
          leading = IconButton(
            onPressed: () {
              replaceTask(
                  newTask: TaskReal(
                      title: widget.task.title,
                      duration: widget.task.duration,
                      status: "doing",
                      completedPart: Duration(minutes: 0),
                      lastActionTime: DateTime.now()),
                  oldTask: widget.task);
            },
            icon: Icon(
              Icons.play_arrow,
              size: 28,
            ),
          );
          trailing = SizedBox(
            width: 110,
            child: Row(
              children: [
                SizedBox(
                  height: 30,
                  width: 70,
                  child: Card(
                    color: Theme.of(context).colorScheme.onTertiary,
                    child: Center(
                        child: Text(getTimeString(widget.task.duration))),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      useSafeArea: true,
                      isScrollControlled: true,
                      showDragHandle: true,
                      builder: (context) => EditRealTask(task: widget.task),
                    );
                  },
                  icon: Icon(
                    Icons.edit,
                  ),
                ),
              ],
            ),
          );
        }
      case "doing":
        {
          leading = SizedBox(
            width: 90,
            child: Card(
              color: Theme.of(context).colorScheme.onTertiary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      timer.cancel();
                      replaceTask(
                          newTask: TaskReal(
                              title: widget.task.title,
                              duration: widget.task.duration,
                              status: "paused",
                              completedPart: widget.task.completedPart +
                                  DateTime.now()
                                      .difference(widget.task.lastActionTime!),
                              lastActionTime: DateTime.now()),
                          oldTask: widget.task);
                    },
                    icon: Icon(
                      Icons.pause_rounded,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        useSafeArea: true,
                        isScrollControlled: true,
                        showDragHandle: true,
                        builder: (context) => EditRealTask(task: widget.task),
                      );
                    },
                    icon: Icon(
                      Icons.done_rounded,
                    ),
                  ),
                ],
              ),
            ),
          );
          trailing = SizedBox(
            width: 110,
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 30,
                    width: 70,
                    child: Card(
                      color: Theme.of(context).colorScheme.onTertiary,
                      child: Center(
                          child: Text(getTimeString(widget.task.lastActionTime
                              ?.add(widget.task.duration -
                                  widget.task.completedPart)
                              .difference(DateTime.now())))),
                    ),
                  ),
                  CircularCountDownTimer(
                    width: 25,
                    height: 25,
                    initialDuration: widget.task.completedPart.inSeconds,
                    duration: widget.task.duration.inSeconds,
                    fillColor: Theme.of(context).colorScheme.onTertiary,
                    ringColor: Theme.of(context).colorScheme.background,
                    isTimerTextShown: false,
                    isReverse: false,
                  ),
                ],
              ),
            ),
          );
        }
      case "paused":
        {
          leading = SizedBox(
            width: 90,
            child: Card(
              color: Theme.of(context).colorScheme.onTertiary,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      replaceTask(
                          newTask: TaskReal(
                              title: widget.task.title,
                              duration: widget.task.duration,
                              status: "doing",
                              completedPart: widget.task.completedPart,
                              lastActionTime: DateTime.now()),
                          oldTask: widget.task);
                    },
                    icon: Icon(
                      Icons.play_arrow_rounded,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        useSafeArea: true,
                        isScrollControlled: true,
                        showDragHandle: true,
                        builder: (context) => EditRealTask(task: widget.task),
                      );
                    },
                    icon: Icon(
                      Icons.done_rounded,
                    ),
                  ),
                ],
              ),
            ),
          );
          CountDownController controller = CountDownController();
          trailing = SizedBox(
            width: 110,
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 30,
                    width: 70,
                    child: Card(
                      color: Theme.of(context).colorScheme.onTertiary,
                      child: Center(
                          child: Text(getTimeString(widget.task.duration -
                              widget.task.completedPart))),
                    ),
                  ),
                  CircularCountDownTimer(
                    width: 25,
                    height: 25,
                    controller: controller,
                    initialDuration: min(widget.task.completedPart.inSeconds,
                        widget.task.duration.inSeconds),
                    duration: widget.task.duration.inSeconds,
                    fillColor: Theme.of(context).colorScheme.onTertiary,
                    ringColor: Theme.of(context).colorScheme.background,
                    isTimerTextShown: false,
                    isReverse: false,
                    autoStart: true,
                  ),
                ],
              ),
            ),
          );
          Timer(Duration(seconds: 1), () {
            controller.pause();
          });
        }
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 4),
          leading: leading,
          title: Text(
            widget.task.title,
            style: TextStyle(fontSize: 15),
          ),
          trailing: trailing,
        ),
      ),
    );
  }
}
