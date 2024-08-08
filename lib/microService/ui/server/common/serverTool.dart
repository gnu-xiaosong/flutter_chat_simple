import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

import '../../../module/common/NotificationInApp.dart';
import '../../../module/manager/GlobalManager.dart';

class ServerUiTool {
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
    // 更改
    GlobalManager.globalListValueNotifier.value = tmpList;
  }
}
