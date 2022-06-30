import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:real_time_chat/global/env.dart';
import 'package:real_time_chat/models/login_response.dart';
import 'package:real_time_chat/models/user.dart';

class AuthService with ChangeNotifier {
  late User user;
  bool _authenticating = false;

  final _storage = FlutterSecureStorage();

  bool get authenticating => _authenticating;

  set authenticating(bool value) {
    _authenticating = value;
    notifyListeners();
  }

  // Getters del token statica
  static Future<String?> getToken() async {
    final _storage = FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    authenticating = true;

    final data = {'email': email, 'password': password};

    final url = Uri.parse('${Environment.apiUrl}/login');

    final res = await http.post(url,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    authenticating = false;

    if (res.statusCode == 200) {
      final loginResponse = loginResponseFromJson(res.body);
      user = loginResponse.usuario!;

      await _saveToken(loginResponse.token);

      return true;
    } else {
      return false;
    }
  }

  Future register(String name, String email, String password) async {
    authenticating = true;

    final data = {'nombre': name, 'email': email, 'password': password};

    final url = Uri.parse('${Environment.apiUrl}/login/new');

    final res = await http.post(url,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    authenticating = false;

    if (res.statusCode == 200) {
      final loginResponse = loginResponseFromJson(res.body);
      user = loginResponse.usuario!;

      await _saveToken(loginResponse.token);

      return true;
    } else {
      final resBody = jsonDecode(res.body);
      return resBody['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token');
    final url = Uri.parse('${Environment.apiUrl}/login/renew');

    final res = await http.get(url,
        headers: {'Content-Type': 'application/json', 'x-token': token ?? ''});

    authenticating = false;

    if (res.statusCode == 200) {
      final loginResponse = loginResponseFromJson(res.body);
      user = loginResponse.usuario!;

      await _saveToken(loginResponse.token);

      return true;
    } else {
      logout();
      return false;
    }
  }

  Future _saveToken(token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }
}
