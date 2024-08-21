import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../module/manager/GlobalManager.dart';
import '../../../service/server/model/LogModel.dart';
import '../../../service/store/LogDataStore.dart';
import '../common/serverTool.dart';
import '../common/time.dart';

class LogInfoComponent extends StatefulWidget {
  const LogInfoComponent({super.key});

  @override
  State<LogInfoComponent> createState() => _IndexState();
}

class _IndexState extends State<LogInfoComponent> {
  ServerUiTime serverUiTime = ServerUiTime();
  ServerUiTool serverUiTool = ServerUiTool();

  @override
  Widget build(BuildContext context) {
    List<LogModel> log = LogDataStore.getLogModelListInHive();
    return Container(
      padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
      width: double.infinity,
      height: 400.h,
      child: Column(
        children: [
          // 标题
          Center(
            child: NeumorphicText(
              "log info".tr(),
              style: NeumorphicStyle(color: Colors.black),
              textStyle: NeumorphicTextStyle(
                  fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          SizedBox(height: 10),
          // 在线列表
          Expanded(
            // 如果父级小部件（例如 Column）需要占用可用空间，可以在这里使用 Expanded
            child: log.isEmpty
                ? Center(
                    child: Text(
                      "no log".tr(),
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                          fontWeight: FontWeight.w100),
                    ),
                  )
                : Container(
                    margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ListView(
                      // 确保 ListView 可以垂直滚动
                      children: log.map((logModel) {
                        String time =
                            serverUiTime.formatDateTime(logModel.time);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "[$time] ",
                              style: const TextStyle(color: Colors.green),
                            ),
                            // 时间
                            Expanded(
                              // 使用 Expanded 防止内容溢出
                              child: Text(
                                "${logModel.content.toString()}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

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
