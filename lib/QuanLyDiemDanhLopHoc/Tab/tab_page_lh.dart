import 'package:barcodescanner/QuanLyDiemDanhLopHoc/Models/lophoc_model.dart';
import 'package:barcodescanner/QuanLyDiemDanhLopHoc/Pages/camera_page.dart';
import 'package:barcodescanner/QuanLyDiemDanhLopHoc/Pages/home_page.dart';
import 'package:flutter/material.dart';

import '../Pages/history_page.dart';

class TabPageLopHoc extends StatefulWidget {
  const TabPageLopHoc({Key? key, required this.lopHoc}) : super(key: key);
  final LopHoc lopHoc;
  @override
  State<TabPageLopHoc> createState() => _TabPageLopHocState();
}

class _TabPageLopHocState extends State<TabPageLopHoc> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<CustomTab> myTabs = <CustomTab>[
    CustomTab(
      icon: const Icon(Icons.add_chart_outlined),
      selectedIcon: const Icon(Icons.add_chart_outlined),
    ),
    CustomTab(
      icon: const Icon(Icons.assignment),
      selectedIcon: const Icon(Icons.assignment),
    ),
    CustomTab(
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
          const CameraPage(),
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
        ],
      ),
    );
  }
}

class CustomTab {
  final Icon icon;
  final Icon selectedIcon;

  CustomTab({
    required this.icon,
    required this.selectedIcon,
  });
}


