import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_bloc_sqllite/core/constants/db_helper.dart';
import 'package:todo_bloc_sqllite/features/todo_display/data/models/todo.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;
  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDb('todos.db');
    return _database!;
  }

  _initDb(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  FutureOr<void> _createDb(Database db, int version) async {
    await db.execute('''
CREATE TABLE todos ( 
  _id INTEGER PRIMARY KEY AUTOINCREMENT, 
  isImportant BOOLEAN NOT NULL,
  number INTEGER NOT NULL,
  title TEXT NOT NULL,
  description NOT NULL,
  time NOT NULL
  )
''');
  }

  Future<Todo> create(Todo todo) async {
    final db = await instance.database;
    final id = await db.insert(DbHelper.todoTable, todo.toJson());
    return todo.copyWith(id: id);
  }

  Future<Todo> readTodo({required int id}) async {
    final db = await instance.database;

    final maps = await db.query(
      DbHelper.todoTable,
      columns: DbHelper.values,
      where: '${DbHelper.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Todo.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Todo>> readAllTodos() async {
    final db = await instance.database;
    const orderBy = '${DbHelper.time} ASC';
    final result = await db.query(DbHelper.todoTable, orderBy: orderBy);
    return result.map((json) => Todo.fromJson(json)).toList();
  }

  Future<int> update({required Todo todo}) async {
    final db = await instance.database;
    return db.update(
      DbHelper.todoTable,
      todo.toJson(),
      where: '${DbHelper.id} = ?',
      whereArgs: [todo.id],
    );
  }

  Future<int> delete({required int id}) async {
    final db = await instance.database;
    return db.delete(
      DbHelper.todoTable,
      where: '${DbHelper.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
