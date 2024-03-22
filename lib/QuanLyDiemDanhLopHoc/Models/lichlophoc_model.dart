// Trong lop_hoc_model.dart

class LichLopHoc {
  late  String tenLop;
  late  String monHoc;
  late  String phongHoc;
  late  String gioBatDau;
  late  String gioKetThuc;

  LichLopHoc({
    required this.tenLop,
    required this.monHoc,
    required this.phongHoc,
    required this.gioBatDau,
    required this.gioKetThuc,
  });

  // Thêm hàm toJson để chuyển đổi đối tượng thành dạng JSON
  Map<String, dynamic> toJson() {
    return {
      'tenLop': tenLop,
      'monHoc': monHoc,
      'phongHoc': phongHoc,
      'gioBatDau': gioBatDau,
      'gioKetThuc': gioKetThuc,
    };
  }

  // Thêm hàm fromJson để chuyển đổi từ dạng JSON thành đối tượng
  factory LichLopHoc.fromJson(Map<String, dynamic> json) {
    return LichLopHoc(
      tenLop: json['tenLop'],
      monHoc: json['monHoc'],
      phongHoc: json['phongHoc'],
      gioBatDau: json['gioBatDau'],
      gioKetThuc: json['gioKetThuc'],
    );
  }
}

class LichDay {
  final String ngayHoc;
  final List<LichLopHoc> buoiSang;
  final List<LichLopHoc> buoiChieu;

  LichDay({
    required this.ngayHoc,
    required this.buoiSang,
    required this.buoiChieu,
  });

  // Thêm hàm toJson để chuyển đổi đối tượng thành dạng JSON
  Map<String, dynamic> toJson() {
    return {
      'ngayHoc': ngayHoc,
      'buoiSang': buoiSang.map((lichLopHoc) => lichLopHoc.toJson()).toList(),
      'buoiChieu': buoiChieu.map((lichLopHoc) => lichLopHoc.toJson()).toList(),
    };
  }

  // Thêm hàm fromJson để chuyển đổi từ dạng JSON thành đối tượng
  factory LichDay.fromJson(Map<String, dynamic> json) {
    return LichDay(
      ngayHoc: json['ngayHoc'],
      buoiSang: (json['buoiSang'] as List<dynamic>)
          .map((item) => LichLopHoc.fromJson(item))
          .toList(),
      buoiChieu: (json['buoiChieu'] as List<dynamic>)
          .map((item) => LichLopHoc.fromJson(item))
          .toList(),
    );
  }
}
