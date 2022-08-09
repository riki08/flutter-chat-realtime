import 'package:http/http.dart' as http;
import 'package:real_time_chat/global/env.dart';

import 'package:real_time_chat/models/user.dart';
import 'package:real_time_chat/models/user_response.dart';
import 'package:real_time_chat/services/auth_service.dart';

class UserService {
  Future<List<User>> getUsers() async {
    try {
      final url = Uri.parse('${Environment.apiUrl}/usuarios');
      final token = await AuthService.getToken();
      final resp = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'x-token': token ?? ''
      });

      final userResponse = userResponseFromJson(resp.body);

      return userResponse.usuarios!;
    } catch (e) {
      return [];
    }
  }
}
