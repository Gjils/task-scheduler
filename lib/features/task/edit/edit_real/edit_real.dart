import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:task_scheduler/features/duration_picker/duration_picker.dart';
import 'package:task_scheduler/features/name_text_field/name_text_field.dart';
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

  String? get errorText {
    return getErrorText(
      controller: controller,
      focus: focus,
    )();
  }

  @override
  void initState() {
    super.initState();
    controller.text = widget.task.title;
    durationController.value = widget.task.duration;
  }

  @override
  Widget build(BuildContext context) {
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
        if (errorText != null) {
          return;
        }
        replaceTask(
          newTask: TaskReal(
              title: controller.text,
              duration: durationController.value,
              isDone: widget.task.isDone),
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
          NameTextField(
              controller: controller, focus: focus, refreshState: refreshState),
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
        ],
      ),
    );
  }
}
