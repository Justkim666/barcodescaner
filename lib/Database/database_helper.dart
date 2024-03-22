import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  DatabaseHelper.internal();

  Future<Database> initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'quanlydiemdanh.db');

    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sinhvien (
        maSinhVien TEXT PRIMARY KEY,
        ten TEXT,
        diemDanh INTEGER,
        buoihocId TEXT,
        FOREIGN KEY (buoihocId) REFERENCES buoihoc (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE buoihoc (
        id TEXT PRIMARY KEY,
        tenBuoiHoc TEXT,
        lophocId TEXT,
        FOREIGN KEY (lophocId) REFERENCES lophoc (id)
      )
    ''');

      await db.execute('''
        CREATE TABLE lophoc (
          id TEXT PRIMARY KEY,
          tenLop TEXT,
          lophocphanId TEXT,
          FOREIGN KEY (lophocphanId) REFERENCES lophocphan (id)
        )
      ''');

    await db.execute('''
      CREATE TABLE lophocphan (
        id TEXT PRIMARY KEY,
        tenLopHocPhan TEXT
      )
    ''');
  }
}