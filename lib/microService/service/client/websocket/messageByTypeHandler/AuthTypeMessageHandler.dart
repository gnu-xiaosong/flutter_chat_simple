/*
websocket  server与client通讯 自定义消息处理类: TEST消息类型
 */
import 'package:socket_service/microService/module/common/enum.dart';
import 'package:socket_service/microService/service/server/model/ErrorModel.dart';
import '../../../../ui/client/module/AppSettingModule.dart';
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
        AppClientSettingModule().setSecretInHive(secret);
        // UI提示
        notificationInApp.motionSuccessToast(
            titleText: "conn success",
            messageText: "connect server is success and pass auth!");
      } else {
        // 扫描失败
        printFaile("-FAILURE: ${msgDataTypeMap["info"]["msg"]}");
        // 封校错误消息体
        ErrorObject errorObject = ErrorObject(
          type: ErrorType.auth,
          content: msgDataTypeMap["info"]["msg"],
        );
        // 调用全局错误处理程序
        failureHandler(errorObject);
      }
    } catch (e) {
      // 非法字段
      printCatch(
          "-ERR: ${e.toString()} server is not authed! this conn will interrupt!");
      // 封校错误消息体
      ErrorObject errorObject = ErrorObject(
        type: ErrorType.auth,
        content: "server is not authed! this conn will interrupt!",
      );
      // 调用全局错误处理程序
      catchHandler(errorObject);
      websocketClientManager.close();
    }
    //************************其他处理: 记录日志等******************************
  }
}
