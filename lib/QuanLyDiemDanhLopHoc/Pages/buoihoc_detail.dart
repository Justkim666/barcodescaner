import 'dart:io';
import 'dart:math';
import 'package:barcodescanner/Mananger/buoihoc_mananger.dart';
import 'package:barcodescanner/Mananger/sinhvien_manager.dart';
import 'package:barcodescanner/QuanLyDiemDanhLopHoc/Models/user/user_data.dart';
import 'package:barcodescanner/QuanLyDiemDanhLopHoc/Pages/camera_diemdanh.dart';
import 'package:barcodescanner/QuanLyDiemDanhLopHoc/Pages/camera_page.dart';
import 'package:barcodescanner/QuanLyDiemDanhLopHoc/Pages/thongke_cacbuoihoc.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../Models/buoihoc_model.dart';
import '../Models/sinhvien_model.dart';
import '../Models/user/user_model.dart';

class BuoiHocDetail extends StatefulWidget {
  final BuoiHoc buoiHoc;
  List<SinhVien> danhSachSinhVien;

  BuoiHocDetail(
      {super.key, required this.buoiHoc, required this.danhSachSinhVien});

  @override
  _BuoiHocDetailState createState() => _BuoiHocDetailState();
}

class _BuoiHocDetailState extends State<BuoiHocDetail> {
  List<SinhVien> dssv = [];
  final BuoiHocManager buoiHocManager = BuoiHocManager();
  final SinhVienManager sinhVienManager = SinhVienManager();
  User user = UserData.myUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dssv = widget.danhSachSinhVien;
  }

  Future<void> exportToExcel(List<SinhVien> students, String fileName) async {
    // Create a new Excel workbook
    var excel = Excel.createExcel();
    // Add a sheet to the workbook
    var sheet = excel['Sheet1'];

    // Add headers to the sheet
    sheet.appendRow([const TextCellValue('Mã Sinh Viên'), const TextCellValue('Tên Sinh Viên'), const TextCellValue('Điểm Danh')]);

    // Add student data to the sheet
    students.forEach((student) {
      sheet.appendRow([
        TextCellValue(student.maSinhVien),
        TextCellValue(student.ten),
        TextCellValue(student.diemDanh ? 'Có' : 'Không')
      ]);
    });
    // Add the row "Giảng Viên: Trần Hoàng Kim" to the last row
    sheet.appendRow([const TextCellValue('')]);
    sheet.appendRow([TextCellValue('Giảng Viên: ${user.name}')]);
    // Save the workbook to a file
    // final directory = await getApplicationDocumentsDirectory();
    var filePath = 'storage/emulated/0/Download/$fileName.xlsx';
    print('$fileName.xlsx');
    var bytes = excel.encode();
    await File(filePath).writeAsBytes(bytes!);
    print('Dang mo tai lieu....');
    try {
      await OpenFile.open(filePath);
      print('Mo thanh cong');
    } catch (error) {
      print('Failed to open file: $error');
    }


    // Show a SnackBar message when completed
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('File đã được lưu tại: $filePath'),
        action: SnackBarAction(
          label: 'Mở',
          onPressed: () {
            OpenFile.open(filePath);
            print(filePath);
          },
        ),
      ),
    );
  }
  // /storage/emulated/0/Download

  Future<void> _showSaveFileDialog(List<SinhVien> students) async {
    TextEditingController fileNameController = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nhập tên file Excel'),
          content: TextField(
            controller: fileNameController,
            decoration: const InputDecoration(
              hintText: 'Tên file',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Lưu'),
              onPressed: () {
                String fileName = fileNameController.text.isNotEmpty
                    ? fileNameController.text
                    : 'danh_sach_sinh_vien';
                exportToExcel(students, fileName);
                Navigator.of(context).pop();
              },
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              onPressed: ()async {
                var students = await sinhVienManager.getAllSinhVien(widget.buoiHoc.id);
                _showSaveFileDialog(students);
              },
              icon: const Icon(Icons.download, color: Colors.white,)
          )
        ],
        iconTheme: const IconThemeData(color: Colors.white),
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
        title: const Text(
          'Chi Tiết Buổi Học',
          style: TextStyle(color: Colors.white),
        ),
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
                  // border: Border.all(
                  //   color: Colors.white, // Màu sắc của viền
                  //   width: 2.0, // Độ rộng của viền
                  // ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: const Icon(
                    Icons.assignment,
                    size: 40,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Danh Sách Sinh Viên Điểm Danh ${widget.buoiHoc.tenBuoiHoc}',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dssv.length,
              itemBuilder: (context, index) {
                final sinhVien = dssv[index];
                return Card(
                  elevation: 5,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: const Icon(
                      Icons.assignment_ind,
                      color: Colors.blue,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sinhVien.ten,
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(sinhVien.maSinhVien,
                            style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                    trailing: IconButton(
                      icon: dssv[index].diemDanh == false
                          ? const Icon(
                              Icons.check_box_outline_blank,
                              color: Colors.blue,
                            )
                          : const Icon(
                              Icons.check_box_outlined,
                              color: Colors.blue,
                            ),
                      onPressed: () {
                        _showDeleteConfirmationDialog(sinhVien);
                      }, // file de dau v
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Điều chỉnh độ cong của góc
                    ),
                    elevation: 5,
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.fromLTRB(25, 15, 25, 15)),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              // const CameraPage()));
                              CameraPageDiemDanh(buoiHoc: widget.buoiHoc)));
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.qr_code_scanner,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text('Bắt Đầu Điểm Danh', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          )
        ],
      ),
      //   floatingActionButton:FloatingActionButton(
      //     backgroundColor: Colors.transparent,
      //     onPressed: () async {
      //       FilePickerResult? result = await FilePicker.platform.pickFiles(
      //         type: FileType.custom,
      //         allowedExtensions: ['xlsx', 'xls'],
      //       );
      //       setState(() {});
      //       if (result != null) {
      //         File excelFile = File(result.files.single.path!);
      //         String buoihocId = widget.buoiHoc.id;
      //         await sinhVienManager.addSinhVienFromExcel(excelFile, buoihocId);
      //         // Perform asynchronous work outside of setState
      //         List<SinhVien> newDanhSachSinhVien = await sinhVienManager.getAllSinhVien(buoihocId); // khuc nay ne
      //         // Update the widget state using setState
      //         print('Đây là dòng trên setState() $newDanhSachSinhVien');
      //         setState(() {
      //           dssv = newDanhSachSinhVien;
      // // dssv = [SinhVien(maSinhVien: "maSinhVien", ten: "ten", buoihocId: "1"),SinhVien(maSinhVien: "maSinhVien", ten: "ten", buoihocId: "1"),SinhVien(maSinhVien: "maSinhVien", ten: "ten", buoihocId: "1")];
      //         });
      //       }
      //     },
      //     child: Container(
      //       decoration: const BoxDecoration(
      //         shape: BoxShape.circle,
      //         gradient: LinearGradient(
      //           colors: [Colors.blue, Colors.blue], // Chọn màu chuyển
      //         ),
      //       ),
      //       child: const Padding(
      //         padding: EdgeInsets.all(16.0),
      //         child: Icon(Icons.add, color: Colors.white),
      //       ),
      //     ),
      //   )
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        overlayColor: Colors.black,
        childMargin: const EdgeInsets.all(15),
        overlayOpacity: 0.5,
        children: [
          SpeedDialChild(
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.person,
              color: Colors.blue,
            ),
            label: 'Thêm Danh Sách Sinh Viên',
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['xlsx', 'csv'],
              );
              print(result.toString());
              setState(() {});
              if (result != null) {
                File excelFile = File(result.files.single.path!);
                String buoihocId = widget.buoiHoc.id;
                await sinhVienManager.addSinhVienFromExcel(
                    excelFile, buoihocId);
                // Perform asynchronous work outside of setState
                List<SinhVien> newDanhSachSinhVien = await sinhVienManager
                    .getAllSinhVien(buoihocId); // khuc nay ne
                // Update the widget state using setState
                print('Đây là dòng trên setState() $newDanhSachSinhVien');
                setState(() {
                  dssv = newDanhSachSinhVien;
                  // dssv = [SinhVien(maSinhVien: "maSinhVien", ten: "ten", buoihocId: "1"),SinhVien(maSinhVien: "maSinhVien", ten: "ten", buoihocId: "1"),SinhVien(maSinhVien: "maSinhVien", ten: "ten", buoihocId: "1")];
                });
              }
              final snackBar = SnackBar(
                content: const Text('Thêm danh sách sinh viên thành công!'),
                action: SnackBarAction(
                  label: '',
                  onPressed: () {
                    // Some code to undo the change.
                  },
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
          SpeedDialChild(
            backgroundColor: Colors.white,
            child: const Icon(
              Icons.bar_chart,
              color: Colors.blue,
            ),
            label: 'Thống Kê',
            onTap: () {
              // Handle option 2
              Navigator.push(
                context, 
                MaterialPageRoute(
                    builder: (context) => ThongKeCacBuoiHoc(buoiHoc: widget.buoiHoc)
                )
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(SinhVien sinhVien) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bạn có chắc muốn xóa sinh viên ${sinhVien.ten}?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Xóa'),
              onPressed: () async {
                // Call the delete method from SinhVienManager
                await sinhVienManager.deleteSinhVien(sinhVien.maSinhVien);

                // Update the widget state using setState
                setState(() {
                  // Remove the deleted SinhVien from the danhSachSinhVien list
                  widget.danhSachSinhVien.remove(sinhVien);
                });

                // Close the confirmation dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
