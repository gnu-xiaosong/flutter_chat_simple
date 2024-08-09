/*
单例设计： websocketClient
 */
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../module/common/enum.dart';
import '../../../module/common/unique_device_id.dart';
import '../../../module/manager/GlobalManager.dart';
import '../../server/model/ErrorModel.dart';
import '../common/CommunicationTypeClientModulator.dart';
import '../module/ClientWebsocketModule.dart';
import 'WebsocketClient.dart';
import 'WebsocketClientManager.dart';

class ChatWebsocketClient extends ClientWebsocketModule {
  WebsocketClientManager websocketClientManager =
      WebsocketClientManager.getInstance();
  CommunicationTypeClientModulator communicationTypeClientModulator =
      CommunicationTypeClientModulator();

  ChatWebsocketClient(
      {required String ip, required int port, String type = "ws"}) {
    // 配置参数
    websocketClientManager.setConfig(
        ip: ip,
        port: port,
        type: type,
        initialBeforeConn: initialBeforeConn,
        whenConnInterrupt: whenConnInterrupt,
        whenConnSuccessWithServer: whenConnSuccessWithServer,
        messageHandler: messageHandler,
        whenClientError: whenClientError);
  }

  /*
  在连接server前的初始化操作
   */
  initialBeforeConn(WebsocketClient websocketClient) {
    print("initial handler");
  }

  /*
  当与server连接中断时
   */
  whenConnInterrupt(WebsocketClient websocketClient) {
    print("conn server is disconnected!");
  }

  /*
  当与server端连接成功时
   */
  whenConnSuccessWithServer(
      WebsocketClientManager websocketClientManager) async {
    printSuccess("conn server is successful");
    // 设备唯一标识:为了防止安全可以在之前进行安全性检查
    String deviceId = GlobalManager.deviceId.toString() ??
        (await UniqueDeviceId.getDeviceUuid());

    // 发起AUTH认证
    String plait_text = "I am websocket client that want to authenticate";
    String key = deviceId.toString();

    // 发起身份认证
    Map auth_req = {
      "type": "AUTH",
      "deviceId": deviceId,
      "info": {
        "plait_text": plait_text,
        "key": key,
        "encrypte": generateMd5Secret(key + plait_text)
      }
    };
    // print("-------------------auth encode---------------");
    // 消息加密:采用AUTH级别
    auth_req["info"] = encodeAuth(auth_req["info"]);

    // 发送
    try {
      printInfo(">> send: $auth_req");
      websocketClientManager.sendText(json.encode(auth_req));
    } catch (e) {
      printError("-ERR:发送AUTH认证失败!请重新发起认证，连接将中断!");
      // 认证身份异常
      ErrorObject errorObject = ErrorObject(
          type: ErrorType.auth,
          content: "发送AUTH认证失败!请重新发起认证，连接将中断! 详情: ${e.toString()}");
      // 异常处理
      whenClientError(errorObject);
      // 关闭连接
      websocketClientManager.close();
    }
  }

  /*
  消息处理程序
   */
  messageHandler(WebSocketChannel webSocketChannel, Map message) {
    print("+message hanlder");
    // 调用处理程序
    communicationTypeClientModulator.handler(websocketClientManager, message);
  }

  /*
  错误处理程序
   */
  whenClientError(ErrorObject errorObject) {
    print("client error: $errorObject");
  }

  /*
  启动连接server
   */
  connServer() {
    print("connecting server.......");
    websocketClientManager.conn();
  }
}
