import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import '../widget/BootServerWidget.dart';
import '../widget/RunTimeWidget.dart';
import '../widget/ShowIpAndPortInfoWidget.dart';

class BootServerComponent extends StatefulWidget {
  const BootServerComponent({super.key});

  @override
  State<BootServerComponent> createState() => _IndexState();
}

class _IndexState extends State<BootServerComponent> {
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
          BootServerWidget(),
          // 运行时长
          RunTimeWidget(),
          // server ip and port info
          ShowIpAndPortInfoWidget()
        ],
      ),
    );
  }
}
