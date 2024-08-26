/*
websocket  server与client通讯 自定义消息处理类:FTP消息类型
 */
import 'dart:io';
import '../../common/CommunicationTypeServerModulator.dart';
import '../WebsocketServerManager.dart';
import 'TypeMessageServerHandler.dart';

class FtpTypeMessageHandler extends TypeMessageServerHandler {
  // 消息类型：枚举类型
  MsgType type = MsgType.FTP;

  /*
  调用函数: 在指定type来临时自动调用处理
   */
  void handler(HttpRequest request, WebSocket webSocket,
      WebsocketServerManager websocketServerManager, Map msgDataTypeMap) {
    //
  }
}
