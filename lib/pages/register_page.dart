import 'package:flutter/material.dart';
import 'package:real_time_chat/widgets/custom_button.dart';

import 'package:real_time_chat/widgets/custom_input.dart';
import 'package:real_time_chat/widgets/labels.dart';
import 'package:real_time_chat/widgets/logo.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Logo(
                    title: 'Registro',
                  ),
                  _Form(),
                  Labels(
                    ruta: 'login',
                    title: 'Ya tienes cuenta?',
                    subTitle: 'Ingresa aqui',
                  ),
                  Text(
                    'Terminos y condiciones de uso',
                    style: TextStyle(fontWeight: FontWeight.w200),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  const _Form({Key? key}) : super(key: key);

  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            placeHolder: 'Name',
            icon: Icons.perm_identity,
            keyBoardType: TextInputType.text,
            textController: nameCtrl,
          ),
          CustomInput(
            placeHolder: 'Email',
            icon: Icons.email_outlined,
            keyBoardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            placeHolder: 'Password',
            icon: Icons.lock_clock_outlined,
            isPassword: true,
            textController: passwCtrl,
          ),
          CustomButton(
            title: 'Registro',
            onPressed: () {
              print(emailCtrl.text);
              print(passwCtrl.text);
            },
          )
        ],
      ),
    );
  }
}
