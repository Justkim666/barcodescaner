import 'package:barcodescanner/QuanLyDiemDanhLopHoc/pages/camera_page.dart';
import 'package:barcodescanner/QuanLyDiemDanhLopHoc/pages/result_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_sdk/dynamsoft_barcode.dart';

import '../pages/history_page.dart';

class TabPageResults extends StatefulWidget {
  const TabPageResults({Key? key, required this.barcodeResults}) : super(key: key);
  final List<BarcodeResult> barcodeResults;
  @override
  State<TabPageResults> createState() => _TabPageResultsState();
}

class _TabPageResultsState extends State<TabPageResults> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<CustomTab> myTabs = <CustomTab>[
    CustomTab(
      text: 'Quét Nhanh',
      icon: const Icon(Icons.qr_code_scanner),
      selectedIcon: const Icon(Icons.qr_code_scanner),
    ),
    CustomTab(
      text: 'Kết Quả',
      icon: const Icon(Icons.check_box),
      selectedIcon: const Icon(Icons.check_box),
    ),
    CustomTab(
      text: 'Lịch Sử Lưu',
      icon: const Icon(Icons.history),
      selectedIcon: const Icon(Icons.history),
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
          const CameraPage(),
          ResultPage(barcodeResults: widget.barcodeResults),
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


