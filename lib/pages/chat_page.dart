import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Column(
          children: const [
            CircleAvatar(
              maxRadius: 15,
              backgroundColor: Colors.blueAccent,
              child: Text(
                'Te',
                style: TextStyle(fontSize: 12),
              ),
            ),
            SizedBox(height: 3),
            Text(
              'Tedio olvido',
              style: TextStyle(color: Colors.black87, fontSize: 12),
            )
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                reverse: true,
                itemBuilder: (_, i) => Text('$i'),
              ),
            ),
            const Divider(height: 1),
            InputChat()
          ],
        ),
      ),
    );
  }
}

class InputChat extends StatefulWidget {
  InputChat({Key? key}) : super(key: key);

  @override
  State<InputChat> createState() => _InputChatState();
}

class _InputChatState extends State<InputChat> {
  final TextEditingController textEditingController = TextEditingController();
  final _focusNode = FocusNode();
  bool isWriting = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Flexible(
                child: TextField(
                  controller: textEditingController,
                  onSubmitted: _handleSubmit,
                  onChanged: (value) {
                    if (value.length > 0) {
                      isWriting = true;
                    } else {
                      isWriting = false;
                    }
                    setState(() {});
                  },
                  decoration:
                      InputDecoration.collapsed(hintText: 'Enviar mensaje'),
                  focusNode: _focusNode,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                child: Platform.isIOS
                    ? CupertinoButton(
                        child: Text('Enviar'),
                        onPressed: isWriting
                            ? () => _handleSubmit(textEditingController.text)
                            : null,
                      )
                    : Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.0),
                        child: IconTheme(
                          data: IconThemeData(color: Colors.blue[400]),
                          child: IconButton(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onPressed: isWriting
                                  ? () =>
                                      _handleSubmit(textEditingController.text)
                                  : null,
                              icon: Icon(Icons.send)),
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _handleSubmit(String text) {
    setState(() {
      _focusNode.requestFocus();
      textEditingController.clear();
      isWriting = false;
    });
  }
}
