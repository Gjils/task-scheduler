import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:task_scheduler/features/duration_picker/duration_picker.dart';
import 'package:task_scheduler/features/name_text_field/name_text_field.dart';
import 'package:task_scheduler/features/task/task.dart';

import '../container/container.dart';
import 'package:task_scheduler/state/state.dart';

class AddTemplate extends StatefulWidget {
  const AddTemplate({super.key, required this.index});

  final double index;

  @override
  State<AddTemplate> createState() => _AddTemplateState();
}

class _AddTemplateState extends State<AddTemplate> {
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
        if (errorText != null) {
          return;
        }
        addTemplate(
          task: TaskTemplate(
            index: widget.index,
            title: controller.text,
            duration: durationController.value,
          ),
        );
        Navigator.pop(context);
      },
      content: Column(
        children: [
          NameTextField(
            label: "Template name",
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
        ],
      ),
    );
  }
}
