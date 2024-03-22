import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_sdk/dynamsoft_barcode.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key, required this.barcodeResults});

  final List<BarcodeResult> barcodeResults;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    var count = Container(
      padding: const EdgeInsets.only(left: 16, top: 14, bottom: 15),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          const Text('Total: ', style: TextStyle(color: Colors.grey)),
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
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            backgroundColor: Colors.blue,
            iconTheme: const IconThemeData(color: Colors.white),
            title: const Padding(
              padding: EdgeInsets.fromLTRB(90, 0, 0, 0),
              child: Text(
                'Kết Quả',
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              // cai nay cua thang save
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: IconButton(
                  onPressed: () async {
                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                      var results = prefs.getStringList('barcode_data');
                      List<String> jsonList = <String>[];
                      for (BarcodeResult result in widget.barcodeResults) {
                        jsonList.add(jsonEncode(result.toJson()));
                      }
                      if (results == null) {
                        prefs.setStringList('barcode_data', jsonList);
                      } else {
                        results.addAll(jsonList);
                        prefs.setStringList('barcode_data', results);
                      }
                      // Tạo SnackBar
                      const snackBar = SnackBar(
                        content: Text('Kết quả đã được lưu lại!'),
                        duration: Duration(seconds: 2), // Đặt thời gian hiển thị của Snackbar
                      );
                      // Hiển thị SnackBar
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  icon: const Icon(Icons.save_alt, color: Colors.white),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              count,
              resultList,
              Expanded(
                child: Container(),
              ),
              // button
            ],
          ),
        ));
  }
}

class MyCustomWidget extends StatefulWidget {
  final BarcodeResult result;
  final int index;

  const MyCustomWidget({
    super.key,
    required this.index,
    required this.result,
  });

  @override
  State<MyCustomWidget> createState() => _MyCustomWidgetState();
}

class _MyCustomWidgetState extends State<MyCustomWidget>{
  bool isCopied = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: Colors.lightBlue,
                radius: 12,
                child: Text(
                  '${widget.index + 1}',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              const SizedBox(width: 15,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   'Format: ${widget.result.format}',
                  //   style: const TextStyle(
                  //     color: Colors.black,
                  //     fontSize: 14,
                  //     overflow: TextOverflow.ellipsis,
                  //   ),
                  // ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 110,
                    child: Text(
                      widget.result.text,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              // InkWell(
              //   onTap: () {
              //     print('button is clicked');
              //     setState(() {
              //       isCopied = !isCopied;
              //     });
              //     Clipboard.setData(ClipboardData(
              //         text:'Format: ${widget.result.format}, Text: ${widget.result.text}'
              //     ));
              //   },
              //   child: Container(
              //     padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              //     decoration: BoxDecoration(
              //       color: !isCopied ? Colors.blue : Colors.grey,
              //       borderRadius: BorderRadius.circular(5.0),
              //     ),
              //     child: const Text(
              //       'Copy',
              //       style: TextStyle(color: Colors.white, fontSize: 14),
              //     ),
              //   ),
              // ),
              // InkWell(
              //   onTap: () {
              //     String result = 'Format: ${widget.result.format}, Text: ${widget.result.text}';
              //     Share.share(result);
              //   },
              //   child: const Icon(Icons.share, color: Colors.black,),
              // ),
              SizedBox(
                width: 30,
                child: PopupMenuButton<int>(
                  icon: const Icon(Icons.more_vert, color: Colors.black),
                  onSelected: (int selected) {
                    if (selected == 0) {
                      String result = 'Format: ${widget.result.format}, Text: ${widget.result.text}';
                      Share.share(result);
                    } else if (selected == 1) {
                      Clipboard.setData(ClipboardData(
                          text: 'Format: ${widget.result.format}, Text: ${widget.result.text}'));
                    }
                  },
                  itemBuilder: (BuildContext context) => [
                    const PopupMenuItem<int>(
                      value: 0,
                      child: Text(
                        'Share',
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

