/*
  离线消息队列处理类: 客户端
 */
import 'package:app_template/microService/service/server/module/ServerWebsocketModule.dart';
import '../../../../module/common/Console.dart';
import '../../../../module/manager/GlobalManager.dart';

class WaitAgreeUserAddClientHandler extends ServerWebsocketModule with Console {
  // 等待好友申请消息队列开关:
  bool isWaitAgreeUserAdd = true;

  // 将消息进入等待好友申请队列中
  bool enAgreeUserAddQueue(String sendDeviceId, Map enMsgMap) {
    /*
    参数说明:data  Map
    sendDeviceId  string 发送者设备唯一性id
    enMsgMap   map    待发送消息  已加密
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
    // 进入等待好友申请消息队列中
    try {
      offLine.enOffLineQueue(sendDeviceId, "addUser", enMsgMap);
      printSuccess("msg进入等待好友申请消息队列成功! data=$enMsgMap");
      printSuccess(
          "OffLineQueue length=${GlobalManager.offLineMessageQueue.length}");
      return true;
    } catch (e) {
      printCatch("msg进入等待好友申请消息队列失败!, more detail: $e");
      return false;
    }
  }
}