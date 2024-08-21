/*
基于WebsocketServerManager的chat聊天实现
 */
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import '../../../module/common/NotificationInApp.dart';
import '../../../module/common/enum.dart';
import '../../../module/manager/GlobalManager.dart';
import '../../../service/server/common/CommunicationTypeServerModulator.dart';
import '../../../service/server/model/ClientModel.dart';
import '../../../service/server/model/ErrorModel.dart';
import '../../../service/server/module/ServerWebsocketModule.dart';
import '../../../service/server/websocket/WebsocketServer.dart';
import '../../../service/server/websocket/WebsocketServerManager.dart';
import '../common/serverTool.dart';
import '../model/AppConfigModel.dart';
import '../module/AppModule.dart';

class UiWebsocketServer extends ServerWebsocketModule {
  // 实例化WebsocketServerManager
  WebsocketServerManager websocketServerManager = WebsocketServerManager();
  CommunicationTypeServerModulator communicationTypeServerModulator =
      CommunicationTypeServerModulator();
  AppModule appModule = AppModule();
  NotificationInApp notificationInApp = NotificationInApp();
  ServerUiTool serverUiTool = ServerUiTool();

  UiWebsocketServer() {
    // 实例化配置类
    AppConfigModel? appConfigModel = appModule.getAppConfig();
    if (appConfigModel == null) {
      // 出错
      printError("应用配置类实例化出错！");
      notificationInApp.errorToast("应用配置类实例化出错！".tr());
    } else {
      printSuccess("应用配置: ${appConfigModel.toJson()}");
      // 调用配置参数函数
      websocketServerManager.setConfig(
          // server绑定ip地址
          ip: InternetAddress.anyIPv4,
          // server绑定端口port
          port: appConfigModel.websocketPort,
          //******配置周期性回调函数***********
          // 1.启动前的初始化操作
          initial: initial,
          // 2.当server绑定地址成功后调用
          whenServerBindAddrSuccess: whenServerBindAddrSuccess,
          // 3.当client连接成功时调用
          whenClientConnSuccess: whenClientConnSuccess,
          // 4.当存在client断开与server连接时调用
          whenHasClientConnInterrupt: whenHasClientConnInterrupt,
          // 5.当出现异常或错误时调用：错误类型见ErrorType枚举类型
          whenServerError: whenServerError,
          // 消息处理调用
          handlerMessage: handlerMessage);
    }
  }

  //******配置周期性回调函数***********
  /*
  1.启动前的初始化操作
   */
  initial(WebSocketServer webSocketServer) {
    printInfo("initial handler");
  }

  /*
   2.当server绑定地址成功后调用
   */
  whenServerBindAddrSuccess(WebSocketServer webSocketServer) {
    printInfo("bind addr is successful to handler");
    // 停止旋转
    GlobalManager.globalControl.stop();
    // 改变bootServer ui
    appModule.setIsRunningInHive(true);
  }

  /*
   3.当client连接成功时调用
   */
  whenClientConnSuccess(HttpRequest request, WebSocket webSocket) {
    printInfo("client connect is successful ");

    // 添加进全局变量中: 所有连接过的
    /// 1.封装clientObject对象
    ClientModel clientObject = ClientModel(
      deviceId: null, // 唯一标识符: 该
      socket: webSocket, // socket对象
      ip: request.connectionInfo!.remoteAddress.address
          .toString(), // 客户端client ip
      port: request.connectionInfo!.remotePort.toInt(),
      retryConnCount: 0, // 客户端client port
      // secret: secret // 认证秘钥
    );
    GlobalManager.allConnectedClientList
        .add(clientObject); // 运行期间添加进存在过连接的所有client客户端对象
  }

  /*
   4.当存在client断开与server连接时调用
   */
  whenHasClientConnInterrupt(HttpRequest request, WebSocket webSocket) {
    //****************连接中断处理逻辑**************
    // 客户端信息
    String? ip = request.connectionInfo?.remoteAddress.address.toString();
    int? port = request.connectionInfo?.remotePort.toInt();
    GlobalManager.onlineClientList.removeWhere((clientObject) {
      if (clientObject.socket == webSocket ||
          (clientObject.ip == ip && clientObject.port == port)) {
        // 找到
        // 提示
        notificationInApp.showErrorModel(
            titleText: "disconnect",
            messageText:
                "disconnect with ${clientObject.ip}:${clientObject.port}");
        printInfo(
            "disconnect:disconnect with ${clientObject.ip}:${clientObject.port} ");
        return true;
      }
      return false;
    }); //在线连接
    GlobalManager.allConnectedClientList =
        GlobalManager.allConnectedClientList.map((clientObject) {
      // 找出对应存储的client
      if (clientObject.socket == webSocket) {
        // 更改信息
        clientObject..connected = false;
        // 增加断线重连次数
        clientObject.retryConnCount += 1;
        // 更改最近一次断线时间
        clientObject.disconnRecentTime = DateTime.now();
        // 消息队列依然保存，作为离线存储未接受消息

        return clientObject;
      }

      return clientObject;
    }).toList();

    // 广播在线client
    broadcastInlineClients();
    // 更新在线数
    serverUiTool.updateShowInfo();
  }

  /*
   5.当出现异常或错误时调用：错误类型见ErrorType枚举类型
   */
  whenServerError(WebSocketServer webSocketServer, ErrorObject errorObject) {
    printInfo("exist server error ");
    printInfo("$errorObject");
    if (errorObject.type == ErrorType.websocketServerBoot) {
      // 启动server失败
      // 停止旋转
      GlobalManager.globalControl.stop();
      // 改变bootServer ui
      appModule.setIsRunningInHive(true);
      // 断线重连

      if (appModule.getRetryInHive() &&
          (appModule.getMaxRetryInHive() -
                  GlobalManager.globalServerBootCount++) >=
              0) {
        // ok
        bootServer();
        // UI提示
        notificationInApp.motionSuccessToast(
            titleText: "boot server", messageText: "the server is booted");
        printInfo("boot server the server is booted");
      }
    }

    // 更新
    serverUiTool.updateShowInfo();
    // 提示
    notificationInApp.showErrorModel(
        titleText: errorObject.type.toString(),
        messageText: errorObject.content!);
  }

  /*
   消息处理调用
   */
  handlerMessage(HttpRequest request, WebSocket webSocket, Map message) {
    // 第一层处理:调用调制器函数处理事先定义好的不同类型消息处理类
    communicationTypeServerModulator.handler(
        request, webSocket, websocketServerManager, message);

    // 第二层处理
  }

  /*
  启动server
   */
  bootServer() {
    printWarn(
        "=================handler websocket server procedure=======================");
    websocketServerManager.boot();

    // 更新在线数
    serverUiTool.updateShowInfo();
  }

  /*
  关闭server
   */
  closeServer() {
    printInfo("close the websocket server");

    // 清空
    GlobalManager.onlineClientList = [];
    //
    broadcastInlineClients();
    //清空
    GlobalManager.onlineClientList.clear();
    websocketServerManager.stop();
    // 更新
    serverUiTool.updateShowInfo();
  }
}
