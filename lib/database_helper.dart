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

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE records (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        crops TEXT NOT NULL,
        task TEXT NOT NULL,
        field TEXT,
        note TEXT,
        fertilizer_used INTEGER DEFAULT 0, 
        fertilizer_type TEXT,
        fertilizer_amount REAL,
        fertilizer_unit TEXT
      )
    ''');
  }

  // 升級資料表 (舊安裝升級補欄位)
  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // ✅ 檢查並新增缺少的欄位
      await db.execute("ALTER TABLE records ADD COLUMN fertilizer_used INTEGER DEFAULT 0");
      await db.execute("ALTER TABLE records ADD COLUMN fertilizer_type TEXT");
      await db.execute("ALTER TABLE records ADD COLUMN fertilizer_amount REAL");
      await db.execute("ALTER TABLE records ADD COLUMN fertilizer_unit TEXT");
    }
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
  //修改
  Future<int> updateRecord(int id, Map<String, dynamic> record) async{
    final db = await instance.database;
    return await db.update('records', record, where: 'id = ?', whereArgs: [id],);
  }

  //刪除
  Future<int> deleteRecord(int id) async {
    final db = await instance.database;
    return await db.delete('records', where: 'id = ?', whereArgs: [id]);
  }

  //print data
  Future<void> printAllRecords() async {
    final db = await instance.database;
    final result = await db.query('records');
    for (var row in result) {
      print(row);
    }
  }


  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
