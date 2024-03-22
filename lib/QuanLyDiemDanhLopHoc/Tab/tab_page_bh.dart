import 'dart:math';

import 'package:barcodescanner/Mananger/sinhvien_manager.dart';
import 'package:barcodescanner/QuanLyDiemDanhLopHoc/Pages/buoihoc_detail.dart';
import 'package:barcodescanner/QuanLyDiemDanhLopHoc/Pages/camera_diemdanh.dart';
import 'package:barcodescanner/QuanLyDiemDanhLopHoc/Pages/home_page.dart';
import 'package:barcodescanner/QuanLyDiemDanhLopHoc/Pages/setting_page.dart';
import 'package:barcodescanner/QuanLyDiemDanhLopHoc/Pages/thongke_cacbuoihoc.dart';
import 'package:flutter/material.dart';

import '../Models/buoihoc_model.dart';
import '../Models/sinhvien_model.dart';

class TabPageBuoiHoc extends StatefulWidget {
  TabPageBuoiHoc({Key? key, required this.buoiHoc, required this.danhSachSinhVien}) : super(key: key);
  final BuoiHoc buoiHoc;
  late List<SinhVien> danhSachSinhVien;
  @override
  State<TabPageBuoiHoc> createState() => _TabPageBuoiHocState();
}

class _TabPageBuoiHocState extends State<TabPageBuoiHoc> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<CustomTab> myTabs = <CustomTab>[
    CustomTab(
      icon: const Icon(Icons.qr_code_scanner),
      selectedIcon: const Icon(Icons.qr_code_scanner),
    ),
    CustomTab(
      icon: const Icon(Icons.assignment),
      selectedIcon: const Icon(Icons.assignment),
    ),
    CustomTab(
      icon: const Icon(Icons.area_chart),
      selectedIcon: const Icon(Icons.area_chart),
    ),
  ];
  int selectedIndex = 1;
  @override
  void initState()  {
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
          CameraPageDiemDanh(buoiHoc: widget.buoiHoc),
          BuoiHocDetail(buoiHoc: widget.buoiHoc, danhSachSinhVien: widget.danhSachSinhVien),
          // ThongKeCacBuoiHoc(buoiHoc: widget.buoiHoc)
          const SettingPage()
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: ColoredBox(
          color: Colors.blue,
          child: TabBar(
            controller: _tabController,
            onTap: (index){
              setState(() {
                widget.danhSachSinhVien = widget.danhSachSinhVien;
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


