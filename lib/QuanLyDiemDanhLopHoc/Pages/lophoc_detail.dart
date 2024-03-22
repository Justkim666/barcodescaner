import 'package:barcodescanner/QuanLyDiemDanhLopHoc/Tab/tab_page_bh.dart';
import 'package:flutter/material.dart';
import '../../Mananger/lophoc_mananger.dart';
import '../../Mananger/buoihoc_mananger.dart';
import '../../Mananger/sinhvien_manager.dart';
import '../Models/buoihoc_model.dart';
import '../Models/lophoc_model.dart';
import '../Models/sinhvien_model.dart';
import 'buoihoc_detail.dart';

class LopHocDeTail extends StatefulWidget {
  final LopHoc lopHoc;
  final List<BuoiHoc> danhSachBuoiHoc;

  LopHocDeTail({
    required this.lopHoc,
    required this.danhSachBuoiHoc,
  });

  @override
  _LopHocDeTailState createState() => _LopHocDeTailState();
}

class _LopHocDeTailState extends State<LopHocDeTail> {
  final BuoiHocManager buoiHocManager = BuoiHocManager();
  final SinhVienManager sinhVienManager = SinhVienManager();

  void _showEditBuoiHocDialog(BuildContext context, BuoiHoc buoiHoc) {
    TextEditingController tenBuoiHocController = TextEditingController(text: buoiHoc.tenBuoiHoc);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sửa thông tin buổi học'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tenBuoiHocController,
                decoration: InputDecoration(labelText: 'Tên Buổi Học'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // String newTenLop = tenLopController.text.trim();
                // if (newTenLop.isNotEmpty) {
                //   lopHoc.tenLop = newTenLop;
                //   lopHocManager.updateLopHoc(lopHoc);
                //   // Cập nhật danh sách lớp học sau khi chỉnh sửa
                //   setState(() {
                //     widget.danhSachLopHoc[widget.danhSachLopHoc.indexOf(lopHoc)] = lopHoc;
                //   });
                // Tạo một bản sao của đối tượng BuoiHoc với tên buổi học được cập nhật
                String newTenBuoi = tenBuoiHocController.text.trim();
                if(newTenBuoi.isNotEmpty){
                  buoiHoc.tenBuoiHoc = newTenBuoi;
                  buoiHocManager.updateBuoiHoc(buoiHoc);
                  setState(() {
                    widget.danhSachBuoiHoc[widget.danhSachBuoiHoc.indexOf(buoiHoc)] = buoiHoc;
                  });
                }
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text('Đồng ý'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text('Hủy bỏ'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteBuoiHoc(BuildContext context, BuoiHoc buoiHoc) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa buổi học'),
          content: Text('Bạn có chắc chắn muốn xóa buổi ${buoiHoc.tenBuoiHoc}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                // Xử lý xóa buổi học
                buoiHocManager.deleteBuoiHoc(buoiHoc.id);
                // Cập nhật danh sách buổi học sau khi xóa
                setState(() {
                  widget.danhSachBuoiHoc.remove(buoiHoc);
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

  void _addBuoiHoc() {
    // Hiển thị hộp thoại thêm buổi học
    _showAddBuoiHocDialog();
  }

  void _showAddBuoiHocDialog() {
    TextEditingController tenBuoiHocController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thêm Buổi Học'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tenBuoiHocController,
                decoration: InputDecoration(labelText: 'Tên Buổi Học'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text('Hủy bỏ'),
            ),
            TextButton(
              onPressed: () async {
                String tenBuoiHoc = tenBuoiHocController.text.trim();

                if (tenBuoiHoc.isNotEmpty) {
                  // Tạo một đối tượng BuoiHoc mới
                  BuoiHoc newBuoiHoc = BuoiHoc(
                    id: UniqueKey().toString(),
                    tenBuoiHoc: tenBuoiHoc,
                    lophocId: widget.lopHoc.id,
                  );

                  // Thực hiện thêm buổi học vào cơ sở dữ liệu
                  await buoiHocManager.insertBuoiHoc(newBuoiHoc, widget.lopHoc.id);

                  // Đóng hộp thoại
                  Navigator.of(context).pop();

                  // Cập nhật danh sách buổi học sau khi thêm
                  setState(() {
                    widget.danhSachBuoiHoc.add(newBuoiHoc);
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
        title: const Text('Chi Tiết Lớp Học', style: TextStyle(color: Colors.white),),
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
                    Icons.assignment,
                    size: 40,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Các Buổi Của Học Phần: ${widget.lopHoc.tenLop}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.danhSachBuoiHoc.length,
              itemBuilder: (context, index) {
                BuoiHoc buoiHoc = widget.danhSachBuoiHoc[index];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: InkWell(
                    onTap: () async {
                      List<SinhVien> danhSachSinhVien =
                      await sinhVienManager.getAllSinhVien(buoiHoc.id);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => TabPageBuoiHoc(
                      //       buoiHoc: buoiHoc,
                      //       danhSachSinhVien: danhSachSinhVien,
                      //     ),
                      //   ),
                      // );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BuoiHocDetail(buoiHoc: buoiHoc, danhSachSinhVien: danhSachSinhVien)
                        )
                      );
                    },
                    child: Card(
                      elevation: 5,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        child: ListTile(
                          leading: const Icon(Icons.assignment, color: Colors.blue),
                          title: Text(buoiHoc.tenBuoiHoc, style: const TextStyle(fontWeight: FontWeight.bold)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _showEditBuoiHocDialog(context, buoiHoc),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _confirmDeleteBuoiHoc(context, buoiHoc),

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
        onPressed: _addBuoiHoc,
        tooltip: 'Thêm Lớp Học',
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
