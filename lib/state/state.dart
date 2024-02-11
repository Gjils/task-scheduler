import 'package:flutter/material.dart';
import 'package:task_scheduler/data/database.dart';
import 'package:task_scheduler/features/task/task.dart';

class AppState extends ChangeNotifier {
  var currentDay = DateTime.now();

  void changeDay(date) async {
    currentDay = date;
    getTasksByDate();
    notifyListeners();
  }

  void getTasksByDate() async {
    _realTasks = await DBProvider.db.getTasksByDate(currentDay);

    notifyListeners();
  }

  var themeIsDark = true;

  void setTheme(bool isDark) {
    themeIsDark = isDark;
    notifyListeners();
  }

  var _realTasks = <TaskReal>[];

  void addRealTask({required TaskReal task}) async {
    _realTasks.add(task);
    await DBProvider.db.newTask(task);
    notifyListeners();
  }

  void replaceTask(
      {required TaskReal newTask, required TaskReal oldTask}) async {
    print("${oldTask.uuid} ${newTask.uuid}+");
    _realTasks[_realTasks.indexOf(oldTask)] = newTask;
    await DBProvider.db.updateTask(newTask);
    notifyListeners();
  }

  void deleteTask({required task}) {
    _realTasks.remove(task);
    DBProvider.db.deleteTask(task);
    notifyListeners();
  }

  void insertTask({required index, required item}) {
    _realTasks.insert(index, item);
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
