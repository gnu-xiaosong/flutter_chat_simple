/*
websocket client 模块 ：处理有关client websocket有关逻辑
 */
import '../../../../database/daos/ChatDao.dart';
import '../../../module/DAO/UserChat.dart';
import '../../../module/DAO/common.dart';
import '../../../module/common/BroadcastModule.dart';
import '../../../module/common/CommonModule.dart';
import '../../../module/encryption/MessageEncrypte.dart';

class ClientWebsocketModule extends MessageEncrypte {
  // 子类继承共享
  UserChat userChat = UserChat();
  CommonModel commonModel = CommonModel();
  ChatDao chatDao = ChatDao();
  BroadcastModule broadcastModule = BroadcastModule();
  CommonDao commonDao = CommonDao();

  /*
   client与server中断处理策略
   */
  void interruptRetryStrategy() {
    // Your retry strategy logic here
  }
}
