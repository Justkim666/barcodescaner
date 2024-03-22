import 'dart:io';
import 'package:barcodescanner/global.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Models/user/user_data.dart';
import '../widgets/appbar_widget.dart';

class EditImagePage extends StatefulWidget {
  const EditImagePage({Key? key}) : super(key: key);

  @override
  _EditImagePageState createState() => _EditImagePageState();
}

class _EditImagePageState extends State<EditImagePage> {
  var user = UserData.myUser;
  late var newImage;

  @override
  void initState() {
    super.initState();
    // Load user image path from SharedPreferences
    loadUserImage();
  }

  Future<void> loadUserImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? imagePath = prefs.getString('user_image');
    if (imagePath != null) {
      setState(() {
        user = user.copy(imagePath: imagePath);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: const Text(
          'Mô Tả',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22.0,
          ),
        ),
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
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              width: 330,
              child: Text(
                "Cập Nhật Ảnh Đại Diện",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                width: 330,
                child: GestureDetector(
                  onTap: () async {
                    final image = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );

                    if (image == null) return;

                    final appDocDir = await getApplicationDocumentsDirectory();
                    final name = basename(image.path);
                    final imageFile = File('${appDocDir.path}/$name');
                    newImage = await File(image.path).copy(imageFile.path);
                    setState(() {
                      user = user.copy(imagePath: newImage.path);
                    });

                    // Save new image path to SharedPreferences
                    await saveUserImage(newImage.path);
                    print('Đây là đường dẫn ${user.image}');
                    final imageFilet = File(user.image);
                    print('Image file exists: ${await imageFilet.exists()}');
                  },
                  child: user.image.startsWith('http')
                      ? Image.network(user.image)
                      : Image.file(File(user.image)),
                  // Image.file(File(user.image)), // Use Image.file instead of Image.network
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 330,
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                    ),
                    onPressed: () async {
                      saveUserImage(newImage.path);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> saveUserImage(String imagePath) async {
    // Update the user object with the new image path
    user = user.copy(imagePath: imagePath);

    // Save the updated user object to UserData
    await UserData.setUser(user);

    // Save the image path to SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_image', imagePath);
  }
}
