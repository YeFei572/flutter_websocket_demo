import 'dart:async';
import 'dart:typed_data';

import 'package:demo10_websocket/constant/constant.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum StatusEnum { connect, connecting, close, closing }

class WebsocketManager {
  static late WebsocketManager _singleton;

  factory WebsocketManager() => _singleton;

  WebsocketManager._();

  late WebSocketChannel channel;

  StreamController<StatusEnum> socketStatusController =
      StreamController<StatusEnum>();

  static void init() async {
    _singleton = WebsocketManager._();
  }

  // 默认连接是关闭状态
  StatusEnum isConnect = StatusEnum.close;

  // 发起连接
  Future<WebSocketChannel> connect() async {
    if (isConnect == StatusEnum.close) {
      isConnect = StatusEnum.connecting;
      socketStatusController.add(StatusEnum.connecting);
      channel = IOWebSocketChannel.connect(Uri.parse(Constant.wsUrl));
      isConnect = StatusEnum.connect;
      socketStatusController.add(StatusEnum.connect);
      return channel;
    }
    return channel;
  }

  /// 终止连接
  Future<void> disconnect() async {
    if (isConnect == StatusEnum.connect) {
      isConnect = StatusEnum.closing;
      socketStatusController.add(StatusEnum.closing);
      await channel.sink.close(3000, '主动关闭');
      isConnect = StatusEnum.close;
      socketStatusController.add(StatusEnum.close);
    }
  }

  /// 发送消息
  bool send(Uint8List msg) {
    if (isConnect == StatusEnum.connect) {
      channel.sink.add(msg);
      return true;
    }
    return false;
  }
}
