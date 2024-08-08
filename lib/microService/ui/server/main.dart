import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../../module/manager/AppLifecycleStateManager.dart';
import '../../module/manager/GlobalManager.dart';
import 'page/HomePage.dart';

void main() => GlobalManager.init().then((e) async {
      runApp(const MaterialApplication());
    });

class MaterialApplication extends StatefulWidget {
  const MaterialApplication({super.key});
  @override
  State<MaterialApplication> createState() => _MaterialApplicationState();
}

class _MaterialApplicationState extends State<MaterialApplication>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    // 在初始化前先设置context
    print("this widget mounted: ${super.mounted}");
    GlobalManager.context = context;

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // app生命周期函数
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // 应用程序进入前台时执行的操作
      print('--------App has entered the foreground-------');
      // 您可以在这里添加需要执行的代码，例如刷新数据
      enterAppForward(GlobalManager.context);
    } else if (state == AppLifecycleState.paused) {
      // 应用程序进入后台时执行的操作
      print('--------App has entered the background--------');
      // 您可以在这里添加需要执行的代码，例如保存数据
      enterAppBackward(GlobalManager.context);
    } else if (state == AppLifecycleState.inactive) {
      //应用程序处于非活动状态，并且不会接收用户输入
      print("-------App has inactive---");
      appInactive();
    } else if (state == AppLifecycleState.detached) {
      // 说明：应用程序仍在 Flutter 引擎中运行，但与宿主 View 分离。在移动平台中，这种状态通常出现在应用程序被完全退出之前，用于执行一些清理工作。
      // 使用场景：在应用程序即将退出时执行清理操作，比如释放资源或保存最后的状态数据。

      print("-------App has detached---");
      appDetached();
    } else if (state == AppLifecycleState.hidden) {
      print(" ------------app has hidden--------");
    }

    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return const NeumorphicApp(
      debugShowCheckedModeBanner: false,
      title: 'websocket server',
      themeMode: ThemeMode.light,
      theme: NeumorphicThemeData(
        baseColor: Color(0xFFFFFFFF),
        lightSource: LightSource.topLeft,
        depth: 10,
      ),
      darkTheme: NeumorphicThemeData(
        baseColor: Color(0xFF3E3E3E),
        lightSource: LightSource.topLeft,
        depth: 6,
      ),
      home: HomePage(),
    );
  }
}
