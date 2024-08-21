import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../common/serverTool.dart';
import '../common/time.dart';
import 'FilePluginUploadComponent.dart';

class AddPluginComponent extends StatefulWidget {
  const AddPluginComponent({super.key});

  @override
  State<AddPluginComponent> createState() => _IndexState();
}

class _IndexState extends State<AddPluginComponent> {
  ServerUiTime serverUiTime = ServerUiTime();
  ServerUiTool serverUiTool = ServerUiTool();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
      width: double.infinity,
      height: 400.h,
      child: Column(
        children: [
          // 标题
          Center(
            child: NeumorphicText(
              "add plugin".tr(),
              style: NeumorphicStyle(color: Colors.black),
              textStyle: NeumorphicTextStyle(
                  fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          SizedBox(height: 100),
          // 在线列表
          Center(
            child: FileUploadComponent(
              onPressedAddFiles: () {
                print("AddFiles");
              },
              placeholderText:
                  'please upload .plugin file for plugin upload'.tr(),
            ),
          )
        ],
      ),
    );
  }

  /*
  显示插件信息
   */
  ShowInfo() {}

  /*
  判定client客户端状态 0 暂时拒收消息 1 可接受信息 2 标记为危险客户端 3 被ban
   */
  List<dynamic> getClientStatus(int status) {
    String? label;
    Color? color;
    switch (status) {
      case 0:
        label = "refuse";
        color = Colors.redAccent;
        break;
      case 1:
        label = "normal";
        color = Colors.green;
        break;
      case 2:
        label = "danger";
        color = Colors.yellow;
        break;
      case 3:
        label = "ban";
        color = Colors.red;
        break;
      default:
        label = "status error";
        color = Colors.red;
    }

    return [label, color];
  }
}
