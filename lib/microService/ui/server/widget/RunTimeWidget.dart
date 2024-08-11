import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../module/common/Time.dart';
import '../../../module/manager/GlobalManager.dart';
import '../module/AppModule.dart';

class RunTimeWidget extends StatefulWidget {
  const RunTimeWidget({super.key});

  @override
  State<RunTimeWidget> createState() => _IndexState();
}

class _IndexState extends State<RunTimeWidget> {
  TimeTool timeTool = TimeTool();
  AppModule appModule = AppModule();
  Timer? timer;
  String timerString = "";

  /*
  开始计时
   */
  startTimer() {
    if (GlobalManager.websocketBootStartTime != null) {
      timer = Timer(const Duration(seconds: 1), () {
        int second = (DateTime.now().millisecondsSinceEpoch -
                GlobalManager.websocketBootStartTime!.millisecondsSinceEpoch) ~/
            1000; // 确保结果不会是负数或过大的数值;
        String timeDownString = timeTool.secondFormateTime(second);
        setState(() {
          if (appModule.getIsRunningInHive()) {
            // 运行中
            timerString = timeDownString;
          } else {
            timerString = "";
          }
        });
      });
    }
  }

  /*
  清除Timer计时器
   */
  clearTimer() {
    GlobalManager.websocketBootStartTime = null;
    appModule.setIsRunningInHive(false);
    // 清除定时器
    if (timer != null) {
      timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
        valueListenable: Hive.box("server").listenable(keys: ["isRunning"]),
        builder: (context, box, child) {
          if (box.get("isRunning")) {
            // 启动
            startTimer();
          } else {
            // 取消
            clearTimer();
          }
          return Text(timerString,
              style: TextStyle(
                  color: box.get("isRunning") ? Colors.blue : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 20));
        });
  }
}
