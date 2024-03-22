import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../Models/lichlophoc_model.dart';

class LichDayPage extends StatefulWidget {
  @override
  _LichDayPageState createState() => _LichDayPageState();
}

class _LichDayPageState extends State<LichDayPage> {
  List<String> ngayTrongTuan = ['Thứ 2', 'Thứ 3', 'Thứ 4', 'Thứ 5', 'Thứ 6', 'Thứ 7'];

  List<LichDay> lichDayList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
    for (var ngay in ngayTrongTuan) {
      lichDayList.add(
        LichDay(
          ngayHoc: ngay,
          buoiSang: [],
          buoiChieu: [],
        ),
      );
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final lichDayListJson = lichDayList.map((lichDay) => lichDay.toJson()).toList();

    // Chuyển đổi List<Map<String, dynamic>> thành List<String>
    final lichDayListString = lichDayListJson.map((json) => jsonEncode(json)).toList();

    await prefs.setStringList('lichDayList', lichDayListString);
  }


  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final lichDayListJson = prefs.getStringList('lichDayList');
    if (lichDayListJson != null) {
      setState(() {
        lichDayList = lichDayListJson.map((json) => LichDay.fromJson(jsonDecode(json))).toList();
      });
    }
  }


  void _showDialogThemLopHoc(LichDay lichDay, String buoi) {
    String tenLop = '';
    String monHoc = '';
    String phongHoc = '';
    String gioBatDau = '';
    String gioKetThuc = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: const Text('Thêm Lớp Học'),
            content: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    tenLop = value;
                  },
                  decoration: const InputDecoration(labelText: 'Tên Lớp'),
                ),
                TextField(
                  onChanged: (value) {
                    monHoc = value;
                  },
                  decoration: const InputDecoration(labelText: 'Môn Học'),
                ),
                TextField(
                  onChanged: (value) {
                    phongHoc = value;
                  },
                  decoration: const InputDecoration(labelText: 'Phòng Học'),
                ),
                TextField(
                  onChanged: (value) {
                    gioBatDau = value;
                  },
                  decoration: const InputDecoration(labelText: 'Giờ Bắt Đầu'),
                ),
                TextField(
                  onChanged: (value) {
                    gioKetThuc = value;
                  },
                  decoration: const InputDecoration(labelText: 'Giờ Kết Thúc'),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (buoi == 'sang') {
                      lichDay.buoiSang.add(LichLopHoc(
                        tenLop: tenLop,
                        monHoc: monHoc,
                        phongHoc: phongHoc,
                        gioBatDau: gioBatDau,
                        gioKetThuc: gioKetThuc,
                      ));
                    } else {
                      lichDay.buoiChieu.add(LichLopHoc(
                        tenLop: tenLop,
                        monHoc: monHoc,
                        phongHoc: phongHoc,
                        gioBatDau: gioBatDau,
                        gioKetThuc: gioKetThuc,
                      ));
                    }
                  });
                  Navigator.of(context).pop();
                  _saveData();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, String lopHocName, Function onDelete) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: Text('Bạn có chắc chắn muốn xóa lớp học $lopHocName không?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                onDelete();
                Navigator.of(context).pop();
                _saveData();
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  void _showDialogChinhSuaLopHoc(LichLopHoc lopHoc, LichDay lichDay, String buoiId) {
    TextEditingController tenLopController = TextEditingController(text: lopHoc.tenLop);
    TextEditingController monHocController = TextEditingController(text: lopHoc.monHoc);
    TextEditingController phongHocController = TextEditingController(text: lopHoc.phongHoc);
    TextEditingController gioBatDauController = TextEditingController(text: lopHoc.gioBatDau);
    TextEditingController gioKetThucController = TextEditingController(text: lopHoc.gioKetThuc);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: const Text('Chỉnh Sửa Lớp Học'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField('Tên Lớp', tenLopController),
                _buildTextField('Môn Học', monHocController),
                _buildTextField('Phòng Học', phongHocController),
                _buildTextField('Giờ Bắt Đầu', gioBatDauController),
                _buildTextField('Giờ Kết Thúc', gioKetThucController),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Hủy'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Cập nhật thông tin lớp học và cập nhật UI
                  setState(() {
                    lopHoc.tenLop = tenLopController.text;
                    lopHoc.monHoc = monHocController.text;
                    lopHoc.phongHoc = phongHocController.text;
                    lopHoc.gioBatDau = gioBatDauController.text;
                    lopHoc.gioKetThuc = gioKetThucController.text;
                  });

                  Navigator.of(context).pop();
                },
                child: const Text('Lưu'),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuoiHoc(List<LichLopHoc> buoiHoc, String buoi, LichDay lichDay, String buoiId) {
    return Column(
      children: [
        ListTile(
          title: Text(buoi),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.blue,),
                onPressed: () {
                  _showDialogThemLopHoc(lichDay, buoiId);
                },
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: buoiHoc.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.all(8.0),
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              color: Colors.white,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                leading: Text(
                  '${index + 1}',
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
                title: Text(
                  '${buoiHoc[index].monHoc} - Phòng: ${buoiHoc[index].phongHoc}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                ),
                subtitle: Text(
                  'Giờ: ${buoiHoc[index].gioBatDau}h - ${buoiHoc[index].gioKetThuc}h',
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        setState(() {
                          _confirmDelete(
                            context,
                            buoiHoc[index].tenLop,
                                () {
                              setState(() {
                                buoiHoc.removeAt(index);
                              });
                              _saveData();
                            },
                          );
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        if (buoiHoc.isNotEmpty) {
                          _showDialogChinhSuaLopHoc(buoiHoc[0], lichDay, buoiId);
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Lịch Dạy',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.0, // Adjust font size
          ),
        ),
        backgroundColor: Colors.blue,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.indigo], // Adjust gradient colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: lichDayList.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(12.0),
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: ExpansionTile(
              title: ListTile(
                contentPadding: const EdgeInsets.all(0),
                leading: const Icon(
                  Icons.calendar_today_sharp,
                  color: Colors.blue,
                ),
                title: Text(
                  lichDayList[index].ngayHoc,
                  style: const TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: _buildBuoiHoc(
                    lichDayList[index].buoiSang,
                    'Buổi Sáng',
                    lichDayList[index],
                    'sang',
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: _buildBuoiHoc(
                    lichDayList[index].buoiChieu,
                    'Buổi Trưa',
                    lichDayList[index],
                    'trua',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
