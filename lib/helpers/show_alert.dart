import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

showAlert(BuildContext context, String title, String subtitle) {
  if (Platform.isAndroid) {
    return showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(title),
              content: Text(subtitle),
              actions: [
                MaterialButton(
                  child: Text('ok'),
                  elevation: 5,
                  textColor: Colors.blue,
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ));
  }

  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(subtitle),
      actions: [
        CupertinoDialogAction(
          child: Text('ok'),
          isDefaultAction: true,
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    ),
  );
}
