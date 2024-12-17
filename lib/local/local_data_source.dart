import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../modules/home/model/task-item.dart';

class LocalDataSource {
  static final LocalDataSource _instance = LocalDataSource._internal();
  factory LocalDataSource() => _instance;
  LocalDataSource._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'todo.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks (
            id TEXT PRIMARY KEY,
            title TEXT NOT NULL,
            description TEXT,
            dueDate INTEGER,
            priority INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> createTask(TaskItem task) async {
    try {
      final db = await database;
      await db.insert(
        'tasks',
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Task added: ${task.toMap()}');
    } catch (e) {
      print('Failed to add task: $e');
    }
  }


  Future<List<TaskItem>> fetchAllTasks() async {
    print('database fetch called');
    final db = await database;
    final maps = await db.query('tasks');
    return maps.map((taskMap) => TaskItem.fromMap(taskMap)).toList();
  }

  Future<bool> updateTask(TaskItem task) async {
    try {
      final db = await database;
      final rowsUpdated = await db.update(
        'tasks',
        task.toMap(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
      if (rowsUpdated > 0) {
        print('Update in database successful');
        return true;
      } else {
        print('No task found with the given ID to update');
        return false;
      }
    } catch (e) {
      print('Failed to update task in database: $e');
      return false;
    }
  }

  Future<bool> deleteTask(String id) async {
    try {
      final db = await database;
      final rowsDeleted = await db.delete(
        'tasks',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (rowsDeleted > 0) {
        print('Task deleted successfully');
        return true;
      } else {
        print('No task found with the given ID to delete');
        return false;
      }
    } catch (e) {
      print('Failed to delete task: $e');
      return false;
    }
  }

  Future<void> deleteAllTasks() async {
    final db = await database;
    await db.delete('tasks');
    print('All tasks have been deleted');
  }
}