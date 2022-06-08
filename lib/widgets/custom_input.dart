import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  const CustomInput({
    Key? key,
    required this.icon,
    required this.placeHolder,
    required this.textController,
    this.keyBoardType = TextInputType.text,
    this.isPassword = false,
  }) : super(key: key);

  final IconData icon;
  final String placeHolder;
  final TextEditingController textController;
  final TextInputType keyBoardType;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 5),
                blurRadius: 5),
          ]),
      child: TextField(
        controller: textController,
        autocorrect: false,
        keyboardType: keyBoardType,
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          hintText: placeHolder,
        ),
      ),
    );
  }
}
