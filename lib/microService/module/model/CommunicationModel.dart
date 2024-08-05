/*
websocket通讯交流实体类
 */

import '../../service/client/common/CommunicationTypeClientModulator.dart';
import 'Model.dart';

class CommunicationModel extends Model {
  // type属性
  MsgType type;

  // info对象
  dynamic info;

  CommunicationModel({this.type = MsgType.MESSAGE, required this.info});

  /*
  重载转化为字符传输json
   */
  Map toJson() {
    Map jsonMap = {
      "type": stringByMsgType[type as MsgType].toString(),
      "info": info.toJson()
    };

    return jsonMap;
  }
}
