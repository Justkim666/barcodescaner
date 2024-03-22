class SinhVien {
  String maSinhVien;
  String ten;
  bool diemDanh;
  String buoihocId;

  SinhVien({
    required this.maSinhVien,
    required this.ten,
    this.diemDanh = false,
    required this.buoihocId
  });

  Map<String, dynamic> toMap() {
    return {
      'maSinhVien': maSinhVien,
      'ten': ten,
      'diemDanh': diemDanh ? 1 : 0,
      'lophocId': buoihocId
    };
  }

  factory SinhVien.fromMap(Map<String, dynamic> map) {
    return SinhVien(
      maSinhVien: map['maSinhVien'],
      ten: map['ten'],
      diemDanh: map['diemDanh'] == 1,
      buoihocId: map['buoihocId']
    );
  }
}