class LopHocPhan {
  String id; // Ensure id is String type
  String tenLopHocPhan;

  LopHocPhan({
    required this.id,
    required this.tenLopHocPhan,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tenLopHocPhan': tenLopHocPhan,
    };
  }

  factory LopHocPhan.fromMap(Map<String, dynamic> map) {
    return LopHocPhan(
      id: map['id'].toString(), // Explicitly cast to String
      tenLopHocPhan: map['tenLopHocPhan'],
    );
  }
}
