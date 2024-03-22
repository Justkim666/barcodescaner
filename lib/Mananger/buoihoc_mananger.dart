import 'package:sqflite/sqflite.dart';
import '../Database/database_helper.dart';
import '../QuanLyDiemDanhLopHoc/Models/buoihoc_model.dart';

class BuoiHocManager {
  final dbHelper = DatabaseHelper();

  Future<Database> getDatabase() async {
    return await dbHelper.initDb();
  }

  Future<void> insertBuoiHoc(BuoiHoc buoiHoc, String lophocId) async {
    final db = await getDatabase();
    await db.insert(
      'buoihoc',
      {
        'id': buoiHoc.id,
        'tenBuoiHoc': buoiHoc.tenBuoiHoc,
        'lophocId': lophocId
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
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

  Future<void> updateBuoiHoc(BuoiHoc buoiHoc) async {
    final db = await getDatabase();
    print('Updating BuoiHoc with ID: ${buoiHoc.id}');
    print('BuoiHoc Data: ${buoiHoc.toMap()}');
    await db.update(
      'buoihoc',
      buoiHoc.toMap(),
      where: 'id = ?',
      whereArgs: [buoiHoc.id],
    );
    print('BuoiHoc Updated Successfully');
  }


  Future<void> deleteBuoiHoc(String id) async {
    final db = await getDatabase();
    await db.delete(
      'buoihoc',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
