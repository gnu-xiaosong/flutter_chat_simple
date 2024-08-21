import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import '../../../module/common/NotificationInApp.dart';
import '../../../module/manager/GlobalManager.dart';
import '../../../module/plugin/storeData/ServerStoreDataPlugin.dart';
import '../../../service/store/LogDataStore.dart';

class ServerUiTool {
  void checkFileExists(String path) async {
    File file = File(path);
    bool exists = await file.exists();
    if (exists) {
      print('文件存在');
    } else {
      print('文件不存在');
    }
  }

  /*
  复制到粘贴板
   */
  void copyToClipboard(String text) async {
    try {
      // 将文本包装在ClipboardData对象中
      ClipboardData clipboardData = ClipboardData(text: text);
      NotificationInApp().successToast("copy successful!");
      // 使用Clipboard.setData方法将文本复制到剪贴板
      Clipboard.setData(clipboardData).then((_) {
        print("copy: ${text}");
        // 复制成功
        NotificationInApp().successToast("copy successful".tr());
      }).catchError((Object error) {
        // 复制失败
        NotificationInApp()
            .successToast('Failed to copy text to clipboard: $error');
      });
      // 这里可以添加一些反馈给用户，例如显示一个Snackbar
    } catch (e) {
      // 处理错误，例如显示一个错误消息
    }
  }

  /*
  更改参数更新在线用户数
   */
  updateShowInfo() {
    List<Map<String, dynamic>> tmpList =
        List.from(GlobalManager.globalListValueNotifier.value);

    // 全局更新参数:在线用户数
    tmpList[0]["text"] = GlobalManager.onlineClientList.length;

    // 更新断线连接重试次数
    tmpList[1]["text"] = GlobalManager.globalServerBootCount;

    // 更改全局日志总数
    tmpList[2]["text"] = LogDataStore.getLogModelListInHive().length;

    // 插件数
    tmpList[3]["text"] =
        "${ServerStoreDataPlugin.getPluginListInHive().where((e) => e.status).length}/${ServerStoreDataPlugin.getPluginListInHive().length}";

    // 更改
    GlobalManager.globalListValueNotifier.value = tmpList;
  }

  void deleteDirectory(String path) async {
    try {
      Directory dir = Directory(path);
      await dir.delete(recursive: true); // recursive: true 表示删除目录及其所有子目录和文件
      print('目录删除成功');
    } catch (e) {
      print('删除目录时发生错误: $e');
    }
  }
}
