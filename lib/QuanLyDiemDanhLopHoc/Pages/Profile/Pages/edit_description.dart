import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../Models/user/user_data.dart';
import '../widgets/appbar_widget.dart';

class EditDescriptionFormPage extends StatefulWidget {
  @override
  _EditDescriptionFormPageState createState() =>
      _EditDescriptionFormPageState();
}

class _EditDescriptionFormPageState extends State<EditDescriptionFormPage> {
  final _formKey = GlobalKey<FormState>();
  final descriptionController = TextEditingController();
  var user = UserData.myUser;
  bool isKeyboardVisible = false;

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            isKeyboardVisible = KeyboardVisible(context);
            if (isKeyboardVisible) {
              hideKeyboard();
            } else {
              Navigator.pop(context);
            }
          },
        ),
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
        title: const Text(
          'Cập Nhật Thông Tin',
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
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20,),
              const SizedBox(
                width: 350,
                child: Text(
                  "Thông Tin Về Bản Thân",
                  style:
                  TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: SizedBox(
                      height: 250,
                      width: 350,
                      child: TextFormField(
                        // Handles Form Validation
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length > 200) {
                            return 'Vui lòng mô tả bản thân dưới 200 ký tự.';
                          }
                          return null;
                        },
                        controller: descriptionController,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: const InputDecoration(
                            alignLabelWithHint: true,
                            contentPadding:
                            EdgeInsets.fromLTRB(10, 15, 10, 100),
                            hintMaxLines: 3,
                            hintText:
                            'Viết Thông Tin Mô Tả Bản Thân'),
                      ))),
              Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: 350,
                        height: 50,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                          ),
                          onPressed: () async{
                            isKeyboardVisible = KeyboardVisible(context);
                            if (isKeyboardVisible) {
                              hideKeyboard();
                            } else {
                              if (_formKey.currentState!.validate()) {
                                final description = descriptionController.text;
                                user = user.copy(about: description);
                                await UserData.setUser(user);
                                updateUserValue(description);
                                Navigator.pop(context, true);
                              }
                            }
                          },
                          child: const Text(
                            'Cập Nhật',
                            style:
                            TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                      )))
            ],
          ),
        ),
      ),
    );
  }

  void hideKeyboard() {
    FocusScope.of(context).unfocus();
  }

  bool KeyboardVisible(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    // Nếu chiều cao của bàn phím lớn hơn 0, bàn phím đang hiển thị
    return keyboardHeight > 0;
  }
  void updateUserValue(String description) async{
    user = user.copy(about: description);
    user = user.copy(about: description);
    await UserData.setUser(user);
  }
  // void updateUserValue(String email) async{
  //   user = user.copy(email: email);
  //   await UserData.setUser(user);
  // }
}
