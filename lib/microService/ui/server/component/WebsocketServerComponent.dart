import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../widget/BootServerWidget.dart';
import '../widget/RunTimeWidget.dart';
import '../widget/ShowIpAndPortInfoWidget.dart';
import 'BootServerComponent.dart';
import 'BottomInfoComponent.dart';
import 'ServerInfoComponent.dart';

class WebsocketServerComponent extends StatefulWidget {
  const WebsocketServerComponent({super.key});

  @override
  State<WebsocketServerComponent> createState() => _IndexState();
}

class _IndexState extends State<WebsocketServerComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 40),
          // 启动组件
          BootServerComponent(),
          SizedBox(height: 10),
          // 显示信息
          ServerInfoComponent(),
          SizedBox(
            height: 100,
          ),
          // 底部版权信息
          BottomInfoComponent()
        ],
      ),
    ));
  }
}
