import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

import '../../../Models/user/user_data.dart';
import '../widgets/appbar_widget.dart';

class EditEmailFormPage extends StatefulWidget {
  const EditEmailFormPage({Key? key}) : super(key: key);

  @override
  EditEmailFormPageState createState() {
    return EditEmailFormPageState();
  }
}

class EditEmailFormPageState extends State<EditEmailFormPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  var user = UserData.myUser;
  bool isKeyboardVisible = false;

  @override
  void dispose() {
    emailController.dispose();
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
          'Cập Nhật Thông Tin Email',
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
                  "Nhập Thông Tin Email",
                  style:
                  TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
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
                            return 'Vui Lòng Nhập Email';
                          } else if (!isEmail(value)) {
                            return 'Không Hợp Lệ';
                          }
                        },
                        decoration: const InputDecoration(
                            labelText: 'Nhập Email'),
                        controller: emailController,
                      ))),
              Padding(
                  padding: EdgeInsets.only(top: 150),
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
                                  EmailValidator.validate(
                                      emailController.text)) {
                                // cap nhat
                                user = user.copy(email: emailController.text);
                                await UserData.setUser(user);
                                updateUserValue(emailController.text);
                                Navigator.pop(context);
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
// void updateUserValue(String name) async{
//   user = user.copy(name: name);
//   await UserData.setUser(user);
// }
  void updateUserValue(String email) async{
    user = user.copy(email: email);
    await UserData.setUser(user);
  }
}
