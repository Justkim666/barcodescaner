import 'package:flutter/material.dart';
import 'dart:async';
import 'QuanLyDiemDanhLopHoc/Models/user/user_data.dart';
import 'QuanLyDiemDanhLopHoc/tab/tab_page.dart';
import 'global.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserData.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<int> loadData() async {
    return await initBarcodeSDK();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hoang Kim software detection',
      home: FutureBuilder<int>(
        future: loadData(),
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator()); // Loading indicator
          }
          Future.microtask(() {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const TabPage()));
          });
          return Container();
        },
      ),
    );
  }
}
