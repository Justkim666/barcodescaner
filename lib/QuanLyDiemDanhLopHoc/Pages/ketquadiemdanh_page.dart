import 'package:barcodescanner/Mananger/sinhvien_manager.dart';
import 'package:barcodescanner/QuanLyDiemDanhLopHoc/Models/buoihoc_model.dart';
import 'package:barcodescanner/QuanLyDiemDanhLopHoc/Pages/buoihoc_detail.dart';
import 'package:barcodescanner/QuanLyDiemDanhLopHoc/Tab/tab_page_bh.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_sdk/dynamsoft_barcode.dart';

import '../Models/sinhvien_model.dart';

class KetQuaDiemDanhPage extends StatefulWidget {
  KetQuaDiemDanhPage({super.key, required this.barcodeResults, required this.buoiHoc});

  final List<BarcodeResult> barcodeResults;
  BuoiHoc buoiHoc;

  @override
  State<KetQuaDiemDanhPage> createState() => _KetQuaDiemDanhPageState();
}

class _KetQuaDiemDanhPageState extends State<KetQuaDiemDanhPage> {
  SinhVienManager sinhVienManager = SinhVienManager();
  List<SinhVien> dssv = [];
  @override
  Widget build(BuildContext context) {
    var count = Container(
      padding: const EdgeInsets.only(left: 16, top: 14, bottom: 15),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          const Text('Số Kết Quả: ', style: TextStyle(color: Colors.grey)),
          Text('${widget.barcodeResults.length}',
              style: const TextStyle(color: Colors.grey, fontSize: 14))
        ],
      ),
    );
    final resultList = Expanded(
        child: ListView.builder(
            itemCount: widget.barcodeResults.length,
            itemBuilder: (context, index) {
              return MyCustomWidget(
                barcodeResults: widget.barcodeResults,
                buoiHoc: widget.buoiHoc,
                index: index,
                result: widget.barcodeResults[index],
              );
            }));

    // final button = Row(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     Container(
    //         padding: const EdgeInsets.all(16),
    //         child: MaterialButton(
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(16.0),
    //           ),
    //           minWidth: 100,
    //           height: 45,
    //           onPressed: (){
    //             Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const CameraPage()));
    //             // final SharedPreferences prefs =
    //             //     await SharedPreferences.getInstance();
    //             // var results = prefs.getStringList('barcode_data');
    //             // List<String> jsonList = <String>[];
    //             // for (BarcodeResult result in widget.barcodeResults) {
    //             //   jsonList.add(jsonEncode(result.toJson()));
    //             // }
    //             // if (results == null) {
    //             //   prefs.setStringList('barcode_data', jsonList);
    //             // } else {
    //             //   results.addAll(jsonList);
    //             //   prefs.setStringList('barcode_data', results);
    //             // }
    //           },
    //           color: Colors.blue,
    //           child: const Text(
    //             'Continue Scan',
    //             style: TextStyle(color: Colors.white, fontSize: 18),
    //           ),
    //         ))
    //   ],
    // );

    return WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
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
            title: const Text('Kết Quả', style: TextStyle(color: Colors.white),),
          ),
          body: Column(
            children: [
              count,
              resultList,
              // button
            ],
          ),
        ));
  }
}

class MyCustomWidget extends StatefulWidget {
  BuoiHoc buoiHoc;
  final BarcodeResult result;
  final int index;
  final List<BarcodeResult> barcodeResults;

  MyCustomWidget({
    super.key,
    required this.index,
    required this.result,
    required this.buoiHoc,
    required this.barcodeResults
  });

  @override
  State<MyCustomWidget> createState() => _MyCustomWidgetState();
}

class _MyCustomWidgetState extends State<MyCustomWidget>{
  SinhVienManager sinhVienManager = SinhVienManager();
  List<SinhVien> dssv = [];
  bool isCopied = false;
  bool attendance = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: 70,
            margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 13, bottom: 14, left: 10, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.lightBlue,
                      radius: 12,
                      child: Text(
                        '${widget.index + 1}',
                        style: const TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Text(
                      widget.result.text,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0), // Điều chỉnh độ cong của góc
              ),
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24), // Adjust padding/ Set the background color here
            ),
            onPressed: () async{
              dssv = await sinhVienManager.getAllSinhVien(widget.buoiHoc.id);
              for(var ketqua in widget.barcodeResults){
                print('Day la ket qua');
                print(ketqua.text);
                print('Lap trong chieu dai cua danh sach sinh vien la: ${dssv.length}');
                for(var sinhVien in dssv){
                  print('Ma sinh vien duoc lay ra');
                  print(sinhVien.maSinhVien);
                  if(sinhVien.maSinhVien == ketqua.text){
                    print('Clm tìm thấy rồi nè !');
                    if(sinhVien.diemDanh == false){
                      final snackBar = SnackBar(
                        content: Text('Điểm danh sinh viên ${sinhVien.ten} - ${sinhVien.maSinhVien} thành công!'),
                        action: SnackBarAction(
                          label: '',
                          onPressed: () {
                            // Some code to undo the change.
                          },
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      print('Cập Nhật lại................');
                      sinhVien.diemDanh = true;
                      await sinhVienManager.updateSinhVien(sinhVien);
                      print('${sinhVien.ten}: ${sinhVien.diemDanh}');
                      attendance = true;
                      break;
                    } else {
                      final snackBar = SnackBar(
                        content: Text('Sinh viên ${sinhVien.ten} - ${sinhVien.maSinhVien} đã được điểm danh!'),
                        action: SnackBarAction(
                          label: '',
                          onPressed: () {
                            // Some code to undo the change.
                          },
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      attendance = true;
                      break;
                    }
                  }
                }
              }
              if(dssv.isEmpty){
                final snackBar = SnackBar(
                  content: const Text('Vui lòng thêm danh sách sinh viên trước khi điểm danh'),
                  action: SnackBarAction(
                    label: '',
                    onPressed: () {
                      // Some code to undo the change.
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              if(attendance == false && dssv.isNotEmpty){
                final snackBar = SnackBar(
                  content: const Text('Sinh viên không có trong lớp học!'),
                  action: SnackBarAction(
                    label: '',
                    onPressed: () {
                      // Some code to undo the change.
                    },
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              setState(() {});
              dssv = await sinhVienManager.getAllSinhVien(widget.buoiHoc.id);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BuoiHocDetail(buoiHoc: widget.buoiHoc, danhSachSinhVien: dssv)
                  )
              );
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check, color: Colors.white,),
                SizedBox(width: 10,),
                Text('Xác Nhận Đã Điểm Danh', style: TextStyle(color: Colors.white),),
              ],
            ),
          ),
          const SizedBox(height: 25,)
        ],
      ),
    );
  }
}

