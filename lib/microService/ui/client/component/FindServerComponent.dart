import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glass_kit/glass_kit.dart';
import 'package:iconify_flutter_plus/icons/heroicons_outline.dart';
import 'package:iconify_flutter_plus/icons/icon_park_outline.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import '../../../module/common/Console.dart';
import '../model/AppSettingModel.dart';
import '../module/AppSettingModule.dart';
import '../module/CommonModule.dart';
import '../websocket/UiWebsocketClient.dart';

class FindServerComponent extends StatefulWidget {
  const FindServerComponent({super.key});

  @override
  State<FindServerComponent> createState() => _FindServerComponentState();
}

class _FindServerComponentState extends State<FindServerComponent>
    with SingleTickerProviderStateMixin, Console {
  final CommonModule commonModule = CommonModule();
  final AppClientSettingModule appClientSettingModule =
      AppClientSettingModule();

  bool isFinding = false;
  String statusMessage = "-";
  String tip = "-";
  late String wifiIP;
  late AnimationController _controller;
  Offset? devicePosition;

  // Found servers
  List<Map<String, dynamic>> serverList = [];

  @override
  void initState() {
    super.initState();
    findIp();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> findIp() async {
    wifiIP = await NetworkInfo().getWifiIP() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    AppClientSettingModel? appConfigModel =
        appClientSettingModule.getAppConfig();
    return GlassContainer.clearGlass(
        width: double.infinity,
        height: 500.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("server find".tr()),
            SizedBox(height: 30.h),
            // Radar effect container
            Container(
              width: 200.w,
              height: 200.h,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: RadarPainter(
                      _controller,
                      devicePosition: devicePosition,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              child: Center(
                child: Text(statusMessage,
                    style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            // Display servers
            Expanded(
              child: ListView(
                children: serverList.map((server) {
                  return ListTile(
                    leading: const Iconify(Ic.round_devices_other,
                        color: Colors.white),
                    title: Text("ip:${server["ip"]}".tr()),
                    subtitle: Text("port:${server["port"]}".tr()),
                    trailing: TextButton(
                      onPressed: () {
                        // Save globally
                        appConfigModel?.serverIp = server["ip"];
                        appConfigModel?.serverPort = server["port"];
                        // Connect
                        UiWebsocketClient uiWebsocketClient =
                            UiWebsocketClient();
                        uiWebsocketClient.connServer();
                      },
                      child: Text(
                        "connect".tr(),
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 30.h),
            Container(
              width: 100.w,
              alignment: Alignment.center,
              height: 40.h,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isFinding = !isFinding;
                    if (isFinding) {
                      statusMessage = "Searching...";
                      _controller.repeat(); // Start radar scan
                      startFinding();
                    } else {
                      statusMessage = "Paused";
                      _controller.stop(); // Pause radar scan
                    }
                  });
                },
                child: Iconify(
                    isFinding
                        ? Ic.baseline_pause_circle
                        : Ic.baseline_play_circle,
                    size: 100),
              ),
            ),
          ],
        ));
  }

  Future<void> startFinding() async {
    int max = appClientSettingModule.getMaxFindInHive();
    for (int i = 0; i < max; i++) {
      if (!isFinding) break;

      var subnet = CommonModule().ipToCSubnet(wifiIP);
      var ip = "$subnet.$i";

      bool connect = await commonModule.testSocketConnection(
          ip, appClientSettingModule.getAppConfig()!.serverPort);

      setState(() {
        tip = ip;
      });

      if (connect) {
        // 寻找到连接设备
        setState(() {
          statusMessage = "Server found at $ip";
          // Calculate device position
          devicePosition =
              calculateDevicePosition(i, max.toDouble(), 200.w / 2);
          // Add to server list
          serverList.add({
            "name": i.toString(),
            "ip": ip,
            "port": appClientSettingModule.getAppConfig()!.serverPort
          });
        });
        await Future.delayed(Duration(milliseconds: 500));
      }
      // 继续寻找
      setState(() {
        statusMessage = "Searching... $ip";
      });
    }

    // 扫描结束
    setState(() {
      statusMessage = "Search completed";
    });
    _controller.stop();
  }

  Offset calculateDevicePosition(int index, double max, double radius) {
    final double angle = (index / max) * 2 * pi;
    final double x = radius + radius * cos(angle);
    final double y = radius + radius * sin(angle);
    return Offset(x, y);
  }
}

class RadarPainter extends CustomPainter {
  final Animation<double> _animation;
  final Offset? devicePosition;

  RadarPainter(this._animation, {this.devicePosition})
      : super(repaint: _animation);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint circlePaint = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final Paint radarPaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.greenAccent.withOpacity(0.5), Colors.grey],
        stops: [0.7, 1.0],
      ).createShader(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2,
      ));

    final double radius = size.width / 2;
    final Offset center = Offset(size.width / 2, size.height / 2);

    // Draw concentric circles
    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(center, radius * (i / 4), circlePaint);
    }

    // Draw radar sweep
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(_animation.value * 2 * pi);
    final Path radarPath = Path()
      ..moveTo(0, 0)
      ..arcTo(Rect.fromCircle(center: Offset(0, 0), radius: radius), -pi / 2,
          pi / 4, false)
      ..close();

    canvas.drawPath(radarPath, radarPaint);

    // Draw glowing effect
    canvas.drawPath(
      radarPath,
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.greenAccent.withOpacity(0.3),
            Colors.transparent,
          ],
          stops: [0.5, 1.0],
        ).createShader(Rect.fromCircle(center: Offset(0, 0), radius: radius))
        ..blendMode = BlendMode.plus,
    );

    canvas.restore();

    // Draw device if available
    if (devicePosition != null) {
      final Paint devicePaint = Paint()
        ..color = Colors.red
        ..style = PaintingStyle.fill;
      canvas.drawCircle(devicePosition!, 5, devicePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
