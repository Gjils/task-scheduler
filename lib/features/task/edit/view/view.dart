import 'package:flutter/material.dart';

import '../../model/model.dart';

class EditTask extends StatelessWidget {
  const EditTask({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    String type = task.type;
    return Text(type);
  }
}
