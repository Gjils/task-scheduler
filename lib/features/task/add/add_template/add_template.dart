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
          if (_errorText != null) {
            return;
          }
          addTemplate(task: TaskTemplate(title: _controller.text));
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
                labelText: 'Template name',
                errorText: _errorText,
              ),
            ),
          ],
        ));
  }
}
