import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:task_scheduler/features/task/task.dart';
import 'package:task_scheduler/state/state.dart';

class SchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final realTasks = context.watch<AppState>().realTasks;
    final tasksWidgets = realTasks
        .map((task) => RealTaskCard(task: task))
        .cast<Widget>()
        .toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ListView(
          children: tasksWidgets.isEmpty
              ? [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "There are no tasks\nTry adding new",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                ]
              : tasksWidgets,
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
