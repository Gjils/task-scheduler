import 'package:flutter/material.dart';

class Task {
  Task({
    required this.title,
  });

  final String title;

  String get type => "None";
}

class TaskTemplate extends Task {
  TaskTemplate({
    required super.title,
  });

  @override
  String get type => "Template";
}

class TaskReal extends Task with ChangeNotifier {
  TaskReal({
    required super.title,
    required this.isDone,
    this.parent,
  });

  final dynamic parent;
  bool isDone;

  void toggleDone() {
    isDone = !isDone;
  }

  @override
  String get type => "Real";
}
