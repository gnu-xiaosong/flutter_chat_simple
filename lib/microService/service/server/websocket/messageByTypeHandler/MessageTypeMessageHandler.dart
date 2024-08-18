/*
websocket  server与client通讯 自定义消息处理类: TEST消息类型
 */

import 'dart:convert';
import 'dart:io';
import '../../model/ClientModel.dart';
import '../../../../module/manager/GlobalManager.dart';
import '../../common/CommunicationTypeServerModulator.dart';
import '../../model/OffLineDataModel.dart';
import '../WebsocketServerManager.dart';
import 'TypeMessageServerHandler.dart';

class MessageTypeMessageHandler extends TypeMessageServerHandler {
  // 消息类型：枚举类型
  MsgType type = MsgType.MESSAGE;

  /*
  调用函数: 在指定type来临时自动调用处理
   */
  void handler(HttpRequest request, WebSocket webSocket,
      WebsocketServerManager websocketServerManager, Map msgDataTypeMap) {
    // 调用处理函数
    message(request, webSocket, msgDataTypeMap);

    // 处理离线消息
    offLine.offLineHandler();

    // 被动调用bus Queue总消息队列任务
    messageQueueTask.execOnceWebsocketServerMessageBusQueueScheduleTask();
  }

  /*
    消息类型
   */
  void message(HttpRequest request, WebSocket webSocket, Map msgDataTypeMap) {
    // 获取ClientObject
    ClientModel clientObject = getClientObject(request, webSocket);
    // 获取秘钥通讯加解密key
    String secret = clientObject.secret.toString();
    // 解密info字段
    msgDataTypeMap["info"] = deSecretMessage(secret, msgDataTypeMap["info"]);

    // 1.客户端验证检查: deviceId为发送者的设备id，认证该client是否存在于全局在线list ClientObject中
    Map clientCheck =
        clientAuth(msgDataTypeMap["info"]["sender"]["id"], request, webSocket);

    // 判断接受者是否在线进入离线消息队列
    String receiveDeviceId = msgDataTypeMap["info"]["recipient"]["id"];

    if (clientCheck["result"]) {
      // 2.如果认证成功，将该消息添加进client的消息队列中
      print("ip: ${request.connectionInfo?.remoteAddress.address}");
      print("length:${GlobalManager.onlineClientList.length}");

      ClientModel? receiveClientObject =
          getClientObjectByDeviceId(receiveDeviceId);
      if (receiveClientObject != null) {
        // 在线
        GlobalManager.onlineClientList =
            GlobalManager.onlineClientList.map((websocketClientObj) {
          // print("weboscket: ${websocketClientObj.ip}");
          if (websocketClientObj.socket == webSocket ||
              request.connectionInfo?.remoteAddress.address ==
                  websocketClientObj.ip) {
            printInfo("----------------中断处理：找到了目标websocket----------------");
            // 算法加密
            msgDataTypeMap["info"] = encodeMessage(
                websocketClientObj.secret!, msgDataTypeMap["info"]);

            //添加新消息进入消息队列中
            websocketClientObj.messageQueue.enqueue(msgDataTypeMap);

            // 返回
            return websocketClientObj;
          } else {
            // 返回原来的
            return websocketClientObj;
          }
        }).toList();
      } else {
        // 排除为空的
        try {
          print("数据加密");
          // 算法加密: 使用本机特征deviceId加密
          msgDataTypeMap["info"] =
              encodeMessage(GlobalManager.deviceId!, msgDataTypeMap["info"]);
          //*******************不在线:进入离线消息队列,消息已经加密*******************
          printSuccess("进入消息队列后: $msgDataTypeMap");
          offLine.enOffLineQueue(
              clientObject.deviceId!, OffLineType.message, msgDataTypeMap);
          //*******************不在线:进入离线消息队列 *******************
        } catch (e) {
          printError("数据加密失败!");
        }
      }
    } else {
      // 3.1 客户端client检查失败返回数据相应给客户端
      Map re = {
        "type": "AUTH",
        "info": {"code": 400, "msg": clientCheck["result"]}
      };
      // 加密消息:采用auth加密
      re["info"] = encodeAuth(re["info"]);

      print(">> send:$re");
      // 发送消息
      webSocket.add(json.encode(re));
      // 主动关闭连接
      webSocket.close();
    }
  }
}
