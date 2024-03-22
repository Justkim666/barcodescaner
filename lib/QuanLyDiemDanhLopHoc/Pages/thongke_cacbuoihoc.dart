import 'package:barcodescanner/Mananger/sinhvien_manager.dart';
import 'package:flutter/material.dart';

import '../Models/buoihoc_model.dart';
import '../Models/sinhvien_model.dart';

class ThongKeCacBuoiHoc extends StatefulWidget {
  ThongKeCacBuoiHoc({super.key, required this.buoiHoc});
  BuoiHoc buoiHoc;

  @override
  State<ThongKeCacBuoiHoc> createState() => _ThongKeCacBuoiHocState();
}

class _ThongKeCacBuoiHocState extends State<ThongKeCacBuoiHoc> {
  List<SinhVien> dssv = [];
  List<SinhVien> danhSachSinhVienVang = [];
  List<SinhVien> danhSachSinhVienCoMat = [];
  bool point = false;
  @override
  SinhVienManager sinhVienManager = SinhVienManager();
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
        title: const Text('Thống Kê Buổi Học', style: TextStyle(color: Colors.white),),
      ),
        body: Column(
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
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: const Icon(
                      Icons.bar_chart,
                      size: 40,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Thống Kê Buổi Học: ${widget.buoiHoc.tenBuoiHoc}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Divider(), // Phân cách giữa các danh sách
                    Center(
                        child: Card(
                          elevation: 4, // Độ nổi của card
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Đặt bo góc cho card
                            side: BorderSide(color: Colors.blue, width: 2), // Đặt viền cho card
                          ),
                          color: Colors.lightBlueAccent,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Số Sinh Viên Có Mặt: ${danhSachSinhVienCoMat.length}',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        )
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(), // Ngăn cuộn của ListView
                      itemCount: danhSachSinhVienCoMat.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: ListTile(
                            leading: const Icon(Icons.assignment_ind, color: Colors.blue,),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(danhSachSinhVienCoMat[index].ten, style: const TextStyle(fontSize: 16),),
                                Text(danhSachSinhVienCoMat[index].maSinhVien, style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const Divider(), // Phân cách giữa các danh sách
                    Center(
                        child: Card(
                          elevation: 4, // Độ nổi của card
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10), // Đặt bo góc cho card
                            side: const BorderSide(color: Colors.blue, width: 2), // Đặt viền cho card
                          ),
                          color: Colors.lightBlueAccent,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Số Sinh Viên Vắng Mặt: ${danhSachSinhVienVang.length}',
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        )
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(), // Ngăn cuộn của ListView
                      itemCount: danhSachSinhVienVang.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: ListTile(
                            leading: const Icon(Icons.assignment_ind, color: Colors.blue,),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(danhSachSinhVienVang[index].ten, style: const TextStyle(fontSize: 16),),
                                Text(danhSachSinhVienVang[index].maSinhVien, style: const TextStyle(fontSize: 14)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          dssv = await sinhVienManager.getAllSinhVien(widget.buoiHoc.id);
          if(point == false){
            for(var sv in dssv){
              if(sv.diemDanh == true){
                danhSachSinhVienCoMat.add(sv);
              } else if(sv.diemDanh == false) {
                danhSachSinhVienVang.add(sv);
              }
            }
          }
          point = true;
          setState(() {});
        },
        tooltip: 'Thống Kê',
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
            child: Icon(Icons.bar_chart, color: Colors.white),
          ),
        ),
      )
    );
  }
}
