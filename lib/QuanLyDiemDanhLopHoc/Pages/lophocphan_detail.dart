import 'package:flutter/material.dart';
import '../../Mananger/lophoc_mananger.dart';
import '../../Mananger/buoihoc_mananger.dart';
import '../Models/buoihoc_model.dart';
import '../Models/lophoc_model.dart';
import '../Models/lophocphan_model.dart';
import 'lophoc_detail.dart';

class LopHocPhanDetail extends StatefulWidget {
  final LopHocPhan lopHocPhan;
  final List<LopHoc> danhSachLopHoc;

  LopHocPhanDetail({required this.lopHocPhan, required this.danhSachLopHoc});

  @override
  _LopHocPhanDetailState createState() => _LopHocPhanDetailState();
}

class _LopHocPhanDetailState extends State<LopHocPhanDetail> {
  final LopHocManager lopHocManager = LopHocManager();
  final BuoiHocManager buoiHocManager = BuoiHocManager();

  void _showEditDialog(BuildContext context, LopHoc lopHoc) {
    TextEditingController tenLopController = TextEditingController(text: lopHoc.tenLop);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sửa thông tin lớp học'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tenLopController,
                decoration: const InputDecoration(labelText: 'Tên Lớp Học'),
              ),
            ],
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                // Xử lý sửa thông tin lớp học
                String newTenLop = tenLopController.text.trim();
                if (newTenLop.isNotEmpty) {
                  lopHoc.tenLop = newTenLop;
                  lopHocManager.updateLopHoc(lopHoc);
                  // Cập nhật danh sách lớp học sau khi chỉnh sửa
                  setState(() {
                    widget.danhSachLopHoc[widget.danhSachLopHoc.indexOf(lopHoc)] = lopHoc;
                  });
                  Navigator.of(context).pop(); // Đóng hộp thoại
                } else {
                  // Hiển thị thông báo hoặc cảnh báo nếu tên lớp rỗng
                  // Ví dụ: ScaffoldMessenger.of(context).showSnackBar(...)
                }
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }


  void _confirmDelete(BuildContext context, LopHoc lopHoc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa lớp học'),
          content: Text('Bạn có chắc chắn muốn xóa lớp học ${lopHoc.tenLop}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                // Xử lý xóa lớp học
                lopHocManager.deleteLopHoc(lopHoc.id);
                // Cập nhật danh sách lớp học sau khi xóa
                setState(() {
                  widget.danhSachLopHoc.remove(lopHoc);
                });
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  void _addLopHoc() {
    // Hiển thị hộp thoại thêm lớp học
    _showAddLopHocDialog();
  }

  void _showAddLopHocDialog() {
    TextEditingController tenLopController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thêm Nhóm Học'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tenLopController,
                decoration: const InputDecoration(labelText: 'Tên Nhóm'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: const Text('Hủy bỏ'),
            ),
            TextButton(
              onPressed: () async {
                String tenLop = tenLopController.text.trim();

                if (tenLop.isNotEmpty) {
                  // Tạo một đối tượng LopHoc mới
                  LopHoc newLopHoc = LopHoc(
                    id: UniqueKey().toString(),
                    tenLop: tenLop,
                    lophocphanId: widget.lopHocPhan.id,
                  );

                  // Thực hiện thêm lớp học vào cơ sở dữ liệu
                  await lopHocManager.insertLopHoc(newLopHoc, widget.lopHocPhan.id);

                  // Đóng hộp thoại
                  Navigator.of(context).pop();

                  // Cập nhật danh sách lớp học sau khi thêm
                  setState(() {
                    widget.danhSachLopHoc.add(newLopHoc);
                  });
                }
              },
              child: Text('Thêm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: const Text('Chi Tiết Lớp Học Phần', style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(3),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.lightBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: Colors.white, // Màu sắc của viền
                    width: 2.0, // Độ rộng của viền
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child:ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: const Icon(
                    Icons.groups,
                    size: 40,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Các Nhóm Của Học Phần: ${widget.lopHocPhan.tenLopHocPhan}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.danhSachLopHoc.length,
              itemBuilder: (context, index) {
                final lopHoc = widget.danhSachLopHoc[index];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: InkWell(
                    onTap: () async {
                      List<BuoiHoc> danhSachBuoiHoc =
                      await buoiHocManager.getBuoiHocForLopHoc(lopHoc.id);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LopHocDeTail(
                            lopHoc: lopHoc,
                            danhSachBuoiHoc: danhSachBuoiHoc,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        child: ListTile(
                          leading: const Icon(Icons.groups, color: Colors.blue),
                          title: Text(lopHoc.tenLop, style: const TextStyle(fontWeight: FontWeight.bold)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _showEditDialog(context, lopHoc),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _confirmDelete(context, lopHoc),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addLopHoc,
        tooltip: 'Thêm Nhóm Học',
        backgroundColor: Colors.transparent, // Đặt màu nền là trong suốt
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.blue], // Chọn màu chuyển
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Icon(Icons.add, color: Colors.white),
          ),
        ),
      )
    );
  }
}
