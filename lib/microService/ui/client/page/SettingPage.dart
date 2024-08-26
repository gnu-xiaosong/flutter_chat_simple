import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../common/widget/NeumorphicCounterWidget.dart';
import '../../common/widget/NeumorphicSwitchWidget.dart';
import '../../common/widget/NeumorphicTextFieldWidget.dart';
import '../model/AppSettingModel.dart';
import '../module/AppSettingModule.dart';

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
    AppClientSettingModule appModule = AppClientSettingModule();
    AppClientSettingModel? appConfigModel = appModule.getAppConfig();

    return ValueListenableBuilder(
        valueListenable: Hive.box("client").listenable(
            keys: ["darkMode", "retry", "maxRetry", "clientConfig"]),
        builder: (context, box, child) {
          return Scaffold(
            appBar: AppBar(title: Text('setting'.tr())),
            body: SingleChildScrollView(
              child: Neumorphic(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                child: Column(children: <Widget>[
                  SizedBox(height: 8),
                  // 用户标识名
                  NeumorphicTextField(
                    label: "deviceName",
                    hint: appConfigModel!.username.toString().tr(),
                    onChanged: (value) {
                      setState(() {
                        if (appConfigModel != null) {
                          // 保存
                          appConfigModel.username = value;
                        }
                      });
                    },
                    flex: 7,
                  ),
                  SizedBox(height: 8),
                  // ws协议
                  NeumorphicTextField(
                    label: "ws_type",
                    hint: appConfigModel.wsType.toString().tr(),
                    onChanged: (value) {
                      setState(() {
                        if (appConfigModel != null) {
                          // 保存
                          appConfigModel.wsType = value;
                        }
                      });
                    },
                    flex: 4,
                  ),
                  SizedBox(height: 8),
                  // server服务地址
                  NeumorphicTextField(
                    label: "server_ip",
                    hint: appConfigModel.serverIp.toString().tr(),
                    onChanged: (newIp) {
                      setState(() {
                        if (appConfigModel != null) {
                          // 保存
                          appConfigModel.serverIp = newIp;
                        }
                      });
                    },
                    flex: 7,
                  ),
                  SizedBox(height: 8),
                  // server服务端口
                  NeumorphicTextField(
                    label: "server_port",
                    hint: appConfigModel.serverPort.toString().tr(),
                    onChanged: (newIp) {
                      setState(() {
                        if (appConfigModel != null) {
                          // 保存
                          appConfigModel.serverPort = int.parse(newIp);
                        }
                      });
                    },
                    flex: 4,
                  ),
                  SizedBox(height: 8),
                  // http地址
                  NeumorphicTextField(
                    label: "http_ip",
                    hint: appConfigModel.httpIp.toString().tr(),
                    onChanged: (newIp) {
                      setState(() {
                        if (appConfigModel != null) {
                          // 保存
                          appConfigModel.httpIp = newIp;
                        }
                      });
                    },
                    flex: 7,
                  ),
                  SizedBox(height: 8),
                  // http 端口
                  NeumorphicTextField(
                    label: "http_port",
                    hint: appConfigModel.httpPort.toString().tr(),
                    onChanged: (newIp) {
                      setState(() {
                        if (appConfigModel != null) {
                          // 保存
                          appConfigModel.httpPort = int.parse(newIp);
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
                  NeumorphicTextField(
                    label: "max retry",
                    flex: 4,
                    hint: appModule.getMaxRetryInHive().toString(),
                    onChanged: (maxRetry) {
                      appModule.setMaxRetryInHive(int.parse(maxRetry));
                    },
                  ),
                  // 最大探测次数
                  NeumorphicTextField(
                    label: "max find",
                    flex: 4,
                    hint: appModule.getMaxFindInHive().toString(),
                    onChanged: (value) {
                      appModule.setMaxFindInHive(int.parse(value));
                    },
                  ),
                ]),
              ),
            ),
          );
        });
  }
}
