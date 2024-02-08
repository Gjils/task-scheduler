import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_scheduler/features/duration_picker/duration_picker.dart';

import 'package:task_scheduler/features/task/task.dart';
import '../container/container.dart';
import 'package:task_scheduler/state/state.dart';
import 'package:task_scheduler/features/name_text_field/name_text_field.dart';

import '../import_dialog/import_dialog.dart';

class AddRealTask extends StatefulWidget {
  const AddRealTask({super.key, this.template});

  final TaskTemplate? template;

  @override
  State<AddRealTask> createState() => _AddRealTaskState();
}

class _AddRealTaskState extends State<AddRealTask> {
  ValueNotifier<Duration> durationController =
      ValueNotifier<Duration>(Duration(minutes: 30));
  String _text = "";
  TextEditingController controller = TextEditingController();
  FocusNode focus = FocusNode();
  void refreshState() {
    setState(() {
      _text;
    });
  }

  @override
  void initState() {
    if (widget.template != null) {
      controller.text = widget.template!.title;
      durationController.value = widget.template!.duration;
    }
    super.initState();
  }

  String? get errorText {
    return getErrorText(
      controller: controller,
      focus: focus,
    )();
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
        if (errorText != null) {
          return;
        }
        addRealTask(
          task: TaskReal(
              title: controller.text,
              duration: durationController.value,
              isDone: false),
        );
        Navigator.pop(context);
      },
      content: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          NameTextField(
            controller: controller,
            focus: focus,
            refreshState: refreshState,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Select duration",
            style: TextStyle(fontSize: 16),
          ),
          DurationPicker(
            durationController: durationController,
          ),
          SizedBox(
            height: 20,
          ),
          FilledButton.tonal(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) =>
                      ImportDialog(templatesWidgets: templatesWidgets),
                ).then((value) {
                  if (value == null) {
                    return;
                  }
                  Navigator.pop(context);
                  showModalBottomSheet(
                    context: context,
                    useSafeArea: true,
                    isScrollControlled: true,
                    showDragHandle: true,
                    builder: (context) => AddRealTask(template: value),
                  );
                });
              },
              child: Text("Import from templates"))
        ],
      ),
    );
  }
}
