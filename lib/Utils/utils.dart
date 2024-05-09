import 'dart:convert';

import 'package:chat_app_with_backend/Models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static SharedPreferences? _preferences;

  static Future<void> _initPreferences() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  static Future<void> saveToken(String token) async {
    await _initPreferences();
    await _preferences!.setString("Auth-Token", token);
  }

  static Future<String?> getToken() async {
    await _initPreferences();
    return _preferences!.getString("Auth-Token");
  }

  static Future<void> removeToken() async {
    await _initPreferences();
    await _preferences!.remove("Auth-Token");
  }

  static Future<void> saveUser(UserModel user) async {
    await _initPreferences();
    String userJson = jsonEncode(user.toJson());
    await _preferences!.setString('User-Details', userJson);
  }

  static Future<UserModel> getUser() async {
    await _initPreferences();
    String? userJson = _preferences!.getString('User-Details');
    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);
      return UserModel.fromJson(userMap);
    }
    return UserModel();
  }

  static Future<void> removeUser() async{
    await _initPreferences();
    await _preferences!.remove("User-Details");
  }

  static getUserId<String>()async{
      UserModel user = await getUser();
      return user.id;
  }
}
