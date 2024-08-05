import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

import '../../../../config/AppConfig.dart';
import '../../../module/common/unique_device_id.dart';
import '../../../module/manager/GlobalManager.dart';

class UiTool {
  /*
  生成加好友二维码的存储信息
   */
  Future<Map> generateAddUserQrInfo() async {
    // 设备唯一性id
    String deviceId = await UniqueDeviceId.getDeviceUuid();
    // 用户名
    String username = AppConfig.username;
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
