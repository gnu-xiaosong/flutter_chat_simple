
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../model/AppConfigModel.dart';
import '../module/AppModule.dart';
import 'TipWidget.dart';

class ShowIpAndPortInfoWidget extends StatefulWidget {
  const ShowIpAndPortInfoWidget({super.key});

  @override
  State<ShowIpAndPortInfoWidget> createState() => _IndexState();
}

class _IndexState extends State<ShowIpAndPortInfoWidget> {
  AppModule appModule = AppModule();
  AppConfigModel? appConfigModel;
  @override
  void initState() {
    super.initState();
    // 获取配置类对象
    appConfigModel = appModule.getAppConfig();
    // 获取ip地址并设置
    appModule.getLocalIpAddress().then((ip) {
      // 设置ip
      appConfigModel?.websocketIp = ip;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
        valueListenable: Hive.box("app").listenable(keys: ["serverConfig"]),
        builder: (context, box, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ip
              TipWidget(label: "ip".tr(), text: appConfigModel?.websocketIp),
              const SizedBox(width: 15),
              // port
              TipWidget(
                  label: "port".tr(),
                  text: appConfigModel!.websocketPort.toString()),
            ],
          );
        });
  }
}
