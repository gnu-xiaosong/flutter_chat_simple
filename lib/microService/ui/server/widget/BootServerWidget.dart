import 'package:app_template/microService/module/common/NotificationInApp.dart';
import 'package:app_template/microService/module/manager/GlobalManager.dart';
import 'package:app_template/microService/ui/server/module/AppModule.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hot_toast/flutter_hot_toast.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ep.dart';
import '../websocket/UiWebsocketServer.dart';

class BootServerWidget extends StatefulWidget {
  const BootServerWidget({super.key});

  @override
  State<BootServerWidget> createState() => _IndexState();
}

class _IndexState extends State<BootServerWidget> {
  @override
  Widget build(BuildContext context) {
    return RotatingStartButton();
  }
}

class RotatingStartButton extends StatefulWidget {
  @override
  _RotatingStartButtonState createState() => _RotatingStartButtonState();
}

class _RotatingStartButtonState extends State<RotatingStartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _glowAnimation;
  AppModule appModule = AppModule();
  NotificationInApp notificationInApp = NotificationInApp();

  // 单例
  UiWebsocketServer uiWebsocketServer = UiWebsocketServer();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _glowAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    // 全局
    GlobalManager.globalControl = _controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /*
  启动关闭按钮
   */
  void _onPressed() {
    print("isRunning: ${appModule.getIsRunningInHive()}");
    if (appModule.getIsRunningInHive()) {
      // 正在运行中: 关闭
      _controller.stop();
      // 关闭服务
      uiWebsocketServer.closeServer();
      // UI提示
      notificationInApp.motionErrorToast(
          titleText: "stop server", messageText: "websocket server is stopped");
    } else {
      // 启动server服务
      _controller.repeat();
      // 停止运行中： 开启
      GlobalManager.websocketBootStartTime = DateTime.now();
      // 启动服务
      uiWebsocketServer.bootServer();
      // UI提示
      notificationInApp.motionSuccessToast(
          titleText: "boot server", messageText: "the server is booted");
    }
    // 设置参数:改变缓存中的isRunning值
    appModule.setIsRunningInHive(!appModule.getIsRunningInHive());
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: NeumorphicButton(
          padding: EdgeInsets.all(30),
          onPressed: _onPressed,
          style: const NeumorphicStyle(
            shape: NeumorphicShape.concave,
            boxShape: NeumorphicBoxShape.circle(),
            depth: 8,
            lightSource: LightSource.topLeft,
            color: Color.fromRGBO(221, 221, 221, 1),
          ),
          child: ValueListenableBuilder<Box>(
              valueListenable: Hive.box('app').listenable(keys: ["isRunning"]),
              builder: (context, box, widget) {
                return Column(
                  children: [
                    // 图标
                    Iconify(
                      Ep.switch_button,
                      size: 100,
                      color: box.get("isRunning") ? Colors.red : Colors.green,
                    ),
                    // tip
                    Text(box.get("isRunning") ? "running".tr() : "boot".tr(),
                        style: TextStyle(
                            color: box.get("isRunning")
                                ? Colors.red
                                : Colors.green)),
                  ],
                );
              })),
      builder: (context, child) {
        return Transform.rotate(
          angle: _animation.value * 2.0 * 3.14159,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.5),
                  blurRadius: _glowAnimation.value,
                  spreadRadius: _glowAnimation.value,
                ),
              ],
            ),
            child: child,
          ),
        );
      },
    );
  }
}
