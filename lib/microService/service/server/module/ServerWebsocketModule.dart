/*
server 不同消息类型处理模块
 */
import 'dart:convert';
import 'package:app_template/microService/service/server/schedule/message/OffLineHandler.dart';
import '../../../module/encryption/MessageEncrypte.dart';
import '../../../module/manager/GlobalManager.dart';
import '../schedule/message/MessageQueueTask.dart';

class ServerWebsocketModule extends MessageEncrypte {
  // 全局变量：离线消息处理
  OffLine offLine = OffLine();
  MessageQueueTask messageQueueTask = MessageQueueTask();

  /*
  获取server在线用户:返回inline client deviceId list
   */
  List<String?> getInlineClient(String deviceId) {
    /// 不包括本身
    List<String?> deviceList = GlobalManager.onlineClientList
        .where((clientObject) {
          if (clientObject.deviceId != deviceId && clientObject.connected) {
            return true;
          }
          return false;
        })
        .map((clientObject) => clientObject.deviceId)
        .toList();

    return deviceList;
  }

  /*
   广播在线client用户
   */
  void broadcastInlineClients() {
    print("**************Broadcast Inline Clients*********************");
    // 获取在线的clientObject
    List deviceIdList = [];

    // 遍历clientObject
    for (var clientObject in GlobalManager.onlineClientList) {
      if (clientObject.connected && clientObject.status == 1) {
        deviceIdList.add(clientObject.deviceId.toString());
      }
    }

    // 数据封装
    Map msg = {
      "type": "BROADCAST_INLINE_CLIENT",
      "info": {"type": "list", "deviceIds": deviceIdList}
    };

    printInfo("inline Clients: ${msg}");
    // 广播发送
    for (var clientObject in GlobalManager.onlineClientList) {
      // 判断能够发送的client
      if (clientObject.connected && clientObject.status == 1) {
        // 数据加密: 暂时不加密，因为有bug
        // msg["info"] =
        //     messageEncrypte.encodeMessage(clientObject.secret, msg["info"]);
        // 发送
        clientObject.socket.add(json.encode(msg));
      }
    }
  }

  /*
   计算与该服务端连接的client的数量
   */
  Map? getClientsCount() {}

  /*
   server向所有在线client广播消息
   */
  void broadcast(String message) {
    printSuccess("broadcast msg to all client ! msg: ${message}");
    for (var client in GlobalManager.onlineClientList) {
      // 返回数据给client客户端
      client.socket.add(message);
    }
  }
}
