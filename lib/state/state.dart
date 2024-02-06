import 'package:flutter/material.dart';
import '../themes/themes.dart';
import 'package:task_scheduler/features/task/task.dart';

class AppState extends ChangeNotifier {
  var theme = darkColorScheme;

  var _realTasks = <TaskReal>[];

  void addRealTask({required TaskReal task}) {
    _realTasks.add(task);
    notifyListeners();
  }

  void toggleDone(task) {
    _realTasks[_realTasks.indexOf(task)].toggleDone();
    notifyListeners();
  }

  List<TaskReal> get realTasks => _realTasks;

  var _templates = <TaskTemplate>[];

  void addTemplate({required TaskTemplate task}) {
    _templates.add(task);
    notifyListeners();
  }

  List<TaskTemplate> get templates => _templates;
}
