import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../widget/BootHttpServerWidget.dart';
import '../widget/BootServerWidget.dart';
import '../widget/HttpRunTimeWidget.dart';
import '../widget/RunTimeWidget.dart';
import '../widget/ShowHttpIpAndPortInfoWidget.dart';
import '../widget/ShowIpAndPortInfoWidget.dart';

class BootHttpServerComponent extends StatefulWidget {
  const BootHttpServerComponent({super.key});

  @override
  State<BootHttpServerComponent> createState() => _IndexState();
}

class _IndexState extends State<BootHttpServerComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 启动图标
          BootHttpServerWidget(),
          // 运行时长
          HttpRunTimeWidget(),
          // server ip and port info
          ShowHttpIpAndPortInfoWidget()
        ],
      ),
    );
  }
}
