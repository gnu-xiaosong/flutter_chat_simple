/*
websocket  server与client通讯 消息处理基类
 */
import '../../../../module/common/NotificationInApp.dart';
import '../../module/ClientWebsocketModule.dart';
import '../../../../ui/common/module/ExceptionUiModule.dart';

class TypeMessageClientHandler extends ClientWebsocketModule
    with ExceptionUiModule {
  NotificationInApp notificationInApp = NotificationInApp();

  /*
  消息加密方法
   */
  Map enSecretMessage(String keySecret, Map<dynamic, dynamic> dataMap) {
    // 将dataMap转换为Map<String, dynamic>
    Map<String, dynamic> stringKeyMap =
        dataMap.map((key, value) => MapEntry(key.toString(), value));

    // 解密info字段
    Map? decryptedData = encodeMessage(keySecret, stringKeyMap);

    if (decryptedData != null) {
      return decryptedData;
    } else {
      // 如果解密失败，返回原始的数据
      return stringKeyMap;
    }
  }

  /*
  消息解密方法
   */
  Map deSecretMessage(String keySecret, Map<dynamic, dynamic> dataMap) {
    // 将dataMap转换为Map<String, dynamic>
    Map<String, dynamic> stringKeyMap =
        dataMap.map((key, value) => MapEntry(key.toString(), value));

    // 解密info字段
    Map? decryptedData = decodeMessage(keySecret, stringKeyMap);

    if (decryptedData != null) {
      return decryptedData;
    } else {
      // 如果解密失败，返回原始的数据
      return stringKeyMap;
    }
  }
}
