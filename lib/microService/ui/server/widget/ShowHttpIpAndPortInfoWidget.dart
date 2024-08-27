import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../module/common/tools.dart';
import '../model/AppConfigModel.dart';
import '../module/AppModule.dart';
import 'TipWidget.dart';

class ShowHttpIpAndPortInfoWidget extends StatefulWidget {
  const ShowHttpIpAndPortInfoWidget({super.key});

  @override
  State<ShowHttpIpAndPortInfoWidget> createState() => _IndexState();
}

class _IndexState extends State<ShowHttpIpAndPortInfoWidget> with CommonTool {
  AppModule appModule = AppModule();
  AppConfigModel? appConfigModel;
  @override
  void initState() {
    super.initState();
    getAdrr();
  }

  getAdrr() async {
    // 获取配置类对象
    appConfigModel = appModule.getAppConfig();
    // 获取ip地址并设置
    appConfigModel?.websocketIp = (await getLocalIPv4Address())!;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
        valueListenable:
            Hive.box("server").listenable(keys: ["serverConfig", "isRunning"]),
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
                  text: appModule.getHttpPortInHive().toString()),
            ],
          );
        });
  }
}
