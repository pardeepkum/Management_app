import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TaskDatabase {
  static const String tableName = 'tasks';

  static Future<Database> getDatabase() async {
    var dbPath = await getDatabasesPath();
    return openDatabase(join(dbPath, 'task_manager.db'), version: 2,
        onCreate: (db, version) {
      return db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY,
        title TEXT,
        description TEXT,
        isCompleted INTEGER,
        dateCreated INTEGER
      )
    ''');
    }, onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db
            .execute('ALTER TABLE $tableName ADD COLUMN dateCreated INTEGER');
      }
    });
  }

  static Future<int> insertTask(Map<String, dynamic> task) async {
    final db = await getDatabase();
    return await db.insert(tableName, task);
  }

  static Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await getDatabase();
    return await db.query(tableName);
  }

  static Future<int> updateTask(Map<String, dynamic> task) async {
    final db = await getDatabase();
    return await db
        .update(tableName, task, where: 'id = ?', whereArgs: [task['id']]);
  }

  static Future<int> deleteTask(int id) async {
    final db = await getDatabase();
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
