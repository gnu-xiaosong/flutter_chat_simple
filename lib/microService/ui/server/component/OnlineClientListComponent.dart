import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../module/manager/GlobalManager.dart';
import '../../client/module/AppSettingModule.dart';
import '../common/serverTool.dart';
import '../common/time.dart';

class OnlineClientListComponent extends StatefulWidget {
  const OnlineClientListComponent({super.key});

  @override
  State<OnlineClientListComponent> createState() => _IndexState();
}

class _IndexState extends State<OnlineClientListComponent> {
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
              "online client list".tr(),
              style: NeumorphicStyle(color: Colors.black),
              textStyle: NeumorphicTextStyle(
                  fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          SizedBox(height: 10),
          // 在线列表
          Expanded(
            // 或者使用 Flexible
            child: GlobalManager.onlineClientList.isEmpty
                ? Center(
                    child: Text(
                      "no device".tr(),
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                          fontWeight: FontWeight.w100),
                    ),
                  )
                : ListView(
                    children:
                        GlobalManager.onlineClientList.map((clientObject) {
                      List statusList = getClientStatus(clientObject.status);
                      return Column(
                        children: [
                          Slidable(
                            key: ValueKey(GlobalManager.onlineClientList
                                .indexOf(clientObject)),
                            // 前置操作
                            endActionPane: ActionPane(
                              // A motion is a widget used to control how the pane animates.
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    // 断开与client的连接
                                    clientObject.socket.close();
                                    // 移除
                                    GlobalManager.onlineClientList
                                        .remove(clientObject);
                                    // 更新数据
                                    serverUiTool.updateShowInfo();

                                    // 将重连关闭

                                    setState(() {});
                                  },
                                  backgroundColor: Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.not_interested_outlined,
                                  label: 'disconnect'.tr(),
                                )
                              ],
                            ),
                            child: ListTile(
                              // 图标
                              leading: Icon(Icons.devices),
                              // 名称：唯一性ID
                              title: Text(
                                "ID:${clientObject.deviceId}",
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                              // ip+port
                              subtitle: Row(
                                children: [
                                  // ip+port
                                  Text(
                                    "${clientObject.ip}:${clientObject.port}",
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  const SizedBox(width: 20),
                                  //  连接时间
                                  Text(
                                    serverUiTime
                                        .formatDateTime(
                                            clientObject.connectionTime)
                                        .toString(),
                                    style: TextStyle(fontSize: 10),
                                  )
                                ],
                              ),
                              // 状态
                              trailing: Text(
                                statusList[0].toString().tr(),
                                style: TextStyle(
                                    color: statusList[1],
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const Divider(
                            color: Colors.grey, // 分割线颜色
                            // thickness: 2, // 分割线粗细
                            indent: 20, // 分割线起始点的缩进
                            endIndent: 20, // 分割线结束点的缩进
                          )
                        ],
                      );
                    }).toList(),
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
