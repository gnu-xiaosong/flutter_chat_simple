/*
公共函数库
 */

import '../manager/GlobalManager.dart';

class CommonModel {
  /*
  去除已经掉线的
   */
  void removeOfflineDevices(List<String> commonList) {
    List<String> keysToRemove = [];

    // 收集需要移除的键
    GlobalManager.userMapMsgQueue.forEach((deviceId, queue) {
      if (!commonList.contains(deviceId)) {
        keysToRemove.add(deviceId);
      }
    });

    // 移除并处理这些键
    for (var deviceId in keysToRemove) {
      GlobalManager.userMapMsgQueue[deviceId]?.clear();
      GlobalManager.userMapMsgQueue.remove(deviceId);
    }
  }
}
