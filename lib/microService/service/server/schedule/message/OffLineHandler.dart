/*
  离线消息队列处理类
 */
import 'dart:convert';

import 'package:uuid/uuid.dart';

import '../../../../module/common/Console.dart';
import '../../../../module/common/tools.dart';
import '../../../../module/manager/GlobalManager.dart';
import '../../../client/common/tool.dart';
import '../../../store/OffMessageDateStore.dart';
import '../../model/ClientModel.dart';
import '../../../../module/encryption/MessageEncrypte.dart';
import '../../model/OffLineDataModel.dart';
import '../../queues/OffDataStoreQueue.dart';
import 'MessageQueueTask.dart';

class OffLine extends MessageEncrypte with Console, CommonTool, ClientTool {
  // 离线消息队列开关
  bool isOffLine = true;

  /*
  将消息进入离线消息队列中
   */
  bool enOffLineQueue(String deviceId, OffLineType type, Map message) {
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
        Map<String, dynamic> offMessage = {
          "id": const Uuid().v4(),
          "type": type.index, // 离线消息类型
          "deviceId": deviceId,
          "content": message
        };
        // 进入离线消息队列中
        OffDataStoreQueue offDataStoreQueue = OffDataStoreQueue();

        // 枚举转化为int
        offDataStoreQueue.enqueue(offMessage);

        printSuccess(
            "加入离线消息成功! 存储在本地中的离校消息列表: ${OffMessageDateStore.getPluginListInHive()}");
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
    OffDataStoreQueue offDataStoreQueue = OffDataStoreQueue();
    printInfo("---------Handler Offline Message Queue----------");
    int length = offDataStoreQueue.length;
    print("消息数: ${length}");
    // 循环执行离线消息队列
    while (length-- > 0) {
      // 获取消息
      OffLineDataModel? offLineDataModel = offDataStoreQueue.dequeue();

      // 排除为空的
      try {
        Map<String, dynamic> tmp = Map.from(offLineDataModel!.toMap());

        Map<String, dynamic>? tmp1 =
            Map.from(offLineDataModel.toMap()["content"]);
        // 算法解密: 使用本机特征deviceId解密
        tmp1["info"] = decodeMessage(
            GlobalManager.deviceId!, Map<String, dynamic>.from(tmp1["info"]));

        print("解密后: ${tmp1}");
        // 获取对象判断是否在线
        String receiveDeviceId = tmp1["info"]["recipient"]["id"];

        ClientModel? recipientClient =
            getClientObjectByDeviceId(receiveDeviceId);
        if (recipientClient != null &&
            recipientClient.connected &&
            recipientClient.passAuth) {
          // 加密
          tmp1["info"] = encodeMessage(recipientClient.secret!, tmp1["info"]);
          // 发送消息
          recipientClient.socket.add(jsonEncode(tmp1));
        } else {
          // 不在线：重新进入离线消息队列
          offDataStoreQueue.enqueue(tmp);
        }
      } catch (e) {
        printError("数据加密失败!");
      }
    }
  }
}
