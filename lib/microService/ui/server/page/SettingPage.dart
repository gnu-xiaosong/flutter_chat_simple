import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../common/widget/NeumorphicCounterWidget.dart';
import '../../common/widget/NeumorphicSwitchWidget.dart';
import '../../common/widget/NeumorphicTextFieldWidget.dart';
import '../model/AppConfigModel.dart';
import '../module/AppModule.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _IndexState();
}

class _IndexState extends State<SettingPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppModule appModule = AppModule();
    AppConfigModel? appConfigModel = appModule.getAppConfig();

    return ValueListenableBuilder(
        valueListenable: Hive.box("server").listenable(
            keys: ["darkMode", "retry", "maxRetry", "serverConfig"]),
        builder: (context, box, child) {
          print("端口:${appConfigModel!.websocketPort.toString().tr()}");
          return Scaffold(
            appBar: AppBar(title: Text('setting'.tr())),
            body: Neumorphic(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(5),
              child: Column(children: <Widget>[
                SizedBox(height: 8),
                // 端口地址
                NeumorphicTextField(
                  label: "port",
                  hint: appConfigModel.websocketPort.toString().tr(),
                  onChanged: (newIp) {
                    setState(() {
                      if (appConfigModel != null) {
                        // 保存
                        appConfigModel.websocketPort = int.parse(newIp);
                      }
                    });
                  },
                  flex: 4,
                ),
                SizedBox(height: 10),
                // 是否断线重连
                NeumorphicSwitchWidget(
                    label: "retry",
                    flex: 5,
                    value: appModule.getRetryInHive(),
                    onChanged: (mode) {
                      // 设置
                      appModule.setRetryInHive(mode);
                    }),
                SizedBox(height: 10),
                // 最大重连次数
                NeumorphicCounterWidget(
                  label: "max retry",
                  flex: 5,
                  value: appModule.getMaxRetryInHive(),
                  onChanged: (maxRetry) {
                    appModule.setMaxRetryInHive(double.parse(maxRetry));
                  },
                )
              ]),
            ),
          );
        });
  }
}
