import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:sqflite/sqflite.dart';

import '../Database/database_helper.dart';
import '../QuanLyDiemDanhLopHoc/Models/sinhvien_model.dart';

class SinhVienManager {
  final dbHelper = DatabaseHelper();

  Future<Database> getDatabase() async {
    return await dbHelper.initDb();
  }

  Future<void> insertSinhVien(SinhVien sinhVien, String buoihocId) async {
    final db = await getDatabase();
    await db.insert(
      'sinhvien',
      {
        'ten': sinhVien.ten,
        'maSinhVien': sinhVien.maSinhVien,
        'diemDanh': sinhVien.diemDanh ? 1 : 0,
        'buoihocId': buoihocId
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SinhVien>> getAllSinhVien(String buoihocId) async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(
      'sinhvien',
      where: 'buoihocId = ?',
      whereArgs: [buoihocId],
    );

    return List.generate(maps.length, (i) {
      return SinhVien.fromMap(maps[i]);
    });
  }

  Future<void> updateSinhVien(SinhVien sinhVien) async {
    final db = await getDatabase();
    await db.update(
      'sinhvien',
      {
        'ten': sinhVien.ten,
        'maSinhVien': sinhVien.maSinhVien,
        'diemDanh': sinhVien.diemDanh ? 1 : 0,
      },
      where: 'maSinhVien = ?',
      whereArgs: [sinhVien.maSinhVien],
    );
  }

  Future<void> deleteSinhVien(String maSinhVien) async {
    final db = await getDatabase();
    await db.delete(
      'sinhvien',
      where: 'maSinhVien = ?',
      whereArgs: [maSinhVien],
    );
  }

  Future<void> addSinhVienFromExcel(File excelFile, String buoihocId) async {
    var bytes = await excelFile.readAsBytes();
    var excel = Excel.decodeBytes(Uint8List.fromList(bytes));

    // Lấy sheet đầu tiên
    var sheet = excel['Sheet1']; // Tùy thuộc vào tên sheet trong Excel của bạn

    // Bắt đầu từ dòng thứ 2 để bỏ qua dòng header
    for (var table in sheet.rows) {
      // Đọc dữ liệu từ cột trong Excel
      String ten = table[1]?.value?.toString() ?? '';
      String maSinhVien = table[2]?.value?.toString() ?? '';
      // Kiểm tra xem có thông tin cần thiết không
      if (ten.isNotEmpty && maSinhVien.isNotEmpty) {
        // Tạo đối tượng SinhVien và thêm vào cơ sở dữ liệu
        SinhVien sinhVien = SinhVien(
          maSinhVien: maSinhVien,
          ten: ten,
          buoihocId: buoihocId,
        );
        await insertSinhVien(sinhVien, buoihocId);
      }
    }
  }
}
