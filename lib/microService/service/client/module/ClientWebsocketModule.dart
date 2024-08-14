/*
websocket client 模块 ：处理有关client websocket有关逻辑
 */
import 'package:socket_service/microService/ui/client/module/AppSettingModule.dart';
import '../../../../database/daos/ChatDao.dart';
import '../../../module/DAO/UserChat.dart';
import '../../../module/DAO/common.dart';
import '../../../module/common/BroadcastModule.dart';
import '../../../module/common/CommonModule.dart';
import '../../../module/encryption/MessageEncrypte.dart';
import '../../../module/manager/GlobalManager.dart';

class ClientWebsocketModule extends MessageEncrypte {
  // 子类继承共享
  UserChat userChat = UserChat();
  CommonModel commonModel = CommonModel();
  ChatDao chatDao = ChatDao();
  BroadcastModule broadcastModule = BroadcastModule();
  CommonDao commonDao = CommonDao();
  AppClientSettingModule appClientSettingModule = AppClientSettingModule();

  /*
   client与server中断处理策略
   */
  void interruptRetryStrategy() {
    // Your retry strategy logic here
  }

  /*
  client客户端认证加密请求
   */
  Map enMsgForClientAuth() {
    // 设备唯一标识:为了防止安全可以在之前进行安全性检查
    String deviceId = GlobalManager.deviceId.toString();
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

    return auth_req;
  }
}
