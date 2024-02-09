import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:task_scheduler/features/task/task.dart';
import 'package:task_scheduler/state/state.dart';

class SchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final realTasks = state.realTasks;
    final deleteTask = state.deleteTask;
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
            : ReorderableListView(
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet(
          context: context,
          useSafeArea: true,
          isScrollControlled: true,
          showDragHandle: true,
          builder: (context) => AddRealTask(),
        ),
        label: Text("New task"),
        icon: Icon(Icons.add),
      ),
    );
  }
}
