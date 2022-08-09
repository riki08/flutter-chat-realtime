import 'package:flutter/material.dart';
import 'package:real_time_chat/global/env.dart';
import 'package:real_time_chat/services/auth_service.dart';
import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  late ServerStatus _serverStatus = ServerStatus.Connecting;
  late Socket _socket;

  ServerStatus get serverStatus => _serverStatus;

  Socket get socket => _socket;
  Function get emit => _socket.emit;

  void connect() async {
    final token = await AuthService.getToken();

    // Dart client
    _socket = io(
        Environment.socketUrl,
        OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .enableForceNew()
            .setExtraHeaders({'x-token': token})
            .build());

    _socket.on('connect', (_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket.on('disconnect', (_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }

  void disConnect() {
    _socket.disconnect();
  }
}
