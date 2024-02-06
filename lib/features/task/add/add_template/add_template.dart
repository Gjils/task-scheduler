import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_scheduler/features/task/task.dart';

import '../container/container.dart';
import 'package:task_scheduler/state/state.dart';

class AddTemplate extends StatefulWidget {
  const AddTemplate({super.key});

  @override
  State<AddTemplate> createState() => _AddTemplateState();
}

class _AddTemplateState extends State<AddTemplate> {
  var _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final addTemplate = context.watch<AppState>().addTemplate;
    return AddNewTask(
        label: Text(
          "Add new template",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        onSave: () {
          addTemplate(task: TaskTemplate(title: _controller.text));
        },
        content: Column(
          children: [
            TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Template name',
              ),
            ),
          ],
        ));
  }
}
