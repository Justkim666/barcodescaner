import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_sdk/dynamsoft_barcode.dart';
import '../../global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  bool _isLoaded = false;
  final List<BarcodeResult> _barcodeHistory =
      List<BarcodeResult>.empty(growable: true);
  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = prefs.getStringList('barcode_data');
    if (data != null) {
      _barcodeHistory.clear();
      for (String json in data) {
        BarcodeResult barcodeResult = BarcodeResult.fromJson(jsonDecode(json));
        _barcodeHistory.add(barcodeResult);
      }
    }
    setState(() {
      _isLoaded = true;
    });
  }

  Future<void> _showClearHistoryConfirmationDialog() async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Xác Nhận Xóa"),
          content: const Text("Bạn Muốn Xóa Hết Các Kết Quả Quét Thẻ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: () async {
                await _clearHistory();
                Navigator.of(context).pop();
              },
              child: const Text("Đồng Ý"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _clearHistory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('barcode_data');
    setState(() {
      _barcodeHistory.clear();
    });
  }
  @override
  Widget build(BuildContext context) {
    var listView = Expanded(
        child: ListView.builder(
            itemCount: _barcodeHistory.length,
            itemBuilder: (context, index) {
              return MyCustomWidget(
                  result: _barcodeHistory[index],
                  index: index + 1,
                  cbDeleted: () async {
                    _barcodeHistory.removeAt(index);
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    List<String> data =
                        prefs.getStringList('barcode_data') as List<String>;
                    data.removeAt(index);
                    prefs.setStringList('barcode_data', data);
                    setState(() {});
                  },
                  cbOpenResultPage: () {}
              );
            }
            )
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('History Storage',
            style: TextStyle(
              fontSize: 22,
              color: colorTitle,
            )),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 30),
              child: IconButton(
                onPressed: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.remove('barcode_data');
                  setState(() async {
                    await _showClearHistoryConfirmationDialog();
                  });
                },
                icon: Image.asset(
                  "images/icon-delete.png",
                  width: 26,
                  height: 26,
                  fit: BoxFit.cover,
                ),
              ))
        ],
        iconTheme: const IconThemeData(
          color: Colors.white
        ),
      ),
      body: _isLoaded
          ? Column(
              children: [listView],
            )
          : const Center(
              child: Center(child: CircularProgressIndicator()),
            ),
      backgroundColor: Colors.white,
    );
  }
}

class MyCustomWidget extends StatelessWidget {
  final BarcodeResult result;
  final int index;
  final Function cbDeleted;
  final Function cbOpenResultPage;

  const MyCustomWidget({
    super.key,
    required this.result,
    required this.index,
    required this.cbDeleted,
    required this.cbOpenResultPage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white, // Màu nền trắng
          borderRadius: BorderRadius.circular(10.0), // Đường viền cong
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.5), // Màu xanh dương nhạt cho đổ bóng
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 18, bottom: 16, left: 15),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.lightBlue,
                        radius: 12,
                        child: Text(
                          '$index',
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                      const SizedBox(width: 15,),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 105,
                        child: Text(
                          result.text,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                    ],
                  ),

                ],
              ),
              Expanded(child: Container()),
              Padding(
                padding: const EdgeInsets.only(right: 0),
                child: IconButton(
                  icon: const Icon(Icons.more_vert),
                  color: Colors.black, // Chữ màu đen
                  onPressed: () async {
                    final RenderBox button =
                    context.findRenderObject() as RenderBox;

                    final RelativeRect position = RelativeRect.fromLTRB(
                      100,
                      button.localToGlobal(Offset.zero).dy,
                      40,
                      0,
                    );

                    final selected = await showMenu(
                      context: context,
                      position: position,
                      color: Colors.white, // Màu nền đen cho menu
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0), // Đường viền cong cho menu
                      ),
                      items: [
                        const PopupMenuItem<int>(
                          value: 0,
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        const PopupMenuItem<int>(
                          value: 1,
                          child: Text(
                            'Copy',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    );

                    if (selected != null) {
                      if (selected == 0) {
                        // delete
                        cbDeleted();
                      } else if (selected == 1) {
                        // copy
                        Clipboard.setData(ClipboardData(
                            text: 'Format: ${result.format}, Text: ${result.text}'));
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
