import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../widget/BootServerWidget.dart';
import '../widget/RunTimeWidget.dart';
import '../widget/ShowIpAndPortInfoWidget.dart';
import 'BootHttpServerComponent.dart';
import 'BootServerComponent.dart';
import 'BottomInfoComponent.dart';
import 'ServerInfoComponent.dart';

class HttpServerComponent extends StatefulWidget {
  const HttpServerComponent({super.key});

  @override
  State<HttpServerComponent> createState() => _IndexState();
}

class _IndexState extends State<HttpServerComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 40),
          // 启动组件
          BootHttpServerComponent(),
          SizedBox(height: 100),
          // 底部版权信息
          BottomInfoComponent()
        ],
      ),
    ));
  }
}
