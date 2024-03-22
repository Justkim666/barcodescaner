class LopHoc {
  String id;
  String tenLop;
  //Them vao de ket noi voi bang LopHocPhan
  String lophocphanId;

  LopHoc({
    required this.id,
    required this.tenLop,
    required this.lophocphanId
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tenLop': tenLop,
    };
  }

  factory LopHoc.fromMap(Map<String, dynamic> map) {
    return LopHoc(
      id: map['id'],
      tenLop: map['tenLop'],
        lophocphanId: map['lophocphanId']
    );
  }
}
