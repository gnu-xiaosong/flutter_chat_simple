/*
  离线消息队列处理类
 */
import 'dart:convert';

import '../../../../module/common/Console.dart';
import '../../../../module/common/tools.dart';
import '../../../../module/manager/GlobalManager.dart';
import '../../../client/common/tool.dart';
import '../../model/ClientModel.dart';
import '../../../../module/encryption/MessageEncrypte.dart';
import 'MessageQueueTask.dart';

class OffLine extends MessageEncrypte with Console, CommonTool, ClientTool {
  // 离线消息队列开关
  bool isOffLine = true;

  /*
  将消息进入离线消息队列中
   */
  bool enOffLineQueue(String deviceId, String type, Map message) {
    /*
    参数说明:data  Map
    deviceId  string 发送者设备唯一性id
    msg_map   map    待发送消息  已加密
         必要字段:
          {
             "type":"",
             "info":{
                   "recipient":{
                      "id":"设备唯一性ID"
                      .......
                   },
                   ........
              }
          }
     */
    // 进入离线消息队列中
    try {
      // 获取clientObject
      ClientModel? clientObject = getClientObjectByDeviceId(deviceId);
      if (clientObject != null) {
        // 封装离线消息队列Map: deviceId为发送者  msg_map已加密
        Map offMessage = {
          "type": type, // 离线消息类型：
          "deviceId": deviceId,
          "msg_map": message
        };

        // 进入离线消息队列中
        GlobalManager.offLineMessageQueue.enqueue(offMessage);
        print("-----result----------");
        GlobalManager.offLineMessageQueue.queueToList().map((e) {
          printWarn("消息: ${e}");
        });
        return true;
      } else {
        // 未发现sender clientObject
        printError("发生程序性错误!未发现sender clientObject!");
        return false;
      }
    } catch (e) {
      printCatch(" msg进入离线消息队列失败!, more detail: $e");
      return false;
    }
  }

  /*
  执行离线消息队列
   */
  void offLineHandler() {
    printInfo("---------Handler Offline Message Queue----------");
    int length = GlobalManager.offLineMessageQueue.length;
    print("消息数: ${length}");
    // 循环执行离线消息队列
    while (length-- > 0) {
      // 获取消息
      Map? enmsg = GlobalManager.offLineMessageQueue.dequeue();

      // 排除为空的
      try {
        Map tmp = Map.from(enmsg!);

        // 解密消息
        ClientModel? senderClient =
            getClientObjectByDeviceId(enmsg["deviceId"]);
        printWarn("未解密:${enmsg["msg_map"]}");
        enmsg["msg_map"]["info"] =
            decodeMessage(senderClient!.secret!, enmsg["msg_map"]["info"]);
        print("解密后: ${enmsg["msg_map"]}");
        // 获取对象判断是否在线
        String receiveDeviceId = enmsg?["msg_map"]["info"]["recipient"]["id"];
        ClientModel? recipientClient =
            getClientObjectByDeviceId(receiveDeviceId);
        if (recipientClient != null &&
            recipientClient.connected &&
            recipientClient.passAuth) {
          // 加密
          enmsg["msg_map"]["info"] =
              encodeMessage(recipientClient.secret!, enmsg["msg_map"]["info"]);
          // 发送消息
          recipientClient.socket.add(jsonEncode(enmsg["msg_map"]));
        } else {
          // 不在线：重新进入离线消息队列
          GlobalManager.offLineMessageQueue.enqueue(tmp);
        }
      } catch (e) {
        printError("数据加密失败!");
      }
    }
  }
}
