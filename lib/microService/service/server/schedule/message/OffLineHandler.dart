/*
  离线消息队列处理类
 */

import 'dart:convert';
import '../../../../module/common/Console.dart';
import '../../../../module/common/tools.dart';
import '../../../../module/common/unique_device_id.dart';
import '../../../../module/manager/GlobalManager.dart';
import '../../../client/common/tool.dart';
import '../../model/ClientModel.dart';
import '../../../../module/encryption/MessageEncrypte.dart';

class OffLine extends MessageEncrypte with Console, CommonTool, ClientTool {
  // 离线消息队列开关
  bool isOffLine = true;

  /*
  将消息进入离线消息队列中
   */
  Future<bool> enOffLineQueue(String deviceId, String type, Map message) async {
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
    printInfo(
        "OffLine msg counts: ${GlobalManager.offLineMessageQueue.length}");
    while (length-- > 0) {
      printInfo("msg index=$length");
      // 获取当前出队列msg
      Map? msg = GlobalManager.offLineMessageQueue.dequeue();

      // 临时
      Map? tmpMsg = msg;

      // **********切换secret进行文本的加密**********
      String deviceId = msg?["deviceId"]; // 仅仅离线模式才有该字段,发送者
      printInfo("Offline Msg Type: ${msg?["msg_map"]['type']}");
      printInfo("before Content msg: $tmpMsg");
      // 存储解密
      ClientModel? clientObject = getClientObjectByDeviceId(deviceId);
      tmpMsg?["msg_map"]["info"] =
          decodeMessage(clientObject!.secret!, tmpMsg["msg_map"]["info"]);
      printInfo("Content msg: $tmpMsg");

      if (clientObject == null) {
        printWarn("=============不在线====================");
        // 如果接受者仍然不在线则将该消息重新添加进队列中
        GlobalManager.offLineMessageQueue.enqueue(msg!);
      } else {
        printWarn("=============在线====================");
        // 如果在线添加进入消息矩阵消息队列中
        GlobalManager.onlineClientList =
            GlobalManager.onlineClientList.map((clientObject) {
          // 寻找目标clientObject
          if (clientObject.deviceId == deviceId) {
            // 算法加密:使用接收者加密秘钥
            Map itemMsg = tmpMsg?["msg_map"];
            printWarn("标记前: $itemMsg");
            itemMsg["info"] =
                encodeMessage(clientObject.secret!, itemMsg["info"]);

            printWarn("标记后: $itemMsg");
            // 根据离线消息类型处理
            switch (tmpMsg?['type']) {
              // 消息
              case "message":
                // 进入消息队列
                clientObject.messageQueue.enqueue(itemMsg);
                break;
              // 请求添加好友
              case "addUser":
                // 进入消息队列: 其中de_map为明文
                clientObject.awaitAddFriendsQueue.enqueue(itemMsg);
                break;
            }
          }
          return clientObject;
        }).toList();
      }
    }

    if (length == 0) {
      printInfo(" 离线消息队列为空!");
    }
  }
}
