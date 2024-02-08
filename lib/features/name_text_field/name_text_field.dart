import 'package:flutter/material.dart';

class NameTextField extends StatelessWidget {
  NameTextField({
    super.key,
    required this.controller,
    required this.focus,
    required this.refreshState,
  });

  final TextEditingController controller;
  final FocusNode focus;
  final void Function() refreshState;
  String? get errorText {
    return getErrorText(controller: controller, focus: focus)();
  }

  @override
  Widget build(BuildContext context) {
    focus.addListener(refreshState);

    return TextField(
      controller: controller,
      focusNode: focus,
      autofocus: true,
      onChanged: (text) {
        refreshState();
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Task name',
        errorText: errorText,
      ),
    );
  }
}

getErrorText({required controller, required focus}) {
  return () {
    final text = controller.value.text;
    if (text.isEmpty && !focus.hasFocus) {
      return 'Can\'t be empty';
    }
    return null;
  };
}
