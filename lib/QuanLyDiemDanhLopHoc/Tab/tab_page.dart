import 'package:barcodescanner/QuanLyDiemDanhLopHoc/Pages/Profile/Pages/profile_page.dart';
import 'package:barcodescanner/QuanLyDiemDanhLopHoc/Pages/lich_day_page.dart';
import 'package:barcodescanner/QuanLyDiemDanhLopHoc/Pages/home_page.dart';
import 'package:flutter/material.dart';

import '../pages/history_page.dart';
class TabPage extends StatefulWidget {
  const TabPage({Key? key}) : super(key: key);

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<CustomTab> myTabs = <CustomTab>[
    CustomTab(
      icon: const Icon(Icons.calendar_month),
      selectedIcon: const Icon(Icons.calendar_month),
    ),
    CustomTab(
      icon: const Icon(Icons.school),
      selectedIcon: const Icon(Icons.school),
    ),
    CustomTab(
      icon: const Icon(Icons.person),
      selectedIcon: const Icon(Icons.person),
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
          LichDayPage(),
          HomePage(),
          const ProfilePage(),
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


