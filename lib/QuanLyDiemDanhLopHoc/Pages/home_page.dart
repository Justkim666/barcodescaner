import 'package:barcodescanner/QuanLyDiemDanhLopHoc/Pages/lophocphan_detail.dart';
import 'package:flutter/material.dart';

import '../../Mananger/lophoc_mananger.dart';
import '../../Mananger/lophocphan_mananger.dart';
import '../Models/lophoc_model.dart';
import '../Models/lophocphan_model.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  final List<LopHocPhan> _lopHocPhan = [];
  final LopHocManager _lopHocManager = LopHocManager();
  final LopHocPhanManager _lopHocPhanManager = LopHocPhanManager();
  String _searchKeyword = '';
  List<LopHocPhan> _searchResult = [];

  @override
  void initState() {
    super.initState();
    _loadLopHocPhans();
  }

  Future<void> _loadLopHocPhans() async {
    final lopHocPhans = await _lopHocPhanManager.getAllLopHocPhan();
    setState(() {
      _lopHocPhan.clear();
      _lopHocPhan.addAll(lopHocPhans);
    });
  }

  Future<void> _insertLopHocPhan() async {
    String lophocphanId = UniqueKey().toString();

    await _lopHocPhanManager.insertLopHocPhan(LopHocPhan(
      id: lophocphanId,
      tenLopHocPhan: _controller.text,
    ));

    _controller.clear();
    _loadLopHocPhans();
  }

  Future<void> _showAddDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thêm Lớp Học'),
          content: TextField(
            controller: _controller,
            decoration: const InputDecoration(labelText: 'Tên Lớp Học Phần'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy bỏ'),
            ),
            TextButton(
              onPressed: () {
                _insertLopHocPhan();
                Navigator.pop(context);
              },
              child: const Text('Thêm'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditDialog(LopHocPhan lopHocPhan) async {
    TextEditingController editController =
    TextEditingController(text: lopHocPhan.tenLopHocPhan);

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Chỉnh Sửa Lớp Học'),
          content: TextField(
            controller: editController,
            decoration: const InputDecoration(labelText: 'Tên Lớp Học Phần'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                _editLopHocPhan(lopHocPhan, editController.text);
                Navigator.pop(context);
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }
  Future<void> _confirmDelete(LopHocPhan lopHocPhan) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa lớp học'),
          content: Text(
              'Bạn có muốn xóa lớp học phần ${lopHocPhan.tenLopHocPhan}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                _deleteLopHocPhan(lopHocPhan.id);
                Navigator.pop(context);
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editLopHocPhan(LopHocPhan lopHocPhan, String newName) async {
    lopHocPhan.tenLopHocPhan = newName;
    await _lopHocPhanManager.updateLopHocPhan(lopHocPhan);
    _loadLopHocPhans();
  }

  Future<void> _deleteLopHocPhan(String id) async {
    await _lopHocPhanManager.deleteLopHocPhan(id);
    _loadLopHocPhans();
  }

  void _searchLopHocPhans(String keyword) {
    setState(() {
      _searchKeyword = keyword;
      _searchResult.clear();
      if (keyword.isNotEmpty) {
        _searchResult.addAll(_lopHocPhan.where((lopHocPhan) =>
            lopHocPhan.tenLopHocPhan.toLowerCase().contains(keyword.toLowerCase())));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: const Text('Lớp Học', style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white,),
            onPressed: () async {
              String? result = await showSearch(
                context: context,
                delegate: CustomSearchDelegate(_lopHocPhan, _searchKeyword, _searchLopHocPhans),
              );
              if (result != null) {
                _searchLopHocPhans(result);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(3),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.lightBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: Colors.white, // Màu sắc của viền
                    width: 2.0, // Độ rộng của viền
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const ListTile(
                  contentPadding: EdgeInsets.all(16),
                  leading: Icon(
                    Icons.school,
                    size: 40,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Các Lớp Học Phần',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchKeyword.isEmpty ? _lopHocPhan.length : _searchResult.length,
              itemBuilder: (context, index) {
                final lopHocPhan =
                _searchKeyword.isEmpty ? _lopHocPhan[index] : _searchResult[index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    onTap: () async {
                      List<LopHoc> danhSachLopHoc = await _lopHocManager.getAllLopHoc(lopHocPhan.id);
                      // Navigate to details as needed
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LopHocPhanDetail(lopHocPhan: lopHocPhan, danhSachLopHoc: danhSachLopHoc),
                        ),
                      );
                    },
                    leading: const Icon(
                      Icons.school,
                      color: Colors.blue,
                    ),
                    title: Text(
                      lopHocPhan.tenLopHocPhan,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showEditDialog(lopHocPhan),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(lopHocPhan),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        tooltip: 'Thêm Lớp Học',
        backgroundColor: Colors.transparent, // Đặt màu nền là trong suốt
        child: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.blue], // Chọn màu chuyển
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Icon(Icons.add, color: Colors.white),
          ),
        ),
      )
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<String> {
  final List<LopHocPhan> lopHocPhans;
  final String searchKeyword;
  final Function(String) searchFunction;
  final LopHocManager _lopHocManager = LopHocManager();

  CustomSearchDelegate(this.lopHocPhans, this.searchKeyword, this.searchFunction);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          searchFunction('');
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, ''); // Use an empty string or another default value
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    List<LopHocPhan> searchResult = lopHocPhans
        .where((lopHocPhan) =>
        lopHocPhan.tenLopHocPhan.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: searchResult.length,
      itemBuilder: (context, index) {
        final lopHocPhan = searchResult[index];
        return GestureDetector(
          onTap: () {
            // Handle onTap, e.g., navigate to details page
            // You can replace this with your desired behavior
            close(context, lopHocPhan.tenLopHocPhan);
          },
          child: Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            onTap: () async {
              // Navigate to details as needed
              List<LopHoc> danhSachLopHoc = await _lopHocManager.getAllLopHoc(lopHocPhan.id);
              // Navigate to details as needed
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LopHocPhanDetail(lopHocPhan: lopHocPhan, danhSachLopHoc: danhSachLopHoc)
                  )
              );
            },
            leading: const Icon(
              Icons.school,
              color: Colors.blue,
            ),
            title: Text(
              lopHocPhan.tenLopHocPhan,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: (){},
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: (){},
                ),
              ],
            ),
          ),
        ),
        );
      },
    );
  }
}

