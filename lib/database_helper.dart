import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Future<Database> initializeDatabase() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'my_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE user_data(id INTEGER PRIMARY KEY, text TEXT)',
        );
      },
      version: 1,
    );
    return database;
  }

  static Future<void> insertData(Database database, String text) async {
    await database.insert(
      'user_data',
      {'text': text},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<String>> fetchData(Database database) async {
    final List<Map<String, dynamic>> maps = await database.query('user_data');
    return List.generate(maps.length, (i) {
      return maps[i]['text'];
    });
  }
}
