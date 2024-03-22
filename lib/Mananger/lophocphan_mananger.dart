import 'package:sqflite/sqflite.dart';

import '../Database/database_helper.dart';
import '../QuanLyDiemDanhLopHoc/Models/lophocphan_model.dart';

class LopHocPhanManager {
  final dbHelper = DatabaseHelper();

  Future<Database> getDatabase() async {
    return await dbHelper.initDb();
  }

  Future<List<LopHocPhan>> getAllLopHocPhan() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('lophocphan');
    return List.generate(maps.length, (i) {
      return LopHocPhan.fromMap(maps[i]);
    });
  }

  Future<void> insertLopHocPhan(LopHocPhan lopHocPhan) async {
    // Ensure the id is a String
    final idString = lopHocPhan.id.toString();

    final db = await getDatabase();
    await db.insert('lophocphan', {
      'id': idString,
      'tenLopHocPhan': lopHocPhan.tenLopHocPhan,
    });
  }


  Future<void> updateLopHocPhan(LopHocPhan lopHocPhan) async {
    final db = await getDatabase();
    await db.update(
      'lophocphan',
      {'tenLopHocPhan': lopHocPhan.tenLopHocPhan},
      where: 'id = ?',
      whereArgs: [lopHocPhan.id],
    );
  }

  Future<void> deleteLopHocPhan(String id) async {
    final db = await getDatabase();
    await db.delete(
      'lophocphan',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
