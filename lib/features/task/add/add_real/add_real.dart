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
    _focus.addListener(_onFocusChange);
  }

  FocusNode _focus = FocusNode();
  var _text = "";

  void _onFocusChange() {
    setState(() {
      _text;
    });
  }

  String? get _errorText {
    final text = _controller.value.text;
    if (text.isEmpty && !_focus.hasFocus) {
      return 'Can\'t be empty';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final addRealTask = state.addRealTask;
    final templates = state.templates;
    final templatesWidgets = templates
        .map(
          (item) => GestureDetector(
            onTap: () {
              Navigator.pop(context, item);
            },
            child: Card(
              child: ListTile(
                title: Text(item.title),
              ),
            ),
          ),
        )
        .cast<Widget>()
        .toList();
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
              focusNode: _focus,
              autofocus: true,
              onChanged: (text) => setState(() => _text),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Task name',
                errorText: _errorText,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            FilledButton.tonal(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Center(child: Text("Select template")),
                      content: SizedBox(
                        height: 300,
                        width: 300,
                        child: SingleChildScrollView(
                          child: Column(
                            children: templatesWidgets.isEmpty
                                ? [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "There are no templates\nTry adding new",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ]
                                : templatesWidgets,
                          ),
                        ),
                      ),
                    ),
                  ).then((value) {
                    if (value == null) {
                      return;
                    }
                    _controller.text = value.title;
                    setState(() {
                      _text;
                    });
                  });
                },
                child: Text("Import from templates"))
          ],
        ));
  }
}
