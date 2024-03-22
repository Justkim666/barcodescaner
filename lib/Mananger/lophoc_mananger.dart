import 'package:sqflite/sqflite.dart';
import '../Database/database_helper.dart';
import '../QuanLyDiemDanhLopHoc/Models/buoihoc_model.dart';
import '../QuanLyDiemDanhLopHoc/Models/lophoc_model.dart';

class LopHocManager {
  final dbHelper = DatabaseHelper();

  Future<Database> getDatabase() async {
    return await dbHelper.initDb();
  }

  Future<void> insertLopHoc(LopHoc lopHoc, String lophocphanId) async {
    final db = await getDatabase();
    await db.insert(
      'lophoc',
      {
        'id': lopHoc.id,
        'tenLop': lopHoc.tenLop,
        'lophocphanId': lophocphanId,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<LopHoc>> getAllLopHoc(String lophocphanId) async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'lophoc',
      where: 'lophocphanId = ?',
      whereArgs: [lophocphanId],
    );

    return List.generate(maps.length, (i) {
      return LopHoc.fromMap(maps[i]);
    });
  }


  Future<void> updateLopHoc(LopHoc lopHoc) async {
    final db = await getDatabase();
    await db.update(
      'lophoc',
      {
        'tenLop': lopHoc.tenLop,
      },
      where: 'id = ?',
      whereArgs: [lopHoc.id],
    );
  }

  Future<void> deleteLopHoc(String id) async {
    final db = await getDatabase();
    await db.delete(
      'lophoc',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<BuoiHoc>> getBuoiHocForLopHoc(String lophocId) async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'buoihoc',
      where: 'lophocId = ?',
      whereArgs: [lophocId],
    );

    return List.generate(maps.length, (i) {
      return BuoiHoc.fromMap(maps[i]);
    });
  }
}
