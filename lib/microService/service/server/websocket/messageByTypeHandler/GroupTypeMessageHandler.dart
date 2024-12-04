/*
websocket  server与client通讯 自定义消息处理类: TEST消息类型
 */
import 'dart:io';
import '../../common/CommunicationTypeServerModulator.dart';
import '../WebsocketServerManager.dart';
import 'TypeMessageServerHandler.dart';

class GroupTypeMessageHandler extends TypeMessageServerHandler {
  // 消息类型：枚举类型 群聊模块
  MsgType type = MsgType.GROUP;

  /*
  调用函数: 在指定type来临时自动调用处理
   */
  void handler(HttpRequest request, WebSocket webSocket,
      WebsocketServerManager websocketServerManager, Map msgDataTypeMap) {
    //
  }
}
