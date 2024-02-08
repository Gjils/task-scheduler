import 'package:flutter/material.dart';

class Task {
  Task({
    required this.title,
    required this.duration,
  });

  final String title;
  final Duration duration;

  String? get type => null;
}

class TaskTemplate extends Task {
  TaskTemplate({
    required super.title,
    required super.duration,
  });

  @override
  String get type => "Template";
}

class TaskReal extends Task with ChangeNotifier {
  TaskReal({
    required super.title,
    required super.duration,
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
