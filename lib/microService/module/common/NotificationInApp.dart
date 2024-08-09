/*
封装在应用内的通知与提示，区别于系统层的通知
 */
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ant_design.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:toasty_box/toast_enums.dart';
import 'package:toasty_box/toast_service.dart';

import '../manager/GlobalManager.dart';

class NotificationInApp {
  NotificationInApp() {
    // 全局配置
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.yellow
      ..backgroundColor = Colors.green
      ..indicatorColor = Colors.yellow
      ..textColor = Colors.yellow
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = true
      ..dismissOnTap = false;
  }
  /*
  提示toast: success
   */
  successToast(String text) {
    EasyLoading.instance
      ..animationStyle = EasyLoadingAnimationStyle.offset
      // ..textPadding = EdgeInsets.all(5)
      ..contentPadding = EdgeInsets.fromLTRB(5, 8, 5, 8);
    EasyLoading.showToast(text, toastPosition: EasyLoadingToastPosition.bottom);
  }

  /*
  提示toast: error
   */
  errorToast(String text) {
    EasyLoading.showError(text.toString().tr());
  }

  /*
  提示toast: warning
   */
  warningToast(String text) {}

  /*
  toast: 信息提示
   */
  infoToast(String text) {}

  /*
  toast: custom自定义
   */
  customToast(Widget icon, String text) {}

  /*
  client客户端连接成功后的弹窗提示
   */
  connSuccessModel(String text) {
    ToastService.showToast(
      GlobalManager.context,
      isClosable: false,
      backgroundColor: Colors.teal.shade500,
      shadowColor: Colors.teal.shade200,
      length: ToastLength.medium,
      expandedHeight: 100,
      message: text,
      messageStyle: TextStyle(fontSize: 18),
      leading:
          const Iconify(Ic.sharp_connect_without_contact, color: Colors.white),
      slideCurve: Curves.elasticInOut,
      positionCurve: Curves.bounceInOut,
      dismissDirection: DismissDirection.down,
    );
  }

  /*
  警示提示的弹窗提示
   */
  showErrorModel({required String titleText, required String messageText}) {
    ToastService.showToast(
      GlobalManager.context,
      isClosable: false,
      backgroundColor: Colors.red.shade500,
      shadowColor: Colors.red.shade200,
      length: ToastLength.medium,
      expandedHeight: 100,
      message: messageText,
      messageStyle: const TextStyle(fontSize: 18),
      leading: const Iconify(AntDesign.disconnect_outlined),
      slideCurve: Curves.elasticInOut,
      positionCurve: Curves.bounceInOut,
      dismissDirection: DismissDirection.down,
    );
    // AnimatedSnackBar.rectangle(
    //   titleText,
    //   messageText,
    //   type: AnimatedSnackBarType.error,
    //   brightness: Brightness.light,
    // ).show(GlobalManager.context);
  }

  /*
  MotionToast成功提示
   */
  motionSuccessToast({required String titleText, required String messageText}) {
    MotionToast.success(
      position: MotionToastPosition.top,
      title: Text(titleText),
      description: Text(messageText),
    ).show(GlobalManager.context);
  }

  /*
  MotionToast失败提示
   */
  motionErrorToast({required String titleText, required String messageText}) {
    MotionToast.error(
      position: MotionToastPosition.top,
      title: Text(titleText),
      description: Text(messageText),
    ).show(GlobalManager.context);
  }
}
