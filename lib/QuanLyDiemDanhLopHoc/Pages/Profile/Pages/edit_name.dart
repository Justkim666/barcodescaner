import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';
import '../../../Models/user/user_data.dart';

class EditNameFormPage extends StatefulWidget {
  const EditNameFormPage({Key? key}) : super(key: key);

  @override
  EditNameFormPageState createState() {
    return EditNameFormPageState();
  }
}

class EditNameFormPageState extends State<EditNameFormPage> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final secondNameController = TextEditingController();
  var user = UserData.myUser;
  bool isKeyboardVisible = false;

  @override
  void dispose() {
    firstNameController.dispose();
    secondNameController.dispose();
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
          'Cập Nhật Tên',
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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              const SizedBox(
                  width: 330,
                  child: Text(
                    "Nhập Thông Tin Tên",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 40, 16, 0),
                      child: SizedBox(
                          height: 100,
                          width: 150,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui Lòng Nhập Họ';
                              } else if (!isAlpha(value)) {
                                return 'Không Hợp Lệ';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(labelText: 'Họ'),
                            controller: firstNameController,
                          ))),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 40, 16, 0),
                      child: SizedBox(
                          height: 100,
                          width: 150,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Vui Lòng Nhập Tên';
                              } else if (!isAlpha(value)) {
                                return 'Không Hợp Lệ';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(labelText: 'Tên'),
                            controller: secondNameController,
                          )))
                ],
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 150),
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
                            isKeyboardVisible = KeyboardVisible(context);
                            if (isKeyboardVisible) {
                              hideKeyboard();
                            } else {
                              if (_formKey.currentState!.validate() &&
                                  isAlpha(firstNameController.text +
                                      secondNameController.text)) {
                                final newName =
                                    "${firstNameController.text} ${secondNameController.text}";
                                // Cập nhật giá trị người dùng
                                user = user.copy(name: newName);
                                await UserData.setUser(user);
                                updateUserValue(newName);

                                // Quay lại trang trước đó
                                Navigator.pop(context);
                              }
                            }
                          },
                          child: const Text(
                            'Cập Nhật',
                            style: TextStyle(fontSize: 15, color: Colors.white),
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
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return keyboardHeight > 0;
  }

  void updateUserValue(String name) async{
    user = user.copy(name: name);
    await UserData.setUser(user);
  }
}
