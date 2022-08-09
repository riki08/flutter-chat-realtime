import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_time_chat/models/mensaje_response.dart';
import 'package:real_time_chat/services/auth_service.dart';
import 'package:real_time_chat/services/chat_service.dart';
import 'package:real_time_chat/services/socket_service.dart';
import 'package:real_time_chat/widgets/chat_message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final TextEditingController textEditingController = TextEditingController();
  final _focusNode = FocusNode();
  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;
  bool isWriting = false;
  List<ChatMessage> list = [];

  @override
  void initState() {
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);
    socketService.socket.on('mensaje-personal', _lisenMessage);

    _cargarHistorial(chatService.userTo.uid);

    super.initState();
  }

  void _cargarHistorial(userId) async {
    List<Last30> chat = await chatService.getChat(userId);

    final history = chat.map(
      (m) => ChatMessage(
          text: m.mensaje,
          uid: m.de,
          animatedContainer: AnimationController(
              vsync: this, duration: const Duration(milliseconds: 0))
            ..forward()),
    );

    setState(() {
      list.insertAll(0, history);
    });

    print(chat);
  }

  void _lisenMessage(dynamic payload) {
    ChatMessage message = ChatMessage(
        text: payload['mensaje'],
        uid: payload['de'],
        animatedContainer: AnimationController(
            vsync: this, duration: const Duration(milliseconds: 300)));

    setState(() {
      list.insert(0, message);
    });
    message.animatedContainer.forward();
  }

  @override
  Widget build(BuildContext context) {
    final user = chatService.userTo;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              maxRadius: 15,
              backgroundColor: Colors.blueAccent,
              child: Text(
                user.nombre!.substring(0, 2),
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              user.nombre!,
              style: const TextStyle(color: Colors.black87, fontSize: 12),
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
      uid: authService.user.uid!,
      animatedContainer: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 500)),
    );
    list.insert(0, chatMessage);
    chatMessage.animatedContainer.forward();
    setState(() {
      isWriting = false;
    });
    socketService.emit('mensaje-personal', {
      'de': authService.user.uid,
      'para': chatService.userTo.uid,
      'mensaje': text
    });
  }

  @override
  void dispose() {
    // off del socket
    for (ChatMessage message in list) {
      message.animatedContainer.dispose();
    }
    socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}
