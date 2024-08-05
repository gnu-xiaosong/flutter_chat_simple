/*
websocket  server与client通讯 自定义消息处理类: TEST消息类型
 */
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import '../../../../module/manager/GlobalManager.dart';
import '../../common/CommunicationTypeClientModulator.dart';
import '../WebsocketClientManager.dart';
import 'TypeMessageClientHandler.dart';

class AuthTypeMessageHandler extends TypeMessageClientHandler {
  MsgType type = MsgType.AUTH;

  void handler(
      WebsocketClientManager websocketClientManager, Map msgDataTypeMap) {
    // 解密info字段
    msgDataTypeMap["info"] = decodeAuth(msgDataTypeMap["info"]);
    //处理逻辑
    auth(websocketClientManager, msgDataTypeMap);
  }

  /*
    客户端client 第一次请求认证服务端server
   */
  void auth(WebsocketClientManager websocketClientManager, Map msgDataTypeMap) {
    // 打印消息
    printInfo("--------------AUTH TASK HANDLER--------------------");
    printInfo(">> receive: $msgDataTypeMap");

    try {
      if (int.parse(msgDataTypeMap["info"]["code"]) == 200) {
        // 认证成功
        printSuccess("+INFO: ${msgDataTypeMap["info"]["msg"]}");
        // 存储通讯秘钥secret
        String secret = msgDataTypeMap["info"]["secret"].toString();
        GlobalManager.appCache.setString("chat_secret", secret);
      } else {
        // 扫描失败
        printFaile("-FAILURE: ${msgDataTypeMap["info"]["msg"]}");
      }
    } catch (e) {
      // 非法字段
      printCatch(
          "-ERR: ${e.toString()} server is not authed! this conn will interrupt!");
      websocketClientManager.close();
    }
    //************************其他处理: 记录日志等******************************
  }
}
