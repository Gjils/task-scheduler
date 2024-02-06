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
  dynamic _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  var _text = "";

  String? get _errorText {
    final text = _controller.value.text;
    if (text.isEmpty) {
      return 'Can\'t be empty';
    }
    return null;
  }

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
          if (_errorText != null) {
            return;
          }
          addRealTask(task: TaskReal(title: _controller.text, isDone: false));
          Navigator.pop(context);
        },
        content: Column(
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              onChanged: (text) => setState(() => _text),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Task name',
                errorText: _errorText,
              ),
            ),
          ],
        ));
  }
}
