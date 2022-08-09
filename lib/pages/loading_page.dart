// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:real_time_chat/pages/login_page.dart';
import 'package:real_time_chat/pages/user_page.dart';
import 'package:real_time_chat/services/auth_service.dart';
import 'package:real_time_chat/services/socket_service.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: chechkLoginState(context),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return const Center(
            child: Text('Animacion jejej'),
          );
        },
      ),
    );
  }

  Future chechkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);
    final authenticating = await authService.isLoggedIn();

    if (authenticating) {
      socketService.connect();
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
            pageBuilder: (_, __, ___) => const UserPage(),
            transitionDuration: const Duration(milliseconds: 0)),
      );
    } else {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => const LoginPage(),
              transitionDuration: const Duration(milliseconds: 0)));
    }
  }
}
