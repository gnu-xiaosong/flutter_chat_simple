import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ep.dart';
import '../../../module/common/NotificationInApp.dart';
import '../../../module/httpServer/HttpServer.dart';
import '../../../module/manager/GlobalManager.dart';
import '../module/AppModule.dart';
import '../module/UiHttpServer.dart';

class BootHttpServerWidget extends StatefulWidget {
  const BootHttpServerWidget({super.key});

  @override
  State<BootHttpServerWidget> createState() => _IndexState();
}

class _IndexState extends State<BootHttpServerWidget> {
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
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _glowAnimation;
  UiHttpServer server = UiHttpServer();
  AppModule appModule = AppModule();
  NotificationInApp notificationInApp = NotificationInApp();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _glowAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    // 全局
    GlobalManager.globalControlHttp = _controller;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // 应用从后台恢复时，重新启动 HTTP 服务
    } else if (state == AppLifecycleState.paused) {
      // 应用进入后台时，可以选择停止 HTTP 服务
      server.boot();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  /*
  启动关闭按钮
   */
  Future<void> _onPressed() async {
    print("isRunning: ${appModule.getHttpIsRunningInHive()}");
    if (appModule.getHttpIsRunningInHive()) {
      print("nooooooooo");
      // 正在运行中: 关闭
      _controller.stop();
      // 关闭服务
      server.close();
      // UI提示
      notificationInApp.motionErrorToast(
          titleText: "stop server", messageText: "http server is stopped");
    } else {
      print("okkkkkk");
      // 启动server服务
      _controller.repeat();
      // 停止运行中： 开启
      GlobalManager.httpBootStartTime = DateTime.now();
      // 启动服务
      await server.boot();
      // UI提示
      notificationInApp.motionSuccessToast(
          titleText: "boot server", messageText: "the server is booted");
    }
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
              valueListenable:
                  Hive.box('server').listenable(keys: ["httpIsRunning"]),
              builder: (context, box, widget) {
                return Column(
                  children: [
                    // 图标
                    Iconify(
                      Ep.switch_button,
                      size: 100,
                      color: appModule.getHttpIsRunningInHive()
                          ? Colors.red
                          : Colors.green,
                    ),
                    // tip
                    Text(
                        appModule.getHttpIsRunningInHive()
                            ? "running".tr()
                            : "boot".tr(),
                        style: TextStyle(
                            color: box.get("httpIsRunning")
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
