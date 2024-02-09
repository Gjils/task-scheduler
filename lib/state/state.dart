import 'package:flutter/material.dart';
import 'package:task_scheduler/features/task/task.dart';

class AppState extends ChangeNotifier {
  var themeIsDark = true;

  void setTheme(bool isDark) {
    themeIsDark = isDark;
    notifyListeners();
  }

  var _realTasks = <TaskReal>[];

  void addRealTask({required TaskReal task}) {
    _realTasks.add(task);
    notifyListeners();
  }

  void replaceTask({required TaskReal newTask, required TaskReal oldTask}) {
    _realTasks[_realTasks.indexOf(oldTask)] = newTask;
    notifyListeners();
  }

  void deleteTask({required task}) {
    _realTasks.remove(task);
    notifyListeners();
  }

  List<TaskReal> get realTasks => _realTasks;

  var _templates = <TaskTemplate>[];

  void addTemplate({required TaskTemplate task}) {
    _templates.add(task);
    notifyListeners();
  }

  void replaceTemplate(
      {required TaskTemplate newTask, required TaskTemplate oldTask}) {
    _templates[_templates.indexOf(oldTask)] = newTask;
    notifyListeners();
  }

  void deleteTemplate({required TaskTemplate task}) {
    _templates.remove(task);
    notifyListeners();
  }

  

  List<TaskTemplate> get templates => _templates;
}
