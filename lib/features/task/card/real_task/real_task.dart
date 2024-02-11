import 'dart:async';
import 'dart:math';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  String getTimeString(duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes;
    minutes -= hours * 60;
    return "${hours == 0 ? "" : "${hours}h "}${minutes}m";
  }

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
                      lastActionTime: DateTime.now(),
                      creationDate: widget.task.creationDate,
                      uuid: widget.task.uuid),
                  oldTask: widget.task);
            },
            icon: Icon(
              Icons.play_arrow,
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
                          child: Text(getTimeString(widget.task.duration))))),
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
                                    .difference(widget.task.lastActionTime),
                            lastActionTime: DateTime.now(),
                            creationDate: widget.task.creationDate,
                            uuid: widget.task.uuid),
                        oldTask: widget.task);
                  },
                  icon: Icon(
                    Icons.pause_rounded,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    timer.cancel();
                    replaceTask(
                        newTask: TaskReal(
                          title: widget.task.title,
                          duration: widget.task.duration,
                          status: "done",
                          completedPart: widget.task.completedPart +
                              DateTime.now()
                                  .difference(widget.task.lastActionTime),
                          lastActionTime: DateTime.now(),
                          creationDate: widget.task.creationDate,
                          uuid: widget.task.uuid,
                        ),
                        oldTask: widget.task);
                  },
                  icon: Icon(
                    Icons.done_rounded,
                  ),
                ),
              ],
            ),
          );
          trailing = GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                useSafeArea: true,
                isScrollControlled: true,
                showDragHandle: true,
                builder: (context) => TimeStatus(
                  task: widget.task,
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
                        child: Text(getTimeString(widget.task.lastActionTime
                            .add(widget.task.duration -
                                widget.task.completedPart)
                            .difference(DateTime.now())))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: CircularCountDownTimer(
                      width: 25,
                      height: 25,
                      initialDuration: min(
                          widget.task.completedPart.inSeconds +
                              DateTime.now()
                                  .difference(widget.task.lastActionTime)
                                  .inSeconds,
                          widget.task.duration.inSeconds),
                      duration: widget.task.duration.inSeconds,
                      fillColor:
                          Theme.of(context).colorScheme.onPrimaryContainer,
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
      case "paused":
        {
          leading = Card(
            color: Theme.of(context).colorScheme.onTertiary,
            child: Row(
              mainAxisSize: MainAxisSize.min,
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
                          lastActionTime: DateTime.now(),
                          creationDate: widget.task.creationDate,
                          uuid: widget.task.uuid,
                        ),
                        oldTask: widget.task);
                  },
                  icon: Icon(
                    Icons.play_arrow_rounded,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    replaceTask(
                        newTask: TaskReal(
                          title: widget.task.title,
                          duration: widget.task.duration,
                          status: "done",
                          completedPart: widget.task.completedPart +
                              DateTime.now()
                                  .difference(widget.task.lastActionTime),
                          lastActionTime: DateTime.now(),
                          creationDate: widget.task.creationDate,
                          uuid: widget.task.uuid,
                        ),
                        oldTask: widget.task);
                  },
                  icon: Icon(
                    Icons.done_rounded,
                  ),
                ),
              ],
            ),
          );
          CountDownController controller = CountDownController();
          trailing = GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                useSafeArea: true,
                isScrollControlled: true,
                showDragHandle: true,
                builder: (context) => TimeStatus(task: widget.task),
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
                        child: Text(getTimeString(
                            widget.task.duration - widget.task.completedPart))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: CircularCountDownTimer(
                      controller: controller,
                      width: 25,
                      height: 25,
                      initialDuration: min(
                          widget.task.completedPart.inSeconds +
                              DateTime.now()
                                  .difference(widget.task.lastActionTime)
                                  .inSeconds,
                          widget.task.duration.inSeconds),
                      duration: widget.task.duration.inSeconds,
                      fillColor:
                          Theme.of(context).colorScheme.onPrimaryContainer,
                      ringColor: Theme.of(context).colorScheme.onTertiary,
                      isTimerTextShown: false,
                      isReverse: false,
                    ),
                  ),
                ],
              ),
            ),
          );
          Timer.run(() {
            controller.pause();
          });
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
                          child: Text(getTimeString(widget.task.duration))))),
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
          );
        }
    }

    return ReorderableDelayedDragStartListener(
      index: widget.index,
      child: Opacity(
        opacity: widget.task.status == "done" ? 0.5 : 1.0,
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
    );
  }
}
