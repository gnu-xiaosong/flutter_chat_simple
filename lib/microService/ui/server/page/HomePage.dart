import 'package:easy_localization/easy_localization.dart';
import 'package:fluid_dialog/fluid_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_arc_speed_dial/flutter_speed_dial_menu_button.dart';
import 'package:flutter_arc_speed_dial/main_menu_floating_action_button.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/cib.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import '../common/serverTool.dart';
import '../component/AddPluginComponent.dart';
import '../component/HttpServerComponent.dart';
import '../component/WebsocketServerComponent.dart';
import '../model/AppConfigModel.dart';
import '../module/AppModule.dart';
import 'SettingPage.dart';

class HomeServerPage extends StatefulWidget {
  const HomeServerPage({super.key});

  @override
  State<HomeServerPage> createState() => _HomePageState();
}

class _HomePageState extends State<HomeServerPage> {
  final AppModule appModule = AppModule();
  final ServerUiTool serverUiTool = ServerUiTool();
  bool _isShowDial = false;

  // 顶部tab
  final List<Map<String, dynamic>> TopTabs = [
    {
      "name": "websocket",
      "icon": Iconify(Cib.socket_io),
      "tabView": Container(
          width: double.infinity,
          // color: Colors.red,
          child: WebsocketServerComponent())
    },
    {
      "name": "http",
      "icon": Iconify(Ic.twotone_http),
      "tabView": Container(
        width: double.infinity,
        height: 800,
        // color: Colors.green,
        child: HttpServerComponent(),
      )
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box("server").listenable(keys: ["darkMode"]),
      builder: (context, box, child) {
        return NeumorphicTheme(
          themeMode:
              appModule.getDarkModeInHive() ? ThemeMode.dark : ThemeMode.light,
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
                return DefaultTabController(
                  length: TopTabs.length,
                  child: Scaffold(
                    appBar: AppBar(
                      bottom: TabBar(
                          tabs: TopTabs.map((tab) => Tab(
                              icon: tab["icon"],
                              text: tab["name"].toString().tr())).toList()),
                      leading: Center(
                        child: GestureDetector(
                          onTap: () {
                            print("点击了");
                          },
                          child: NeumorphicIcon(
                            Icons.wifi_tethering,
                            size: 40,
                          ),
                        ),
                      ),
                      centerTitle: true,
                      title: NeumorphicText(
                        appConfigModel!.name.tr(),
                        textStyle: NeumorphicTextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      actions: [
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
                            ),
                          ),
                        ),
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
                            ),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: NeumorphicTheme.baseColor(context),
                    floatingActionButton: _getFloatingActionButton(),
                    body: TabBarView(
                      children: <Widget>[
                        for (var item in TopTabs) item['tabView']
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _getFloatingActionButton() {
    return SpeedDialMenuButton(
      isShowSpeedDial: _isShowDial,
      updateSpeedDialStatus: (isShow) {
        setState(() {
          _isShowDial = isShow;
        });
      },
      isMainFABMini: false,
      mainMenuFloatingActionButton: MainMenuFloatingActionButton(
        mini: true,
        child: Icon(Icons.menu),
        heroTag: 'unique-fab-tag',
        onPressed: () {},
        closeMenuChild: Icon(Icons.close),
        closeMenuForegroundColor: Colors.white,
        closeMenuBackgroundColor: Colors.red,
      ),
      floatingActionButtonWidgetChildren: <FloatingActionButton>[
        _buildFAB(
          Iconify(Mdi.puzzle_plus),
          Colors.pink,
          () {
            setState(() {
              _isShowDial = false;
            });
            openAddPluginModel();
          },
        ),
        _buildFAB(
          Icon(Icons.volume_down),
          Colors.orange,
          () {
            setState(() {
              _isShowDial = !_isShowDial;
            });
          },
        ),
      ],
      isSpeedDialFABsMini: true,
      paddingBtwSpeedDialButton: 60,
    );
  }

  FloatingActionButton _buildFAB(
      Widget icon, Color color, VoidCallback onPressed) {
    return FloatingActionButton(
      mini: true,
      child: icon,
      onPressed: onPressed,
      backgroundColor: color,
    );
  }

  /*
  打开添加plugin模态框
  */
  void openAddPluginModel() {
    showDialog(
      context: context,
      builder: (context) => FluidDialog(
        alignmentCurve: Curves.easeInOutCubicEmphasized,
        sizeDuration: const Duration(milliseconds: 300),
        alignmentDuration: const Duration(milliseconds: 600),
        transitionDuration: const Duration(milliseconds: 600),
        reverseTransitionDuration: const Duration(milliseconds: 50),
        defaultDecoration: BoxDecoration(
          color: NeumorphicTheme.baseColor(context),
          borderRadius: BorderRadius.circular(8.0),
        ),
        rootPage: FluidDialogPage(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: NeumorphicTheme.baseColor(context),
          ),
          alignment: Alignment.center,
          builder: (context) => const AddPluginComponent(),
        ),
      ),
    );
  }
}
