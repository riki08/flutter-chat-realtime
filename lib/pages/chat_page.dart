import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:real_time_chat/widgets/chat_message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final TextEditingController textEditingController = TextEditingController();
  final _focusNode = FocusNode();
  bool isWriting = false;
  List<ChatMessage> list = [];

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
                itemBuilder: (_, i) => list[i],
                itemCount: list.length,
              ),
            ),
            const Divider(height: 1),
            _inputChat()
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Flexible(
                child: TextField(
                  controller: textEditingController,
                  onSubmitted: _handleSubmit,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      isWriting = true;
                    } else {
                      isWriting = false;
                    }
                    setState(() {});
                  },
                  decoration: const InputDecoration.collapsed(
                      hintText: 'Enviar mensaje'),
                  focusNode: _focusNode,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Platform.isIOS
                    ? CupertinoButton(
                        onPressed: isWriting
                            ? () => _handleSubmit(textEditingController.text)
                            : null,
                        child: const Text('Enviar'),
                      )
                    : Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: IconTheme(
                          data: IconThemeData(color: Colors.blue[400]),
                          child: IconButton(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              onPressed: isWriting
                                  ? () =>
                                      _handleSubmit(textEditingController.text)
                                  : null,
                              icon: const Icon(Icons.send)),
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
    if (text.isEmpty) return;
    _focusNode.requestFocus();
    textEditingController.clear();
    final chatMessage = ChatMessage(
      text: text,
      uid: '123',
      animatedContainer: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 500)),
    );
    list.insert(0, chatMessage);
    chatMessage.animatedContainer.forward();
    setState(() {
      isWriting = false;
    });
  }

  @override
  void dispose() {
    // off del socket
    for (ChatMessage message in list) {
      message.animatedContainer.dispose();
    }
    super.dispose();
  }
}
