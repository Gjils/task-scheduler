import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_scheduler/features/task/task.dart';

import '../container/container.dart';
import 'package:task_scheduler/state/state.dart';

class EditTemplate extends StatefulWidget {
  const EditTemplate({super.key, required this.template});

  final TaskTemplate template;

  @override
  State<EditTemplate> createState() => _EditTemplateState();
}

class _EditTemplateState extends State<EditTemplate> {
  dynamic _controller;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.template.title);
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
    final replaceTemplate = context.watch<AppState>().replaceTemplate;
    final deleteTemplate = context.watch<AppState>().deleteTemplate;
    return EditContainer(
      label: Text(
        "Edit template",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      onSave: () {
        if (_errorText != null) {
          return;
        }
        replaceTemplate(
          newTask: TaskTemplate(title: _controller.text),
          oldTask: widget.template,
        );
        Navigator.pop(context);
      },
      onDelete: () {
        deleteTemplate(task: widget.template);
        Navigator.pop(context);
      },
      content: Column(
        children: [
          TextField(
            controller: _controller,
            onChanged: (text) => setState(() => _text),
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Template name',
              errorText: _errorText,
            ),
          ),
        ],
      ),
    );
  }
}
