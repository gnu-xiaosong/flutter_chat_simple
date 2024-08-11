/*
基于WebsocketClientManager的chat聊天实现
 */

import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../../module/common/enum.dart';
import '../../../module/manager/GlobalManager.dart';
import '../../../service/client/common/CommunicationTypeClientModulator.dart';
import '../../../service/client/module/ClientWebsocketModule.dart';
import '../../../service/client/websocket/WebsocketClient.dart';
import '../../../service/client/websocket/WebsocketClientManager.dart';
import '../../../service/server/model/ErrorModel.dart';
import '../../common/module/ExceptionUiModule.dart';
import '../model/AppSettingModel.dart';
import '../module/AppSettingModule.dart';

class UiWebsocketClient extends ClientWebsocketModule with ExceptionUiModule {
  WebsocketClientManager websocketClientManager =
      WebsocketClientManager.getInstance();
  CommunicationTypeClientModulator communicationTypeClientModulator =
      CommunicationTypeClientModulator();
  AppClientSettingModule appClientSettingModule = AppClientSettingModule();
  late AppClientSettingModel appClientSettingModel;

  UiWebsocketClient() {
    appClientSettingModel = appClientSettingModule.getAppConfig()!;
    // 配置参数
    websocketClientManager.setConfig(
        ip: appClientSettingModel.serverIp,
        port: appClientSettingModel.serverPort,
        type: appClientSettingModel.wsType,
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

    // 封装
    ErrorObject errorObject = ErrorObject(
        type: ErrorType.connWebsocketServer,
        content: "disconnected with server!");
    // UI提示: 异常处理
    failureHandler(errorObject);

    // 判断是否进行重连
    if (appClientSettingModule.getRetryInHive() &&
        (appClientSettingModule.getMaxRetryInHive() -
                GlobalManager.globalServerBootCount++) >=
            0) {
      // 连接server
      connServer();
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

    // UI提示: 异常处理
    errorHandler(errorObject);
  }

  /*
  连接server
   */
  connServer() {
    print("connecting server.......");
    websocketClientManager.conn();
  }

  /*
  当与server端连接成功时
   */
  whenConnSuccessWithServer(
      WebsocketClientManager websocketClientManager) async {
    printSuccess("conn server is successful");
    // *******************发起auth认证请求**************************
    // 获取认证加密信息
    Map authInfo = enMsgForClientAuth();
    // 发送请求认证
    // 发送
    try {
      printInfo(">> send: $authInfo");
      websocketClientManager.sendText(json.encode(authInfo));
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
}
