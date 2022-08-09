import 'package:flutter/material.dart';
import 'package:real_time_chat/global/env.dart';
import 'package:real_time_chat/models/mensaje_response.dart';
import 'package:real_time_chat/models/user.dart';

import 'package:http/http.dart' as http;
import 'package:real_time_chat/services/auth_service.dart';

class ChatService with ChangeNotifier {
  late User userTo;

  Future<List<Last30>> getChat(String userId) async {
    final url = Uri.parse('${Environment.apiUrl}/mensajes/$userId');
    final token = await AuthService.getToken();

    final resp = await http.get(url,
        headers: {'Content-Type': 'application/json', 'x-token': token ?? ''});

    final mensajeResponse = mensajesResponseFromJson(resp.body);

    return mensajeResponse.last30;
  }
}
