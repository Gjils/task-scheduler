import 'package:flutter/material.dart';
import 'package:task_scheduler/data/database.dart';
import 'package:task_scheduler/features/task/task.dart';

class AppState extends ChangeNotifier {
  AppState() {
    getTasksByDate();
  }

  var themeIsDark = true;

  void setTheme(bool isDark) {
    themeIsDark = isDark;
    notifyListeners();
  }

  var currentDay = DateTime.now();

  void changeDay(date) async {
    currentDay = date;
    notifyListeners();
    getTasksByDate();
  }

  var _realTasks = <TaskReal>[];

  void getTasksByDate() async {
    _realTasks = await DBProvider.db.getTasksByDate(currentDay);
    notifyListeners();
  }

  void addRealTask({required TaskReal task}) {
    _realTasks.add(task);
    notifyListeners();
    DBProvider.db.newTask(task);
  }

  void updateTask({required TaskReal task}) {
    _realTasks[_realTasks.indexOf(task)] = task;
    notifyListeners();
    DBProvider.db.updateTask(task);
  }

  void deleteTask({required TaskReal task}) {
    _realTasks.remove(task);
    notifyListeners();
    DBProvider.db.deleteTask(task);
  }

  void insertTask({required task, required index}) {
    _realTasks.remove(task);
    _realTasks.insert(index, task);
    notifyListeners();
  }

  List<TaskReal> get realTasks => _realTasks;

  var _templates = <TaskTemplate>[];

  void addTemplate({required TaskTemplate task}) {
    _templates.add(task);
    notifyListeners();
    DBProvider.db.newTemplate(task);
  }

  void updateTemplate(
      {required TaskTemplate task}) {
    _templates[_templates.indexOf(task)] = task;
    notifyListeners();
    DBProvider.db.updateTemplate(task);
  }

  void deleteTemplate({required TaskTemplate task}) {
    _templates.remove(task);
    notifyListeners();
    DBProvider.db.deleteTemplate(task);
  }

  List<TaskTemplate> get templates => _templates;
}
