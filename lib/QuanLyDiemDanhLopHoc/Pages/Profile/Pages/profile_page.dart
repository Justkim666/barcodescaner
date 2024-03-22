import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../Models/user/user_data.dart';
import '../../../Models/user/user_model.dart';
import '../widgets/display_image_widget.dart';
import 'edit_description.dart';
import 'edit_email.dart';
import 'edit_image.dart';
import 'edit_name.dart';
import 'edit_phone.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late User user = UserData.myUser;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userJson = prefs.getString('user') ?? '';
    if (userJson.isNotEmpty) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      setState(() {
        user = User.fromJson(userMap);
      });
    } else {
      // Nếu không có thông tin người dùng, sử dụng giá trị mặc định
      user = UserData.myUser;
    }
  }


  // Hàm cập nhật thông tin người dùng khi quay lại từ trang chỉnh sửa
  Future<void> updateUserProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userJson = prefs.getString('user') ?? '';
    if (userJson.isNotEmpty) {
      final Map<String, dynamic> userMap = jsonDecode(userJson);
      setState(() {
        user = User.fromJson(userMap);
      });
    }
  }

  // Hàm cập nhật thông tin người dùng và lưu vào SharedPreferences
  Future<void> saveUserProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userJson = jsonEncode(user.toJson());
    await prefs.setString('user', userJson);
  }


  // Hàm chuyển đến trang chỉnh sửa và đợi kết quả
  Future<void> navigateToEditPage(Widget editPage) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => editPage),
    );
    await updateUserProfile();
  }

  // Widget hiển thị thông tin người dùng
  Widget buildUserInfoDisplay(String getValue, String title, Widget editPage) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 1,
            ),
            Container(
              width: 350,
              height: 40,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        await navigateToEditPage(editPage);
                        await updateUserProfile();
                      },
                      child: Text(
                        getValue,
                        style: const TextStyle(fontSize: 16, height: 1.4),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.grey,
                    size: 40.0,
                  )
                ],
              ),
            ),
          ],
        ),
      );

  // Widget hiển thị mô tả về người dùng
  Widget buildAbout(User user) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thông Tin Bản Thân',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 1),
        Container(
          width: 350,
          height: 200,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    await navigateToEditPage(EditDescriptionFormPage()).then(onGoBack);
                    await updateUserProfile();
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        user.aboutMeDescription,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_right,
                color: Colors.grey,
                size: 40.0,
              )
            ],
          ),
        ),
      ],
    ),
  );

  // Refrshes the Page after updating user info.
  FutureOr<void> onGoBack(dynamic value) async {
    await updateUserProfile();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Hồ Sơ',
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
      body: Column(
        children: [
          const SizedBox(height: 15,),
          InkWell(
            onTap: () async {
              await navigateToEditPage(const EditImagePage());
              await updateUserProfile();
            },
            child: DisplayImage(
              imagePath: user.image,
              onPressed: () {},
            ),
          ),
          buildUserInfoDisplay(user.name, 'Tên', const EditNameFormPage()),
          buildUserInfoDisplay(user.phone, 'SĐT', const EditPhoneFormPage()),
          buildUserInfoDisplay(user.email, 'Email', const EditEmailFormPage()),
          Expanded(
            flex: 4,
            child: buildAbout(user),
          ),
        ],
      ),
    );
  }
}
