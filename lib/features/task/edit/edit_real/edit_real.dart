import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_scheduler/features/task/task.dart';

import '../container/container.dart';
import 'package:task_scheduler/state/state.dart';

class EditRealTask extends StatefulWidget {
  const EditRealTask({super.key, required this.task});

  final TaskReal task;

  @override
  State<EditRealTask> createState() => _EditRealTaskState();
}

class _EditRealTaskState extends State<EditRealTask> {
  dynamic _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.task.title);
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
    // _controller.text = widget.task.title;
    final replaceTask = context.watch<AppState>().replaceTask;
    final deleteTask = context.watch<AppState>().deleteTask;
    return EditContainer(
      label: Text(
        "Edit task",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      onSave: () {
        if (_errorText != null) {
          return;
        }
        replaceTask(
          newTask:
              TaskReal(title: _controller.text, isDone: widget.task.isDone),
          oldTask: widget.task,
        );
        Navigator.pop(context);
      },
      onDelete: () {
        deleteTask(task: widget.task);
        Navigator.pop(context);
      },
      content: Column(
        children: [
          TextField(
            controller: _controller,
            onChanged: (text) => setState(() => _text),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Task name',
              errorText: _errorText,
            ),
          ),
        ],
      ),
    );
  }
}
