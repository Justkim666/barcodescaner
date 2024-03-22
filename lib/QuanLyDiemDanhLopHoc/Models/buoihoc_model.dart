class BuoiHoc {
  String id;
  String tenBuoiHoc;
  String lophocId;

  BuoiHoc({
    required this.id,
    required this.tenBuoiHoc,
    required this.lophocId
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tenBuoiHoc': tenBuoiHoc,
      'lophocId': lophocId
    };
  }

  factory BuoiHoc.fromMap(Map<String, dynamic> map) {
    return BuoiHoc(
      id: map['id'],
      tenBuoiHoc: map['tenBuoiHoc'],
      lophocId: map['lophocId']
    );
  }
}