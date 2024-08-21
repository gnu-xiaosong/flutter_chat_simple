import 'package:easy_localization/easy_localization.dart';
import 'package:fluid_dialog/fluid_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_arc_speed_dial/flutter_speed_dial_menu_button.dart';
import 'package:flutter_arc_speed_dial/main_menu_floating_action_button.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:iconify_flutter_plus/icons/zondicons.dart';
import '../common/serverTool.dart';
import '../component/AddPluginComponent.dart';
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

  bool _isShowDial = false;
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
                        floatingActionButton: _getFloatingActionButton(),
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

  Widget _getFloatingActionButton() {
    return SpeedDialMenuButton(
      //if needed to close the menu after clicking sub-FAB
      isShowSpeedDial: _isShowDial,
      //manually open or close menu
      updateSpeedDialStatus: (isShow) {
        //return any open or close change within the widget
        this._isShowDial = isShow;
      },
      //general init
      isMainFABMini: false,
      mainMenuFloatingActionButton: MainMenuFloatingActionButton(
          mini: true,
          child: Icon(Icons.menu),
          heroTag: 'unique-fab-tag',
          onPressed: () {},
          closeMenuChild: Icon(Icons.close),
          closeMenuForegroundColor: Colors.white,
          closeMenuBackgroundColor: Colors.red),
      floatingActionButtonWidgetChildren: <FloatingActionButton>[
        // 添加插件
        FloatingActionButton(
          mini: true,
          child: Iconify(Mdi.puzzle_plus),
          onPressed: () {
            setState(() {
              _isShowDial = false;
            });
            // 打开模态框
            openAddPluginModel();
          },
          backgroundColor: Colors.pink,
        ),
        //
        FloatingActionButton(
          mini: true,
          child: Icon(Icons.volume_down),
          onPressed: () {
            //if need to toggle menu after click
            _isShowDial = !_isShowDial;
            setState(() {});
          },
          backgroundColor: Colors.orange,
        ),
      ],
      isSpeedDialFABsMini: true,
      paddingBtwSpeedDialButton: 60,
    );
  }

  /*
  打开添加plugin模态框
   */
  void openAddPluginModel() {
    showDialog(
      context: context,
      builder: (context) => FluidDialog(
        // Use a custom curve for the alignment transition
        alignmentCurve: Curves.easeInOutCubicEmphasized,
        // Setting custom durations for all animations.
        sizeDuration: const Duration(milliseconds: 300),
        alignmentDuration: const Duration(milliseconds: 600),
        transitionDuration: const Duration(milliseconds: 600),
        reverseTransitionDuration: const Duration(milliseconds: 50),
        // Here we use another animation from the animations package instead of the default one.
        // transitionBuilder: (child, animation) => ZoomIn(
        //   child: child,
        // ),
        // Configuring how the dialog looks.
        defaultDecoration: BoxDecoration(
          color: NeumorphicTheme.baseColor(context),
          borderRadius: BorderRadius.circular(8.0),
        ),
        rootPage: FluidDialogPage(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: NeumorphicTheme.baseColor(context),
          ),
          alignment: Alignment.center, //Aligns the dialog to the bottom left.
          builder: (context) =>
              const AddPluginComponent(), // This can be any widget.
        ),
      ),
    );
  }
}
