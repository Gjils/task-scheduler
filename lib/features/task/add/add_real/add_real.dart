import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_scheduler/features/task/task.dart';

import '../container/container.dart';
import 'package:task_scheduler/state/state.dart';

class AddRealTask extends StatefulWidget {
  const AddRealTask({super.key});

  @override
  State<AddRealTask> createState() => _AddRealTaskState();
}

class _AddRealTaskState extends State<AddRealTask> {
  var _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final addRealTask = context.watch<AppState>().addRealTask;
    return AddNewTask(
        label: Text(
          "Add new task",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        onSave: () {
          addRealTask(task: TaskReal(title: _controller.text, isDone: false));
        },
        content: Column(
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Task name',
              ),
            ),
          ],
        ));
  }
}
