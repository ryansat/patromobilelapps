import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:patromobilelapps/screens/auth/login_screen.dart';
import '../utils/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:patromobilelapps/screens/home_screen.dart';

class LoginController with ChangeNotifier {
  final Api api = Api();

  void _openMyPage(BuildContext context) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => HomeScreen(),
      ),
    );
  }

  void _openMyLogin(BuildContext context) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => LoginScreen(),
      ),
    );
  }

  Future<void> saveAuthToken(String authKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_key', authKey);
  }

  Future<String?> getAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  Future<dynamic> loginUser(
      String username, String password, BuildContext context) async {
    final response = await api.loginUser(username, password);

    if (response != null &&
        response["token"] != null &&
        response["token"].toString().isNotEmpty) {
      //Map<String, dynamic> jsonResponse = json.decode(response.body);
      var authKey = response["token"];
      if (authKey != null) {
        print('logged successfully');
        await saveAuthToken(authKey);

        // Fetch user details after successful login
        int userId = response['userId'];
        _openMyPage(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "Failed To Connect To Server / Username or Password Wrong!!"),
        ));
      }
    } else {
      throw Exception('Failed to load post');
    }
  }
}
