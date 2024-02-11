import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

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
  TaskTemplate({required super.title, required super.duration, uuid}) {
    if (uuid != null) {
      this.uuid = uuid;
    } else {
      this.uuid = Uuid().v1();
    }
  }

  late String uuid;

  @override
  String get type => "Template";

  factory TaskTemplate.fromJson(Map<String, dynamic> json) => TaskTemplate(
        title: json["title"],
        duration: Duration(milliseconds: json["duration"]),
        uuid: json["uuid"],
      );

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "title": title,
        "duration": duration,
      };
}

class TaskReal extends Task with ChangeNotifier {
  TaskReal({
    required super.title,
    required super.duration,
    required this.status,
    required this.completedPart,
    required this.lastActionTime,
    required this.creationDate,
    uuid,
  }) {
    if (uuid != null) {
      this.uuid = uuid;
    } else {
      this.uuid = Uuid().v1();
    }
  }

  late String uuid;

  final DateTime creationDate;

  String status;
  Duration completedPart;
  DateTime lastActionTime;

  @override
  String get type => "Real";

  factory TaskReal.fromJson(Map<String, dynamic> json) => TaskReal(
      title: json["title"],
      duration: Duration(seconds: json["duration"]),
      uuid: json["uuid"],
      status: json["status"],
      completedPart: Duration(seconds: json["completedPart"]),
      lastActionTime:
          DateTime.fromMicrosecondsSinceEpoch(json["lastActionTime"]),
      creationDate: DateTime.parse(json["creationDate"]));

  Map<String, dynamic> toJson() => {
        "uuid": uuid,
        "title": title,
        "duration": duration.inSeconds,
        "completedPart": completedPart.inSeconds,
        "status": status,
        "lastActionTime": lastActionTime.microsecondsSinceEpoch,
        "creationDate":
            DateFormat("yyyy-MM-dd").format(creationDate),
      };
}
