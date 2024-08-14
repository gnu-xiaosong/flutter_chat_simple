import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import '../common/serverTool.dart';
import '../component/BootServerComponent.dart';
import '../component/ServerInfoComponent.dart';
import '../model/AppConfigModel.dart';
import '../module/AppModule.dart';
import 'SettingPage.dart';

class HomeServerPage extends StatefulWidget {
  const HomeServerPage({super.key});

  @override
  State<HomeServerPage> createState() => _HomePageState();
}

class _HomePageState extends State<HomeServerPage> {
  AppModule appModule = AppModule();
  ServerUiTool serverUiTool = ServerUiTool();
  // widget
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box("server").listenable(keys: ["darkMode"]),
        builder: (context, box, child) {
          return NeumorphicTheme(
              themeMode: appModule.getDarkModeInHive()
                  ? ThemeMode.dark
                  : ThemeMode.light,
              darkTheme: const NeumorphicThemeData(
                baseColor: Color(0xFF3E3E3E),
                lightSource: LightSource.topLeft,
                depth: 5,
                intensity: 1.0,
              ),
              child: NeumorphicBackground(
                padding: const EdgeInsets.all(0),
                child: ValueListenableBuilder<Box>(
                    valueListenable:
                        Hive.box("server").listenable(keys: ["serverConfig"]),
                    builder: (context, box, child) {
                      // 获取配置类对象
                      AppConfigModel? appConfigModel = appModule.getAppConfig();
                      return Scaffold(
                        //app顶部栏
                        appBar: NeumorphicAppBar(
                          color: Colors.brown.shade500,
                          padding: 5,
                          leading: Center(
                              child: GestureDetector(
                            onTap: () {
                              //
                              print("点击了");
                            },
                            child: NeumorphicIcon(
                              Icons.wifi_tethering,
                              size: 40,
                            ),
                          )),
                          centerTitle: true,
                          title: NeumorphicText(
                            appConfigModel!.name.tr(),
                            textStyle: NeumorphicTextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                          actions: [
                            // 模式切换
                            Center(
                                child: GestureDetector(
                                    onTap: () {
                                      // 更新数据
                                      serverUiTool.updateShowInfo();
                                      // 切换模式
                                      appModule.setDarkModeInHive(
                                          !appModule.getDarkModeInHive());
                                    },
                                    child: NeumorphicIcon(
                                      Icons.dark_mode,
                                      size: 40,
                                    ))),
                            Center(
                                child: GestureDetector(
                                    onTap: () {
                                      // 打开设置页面
                                      Navigator.of(context).push(
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) {
                                            return const SettingPage();
                                          },
                                        ),
                                      );
                                    },
                                    child: NeumorphicIcon(
                                      Icons.settings,
                                      size: 40,
                                    )))
                          ],
                        ),
                        backgroundColor: NeumorphicTheme.baseColor(context),

                        //App主体
                        body: Container(
                          child: Column(
                            children: [
                              // 启动组件
                              BootServerComponent(),
                              SizedBox(height: 10),
                              // 显示信息
                              ServerInfoComponent()
                            ],
                          ),
                        ),
                      );
                    }),
              ));
        });
  }
}
