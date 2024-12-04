/*
websocket  server与client通讯 自定义消息处理类: TEST消息类型
 */

import 'package:web_socket_channel/web_socket_channel.dart';
import '../../common/CommunicationTypeClientModulator.dart';
import '../WebsocketClientManager.dart';
import 'TypeMessageClientHandler.dart';

class GroupTypeMessageHandler extends TypeMessageClientHandler {
  // 群聊通讯消息模块
  MsgType type = MsgType.GROUP;
  void handler(
      WebsocketClientManager websocketClientManager, Map msgDataTypeMap) {
    //处理逻辑
  }
}
