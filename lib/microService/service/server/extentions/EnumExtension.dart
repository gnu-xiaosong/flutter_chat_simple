import '../common/CommunicationTypeServerModulator.dart';

extension MsgTypeEnumExtension on MsgType {
  // 获取枚举个数
  static int get count => MsgType.values.length;

  static List get labelList => _getMsgTypeLabelList();

  /*
  获取枚举类别列表
   */
  static List _getMsgTypeLabelList() {
    List name = [];
    stringByMsgType.forEach((key, value) {
      name.add(value);
    });
    return name;
  }
}
