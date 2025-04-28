import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('records.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        crops TEXT NOT NULL,
        task TEXT NOT NULL,
        field TEXT,
        note TEXT
      )
    ''');
  }
  //新增
  Future<int> insertRecord(Map<String, dynamic> record) async {
    final db = await instance.database;
    return await db.insert('records', record);
  }
  //查詢
  Future<List<Map<String, dynamic>>> getRecords() async {
    final db = await instance.database;
    return await db.query('records', orderBy: 'date DESC');
  }
  //刪除
  Future<int> deleteRecord(int id) async {
    final db = await instance.database;
    return await db.delete('records', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
