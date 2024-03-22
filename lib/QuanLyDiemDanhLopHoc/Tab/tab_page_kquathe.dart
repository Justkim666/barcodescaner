import 'package:barcodescanner/QuanLyDiemDanhLopHoc/Pages/camera_diemdanh.dart';
import 'package:barcodescanner/QuanLyDiemDanhLopHoc/Pages/home_page.dart';
import 'package:flutter/material.dart';

import '../Models/barcode_result_model.dart';
import '../Models/buoihoc_model.dart';
import '../Pages/history_page.dart';

class TabPageKetQuaThe extends StatefulWidget {
  TabPageKetQuaThe({Key? key, required this.barcodeResults, required this.buoiHoc}) : super(key: key);
  final List<BarcodeResult> barcodeResults;
  BuoiHoc buoiHoc;
  @override
  State<TabPageKetQuaThe> createState() => _TabPageKetQuaTheState();
}

class _TabPageKetQuaTheState extends State<TabPageKetQuaThe> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<CustomTab> myTabs = <CustomTab>[
    CustomTab(
      text: 'Điểm Danh',
      icon: const Icon(Icons.qr_code_scanner),
      selectedIcon: const Icon(Icons.qr_code_scanner),
    ),
    CustomTab(
      text: 'Kết Quả',
      icon: const Icon(Icons.check_box),
      selectedIcon: const Icon(Icons.check_box),
    ),
    CustomTab(
      text: 'Thống Kê',
      icon: const Icon(Icons.insert_chart),
      selectedIcon: const Icon(Icons.insert_chart),
    ),
  ];
  int selectedIndex = 1;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3, initialIndex: selectedIndex);
    _tabController.index = selectedIndex; // Đặt giá trị ban đầu cho tab được chọn
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          HomePage(),
          HomePage(),
          const HistoryPage(),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: ColoredBox(
          color: Colors.blue,
          child: TabBar(
            controller: _tabController,
            onTap: (index) {
              setState(() {
                selectedIndex = index;
              });
            },
            tabs: myTabs.map((CustomTab tab) {
              return MyTab(
                tab: tab,
                isSelected: myTabs.indexOf(tab) == selectedIndex,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class MyTab extends StatelessWidget {
  final CustomTab tab;
  final bool isSelected;

  const MyTab({Key? key, required this.tab, required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            isSelected ? tab.selectedIcon.icon : tab.icon.icon,
            color: isSelected ? Colors.orange: Colors.white,
          ),
          Text(
            tab.text,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9,
              color: isSelected ? Colors.orange: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTab {
  final String text;
  final Icon icon;
  final Icon selectedIcon;

  CustomTab({
    required this.text,
    required this.icon,
    required this.selectedIcon,
  });
}


