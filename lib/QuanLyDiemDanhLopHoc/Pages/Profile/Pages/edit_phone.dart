import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

import '../../../Models/user/user_data.dart';
import '../widgets/appbar_widget.dart';

class EditPhoneFormPage extends StatefulWidget {
  const EditPhoneFormPage({Key? key}) : super(key: key);

  @override
  EditPhoneFormPageState createState() {
    return EditPhoneFormPageState();
  }
}

class EditPhoneFormPageState extends State<EditPhoneFormPage> {
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  var user = UserData.myUser;
  bool isKeyboardVisible = false;

  @override
  void dispose() {
    phoneController.dispose();
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
          'Cập Nhật Số Điện Thoại',
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
                width: 320,
                child: Text(
                  "Nhập Thông Tin SĐT",
                  style:
                  TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: SizedBox(
                      height: 100,
                      width: 320,
                      child: TextFormField(
                        // Handles Form Validation
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui Lòng Nhập Số Điện Thoại';
                          } else if (isAlpha(value)) {
                            return 'Không Hợp Lệ';
                          } else if (value.length < 10) {
                            return 'Không Hợp Lệ';
                          }
                          return null;
                        },
                        controller: phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Nhập SĐT',
                        ),
                      ))),
              Padding(
                  padding: const EdgeInsets.only(top: 150),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: 320,
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
                              if (_formKey.currentState!.validate() &&
                                  isNumeric(phoneController.text)) {
                                final newPhone = phoneController.text;
                                //cap nhat
                                user = user.copy(phone: newPhone);
                                await UserData.setUser(user);
                                updateUserValue(newPhone);
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

  void updateUserValue(String phone) async{
    print('Before updating phone: ${user.phone}');
    user = user.copy(phone: phone);
    print('After updating phone: ${user.phone}');
    await UserData.setUser(user);
  }
}
