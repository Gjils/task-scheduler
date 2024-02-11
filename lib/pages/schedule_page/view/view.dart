import 'package:flutter/material.dart';
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
    final deleteTask = state.deleteTask;
    final insertTask = state.insertTask;
    final changeDay = state.changeDay;
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
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
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
                headerDateTextAlign: Alignment.center,
                headerDateTextColor: colorScheme.onBackground,
                isShowFooterDateText: false,
              ),
              onChangedSelectedDate: (DateTime date) {
                changeDay(date);
              }),
          Flexible(
            flex: 1,
            child: Padding(
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
                        onReorder: (int oldIndex, int newIndex) {
                          if (newIndex > realTasks.length) {
                            newIndex -= 1;
                          }
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          final item = realTasks[oldIndex];
                          deleteTask(task: item);
                          insertTask(index: newIndex, item: item);
                        },
                        children: tasksWidgets,
                      ),
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet(
          context: context,
          useSafeArea: true,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (context) => AddRealTask(
            selectedDate: state.currentDay,
          ),
        ),
        label: Text("New task"),
        icon: Icon(Icons.add),
      ),
    );
  }
}
