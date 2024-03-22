import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_model.dart';

class UserData {
  static late SharedPreferences _preferences;
  static const _keyUser = 'user';

  static User myUser = User(
    image:
    // "https://upload.wikimedia.org/wikipedia/en/0/0b/Darth_Vader_in_The_Empire_Strikes_Back.jpg",
    "https://e7.pngegg.com/pngimages/799/987/png-clipart-computer-icons-avatar-icon-design-avatar-heroes-computer-wallpaper-thumbnail.png",
    name: '...',
    email: '...',
    phone: '...',
    aboutMeDescription:'...',
  );

  static Future init() async {
    try {
      _preferences = await SharedPreferences.getInstance();
      final String? userJson = _preferences.getString(_keyUser);

      if (userJson != null && userJson.isNotEmpty) {
        final Map<String, dynamic> userMap = jsonDecode(userJson);
        myUser = User.fromJson(userMap);
      }
    } catch (e) {
      // Xử lý lỗi khởi tạo SharedPreferences
      print('Error initializing SharedPreferences: $e');
      // Có thể bạn muốn thêm xử lý khác tùy thuộc vào nhu cầu của bạn
    }
  }


  static Future setUser(User user) async {
    await init();  // Đảm bảo _preferences đã được khởi tạo
    if (_preferences != null) {
      final json = user.toJson();
      await _preferences.setString(_keyUser, jsonEncode(json));
    }
  }

  static User getUser() {
    if (_preferences != null) {
      final String? userJson = _preferences.getString(_keyUser);

      if (userJson != null && userJson.isNotEmpty) {
        final Map<String, dynamic> userMap = jsonDecode(userJson);
        return User.fromJson(userMap);
      } else {
        // Nếu không có thông tin người dùng, sử dụng giá trị mặc định
        return UserData.myUser;
      }
    } else {
      // Nếu _preferences chưa được khởi tạo, trả về giá trị mặc định
      return UserData.myUser;
    }
  }

}
