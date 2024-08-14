import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:socket_service/microService/ui/client/module/AppSettingModule.dart';

import '../../../../config/AppConfig.dart';
import '../../../module/common/unique_device_id.dart';
import '../../../module/manager/GlobalManager.dart';
import '../../../module/common/NotificationInApp.dart';

class UiTool extends AppClientSettingModule {
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
  生成加好友二维码的存储信息
   */
  Future<Map> generateAddUserQrInfo() async {
    // 设备唯一性id
    String deviceId = GlobalManager.deviceId.toString() ??
        await UniqueDeviceId.getDeviceUuid();
    // 用户名
    String? username = getAppConfig()?.username;
    // 封装
    Map re = {"type": "ADD_USER", "deviceId": deviceId, "username": username};

    return re;
  }

  /*
  获取页面传递过来的deviceId
   */
  getDeviceId(BuildContext context) {
    late String? deviceId;
    // 获取路由传递过来的roomId
    try {
      // 正常获取
      deviceId = ModalRoute.of(context)!.settings.arguments.toString();
      // 存储在缓存中
      GlobalManager.appCache.setString("receiveDeviceId", deviceId!);

      // 多层判断
      if (GlobalManager.appCache.containsKey("receiveDeviceId")) {
        deviceId ??= GlobalManager.appCache.getString("receiveDeviceId");
      } else {
        // 提示
        MotionToast.error(
                title: Text("Warning".tr()),
                description: Text(
                    "appCache not did containsKey is receiveDeviceId".tr()))
            .show(context);
      }
    } catch (e) {
      // 页面刷新获取
      if (GlobalManager.appCache.containsKey("receiveDeviceId")) {
        // 存在
        deviceId = GlobalManager.appCache.getString("receiveDeviceId");
      } else {
        // 提示
        MotionToast.error(
                title: Text("Warning".tr()),
                description: Text(
                    "appCache not did containsKey is receiveDeviceId".tr()))
            .show(context);
      }
    }

    // 判断
    if (deviceId == null) {
      // 提示
      MotionToast.error(
              title: Text("System error".tr()),
              description: Text("deviceId is empty!".tr()))
          .show(context);
    }
    return deviceId;
  }
}
