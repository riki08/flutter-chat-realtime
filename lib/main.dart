import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:real_time_chat/routes/routes.dart';
import 'package:real_time_chat/services/auth_service.dart';
import 'package:real_time_chat/services/chat_service.dart';
import 'package:real_time_chat/services/socket_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthService(),
        ),
        ChangeNotifierProvider(
          create: (_) => SocketService(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatService(),
        ),
      ],
      child: MaterialApp(
        title: 'Chat App',
        debugShowCheckedModeBanner: false,
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}
