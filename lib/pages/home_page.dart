import 'package:demo10_websocket/socket/websocket_manager.dart';
import 'package:flutter/material.dart';

import '../protocol/message_proto.pb.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  startConnect() async {
    debugPrint("====> 发起连接。。。。");
    WebsocketManager.init();
    await WebsocketManager().connect();
    WebsocketManager().channel.stream.listen((msg) {
      var message = MessageProto.fromBuffer(msg);
      debugPrint("from server message: ${message.content}");
    });
  }

  sendMessage() async {
    debugPrint("====> 开始发送新消息....");
    var msg = MessageProto();
    msg.content = "hhhhhhyhhhh";
    msg.fromId = "4444";
    msg.roomId = '2222';
    WebsocketManager().send(msg.writeToBuffer());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Netty Demo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: startConnect,
              child: const Text("发起连接"),
            ),
            ElevatedButton(
              onPressed: sendMessage,
              child: const Text("发送消息内容"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
