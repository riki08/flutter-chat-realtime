import 'package:flutter/material.dart';

import 'package:real_time_chat/routes/routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      initialRoute: 'chat',
      routes: appRoutes,
    );
  }
}
