import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

Uuid uuidGenerator = Uuid();

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

  final uuid = Uuid();

  @override
  String get type => "Template";
}

class TaskReal extends Task with ChangeNotifier {
  TaskReal({
    required super.title,
    required super.duration,
    required this.status,
    required this.completedPart,
    uuid,
    this.parent,
    this.lastActionTime,
  }) {
    if (uuid != null) {
      this.uuid = uuid;
    } else {
      this.uuid = Uuid().v1();
    }
  }

  late String uuid;

  final TaskTemplate? parent;

  String status;
  Duration completedPart;
  DateTime? lastActionTime;

  @override
  String get type => "Real";
}
