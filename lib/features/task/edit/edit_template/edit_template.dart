import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:task_scheduler/features/duration_picker/duration_picker.dart';
import 'package:task_scheduler/features/name_text_field/name_text_field.dart';
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
    controller.text = widget.template.title;
    durationController.value = widget.template.duration;
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
        if (errorText != null) {
          return;
        }
        replaceTemplate(
          newTask: TaskTemplate(title: controller.text, duration: durationController.value),
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
