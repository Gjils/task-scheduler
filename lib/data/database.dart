import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_scheduler/features/task/model/model.dart';
import 'package:intl/intl.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = p.join(documentsDirectory.path, "Tasks.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Task ("
          "uuid TEXT PRIMARY KEY,"
          "title TEXT,"
          "duration INTEGER,"
          "completedPart INTEGER,"
          "status TEXT,"
          "lastActionTime INTEGER,"
          "creationDate INTEGER"
          ")");
    });
  }

  newTask(TaskReal newTask) async {
    final db = await database;
    var res = await db?.insert("Task", newTask.toJson());
    return res;
  }

  getTasksByDate(DateTime date) async {
    var strDate = DateFormat("yyyy-MM-dd").format(date);
    final db = await database;
    var res =
        await db?.rawQuery("SELECT * FROM Task WHERE creationDate=?", [strDate]);
    List<TaskReal> list = res
            ?.map((item) => TaskReal.fromJson(item))
            .toList()
            .cast<TaskReal>() ??
        [];
    return list;
  }

  deleteTask(TaskReal task) async {
    final db = await database;
    db?.delete("Task", where: "uuid = ?", whereArgs: [task.uuid]);
  }

  updateTask(TaskReal task) async {
    final db = await database;
    var res = await db?.update("Task", task.toJson(),
        where: "uuid = ?", whereArgs: [task.uuid]);
    return res;
  }
}
