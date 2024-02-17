import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:weekly_calendar/weekly_calendar.dart';

import 'package:task_scheduler/features/task/task.dart';
import 'package:task_scheduler/state/state.dart';

class SchedulePage extends StatefulWidget {
  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final colorScheme = Theme.of(context).colorScheme;
    final realTasks = state.realTasks;
    final changeDay = state.changeDay;
    final updateTask = state.updateTask;
    final insertTask = state.insertTask;
    final tasksWidgets = realTasks
        .map((task) => RealTaskCard(
              index: realTasks.indexOf(task),
              task: task,
              key: Key(task.uuid + task.status),
            ))
        .cast<Widget>()
        .toList();
    tasksWidgets.add(SizedBox(height: 80, key: Key("sized-box")));
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 155,
        flexibleSpace: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            WeeklyCalendar(
              calendarStyle: CalendarStyle(
                dayTextColor: colorScheme.onBackground,
                todayDayTextColor: colorScheme.error,
                selectedDayTextColor: colorScheme.onBackground,
                weekendDayTextColor: colorScheme.onBackground,
                dayOfWeekTextColor: colorScheme.onBackground,
                weekendDayOfWeekTextColor: colorScheme.onBackground,
                todaySelectedCircleColor: colorScheme.tertiaryContainer,
                selectedCircleColor: colorScheme.secondaryContainer,
                locale: "en",
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.background,
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                ),
                headerDateTextAlign: Alignment.topLeft,
                headerDateTextColor: colorScheme.onBackground,
                isShowFooterDateText: false,
              ),
              onChangedSelectedDate: (DateTime date) {
                changeDay(date);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: realTasks.isEmpty
            ? FractionallySizedBox(
                widthFactor: 1,
                child: Column(children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "There are no tasks\nTry adding new",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                ]),
              )
            : FractionallySizedBox(
                heightFactor: 1,
                child: ReorderableListView(
                  buildDefaultDragHandles: false,
                  onReorderStart: (int index) {
                    HapticFeedback.heavyImpact();
                  },
                  onReorder: (int oldIndex, int newIndex) {
                    if (newIndex > realTasks.length) {
                      newIndex -= 1;
                    }
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    final item = realTasks[oldIndex];
                    if (newIndex + 1 == realTasks.length) {
                      item.index = realTasks[newIndex].index + 1;
                    } else if (newIndex == 0) {
                      item.index = realTasks[newIndex].index / 2;
                    } else {
                      item.index = (realTasks[newIndex].index +
                              realTasks[newIndex - 1].index) /
                          2;
                    }
                    insertTask(index: newIndex, task: item);
                    updateTask(task: item);
                  },
                  children: tasksWidgets,
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet(
          context: context,
          useSafeArea: true,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (context) => AddRealTask(
            selectedDate: state.currentDay,
            index: (realTasks.length + 1).toDouble(),
          ),
        ),
        label: Text("New task"),
        icon: Icon(Icons.add),
      ),
    );
  }
}
