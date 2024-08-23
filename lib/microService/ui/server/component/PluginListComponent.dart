import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:socket_service/microService/module/plugin/dataModel/PluginInfoModel.dart';
import 'package:socket_service/microService/module/plugin/storeData/PluginModel.dart';
import '../../../module/plugin/storeData/PluginInfoDataStore.dart';
import '../../../module/plugin/storeData/ServerStoreDataPlugin.dart';
import '../common/serverTool.dart';
import '../common/time.dart';

class PluginListComponent extends StatefulWidget {
  const PluginListComponent({super.key});

  @override
  State<PluginListComponent> createState() => _IndexState();
}

class _IndexState extends State<PluginListComponent> {
  ServerUiTime serverUiTime = ServerUiTime();
  ServerUiTool serverUiTool = ServerUiTool();
  PluginInfoDataStore pluginInfoDataStore = PluginInfoDataStore();

  @override
  Widget build(BuildContext context) {
    List<PluginModel> plugins = ServerStoreDataPlugin.getPluginListInHive();
    return Container(
      padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
      width: double.infinity,
      height: 400.h,
      child: Column(
        children: [
          // 标题
          Center(
            child: NeumorphicText(
              "plugins".tr(),
              style: NeumorphicStyle(color: Colors.black),
              textStyle: NeumorphicTextStyle(
                  fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          SizedBox(height: 10),
          // 在线列表
          Expanded(
            // 或者使用 Flexible
            child: plugins.isEmpty
                ? Center(
                    child: Text(
                      "no plugins".tr(),
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                          fontWeight: FontWeight.w100),
                    ),
                  )
                : ListView(
                    children: plugins.map((plugin) {
                      // 获取插件infoModel
                      PluginInfoModel? pluginInfoModel =
                          pluginInfoDataStore.getPluginInfoById(plugin.id);
                      print("插件信息: ${pluginInfoModel.toString()}");

                      serverUiTool.checkFileExists(pluginInfoModel!.icon);
                      return Column(
                        children: [
                          Slidable(
                            key: ValueKey(plugins.indexOf(plugin)),
                            // 前置操作
                            endActionPane: ActionPane(
                              // A motion is a widget used to control how the pane animates.
                              motion: const ScrollMotion(),
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    setState(() {
                                      // 删除
                                      pluginInfoDataStore
                                          .deletePluginInfo(plugin.id);
                                      ServerStoreDataPlugin()
                                          .deletePluginInfo(plugin.id);
                                      // 删除文件夹
                                      String dirPath = p.dirname(plugin.path);
                                      serverUiTool.deleteDirectory(dirPath);
                                    });

                                    //
                                    serverUiTool.updateShowInfo();
                                  },
                                  backgroundColor: Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.not_interested_outlined,
                                  label: 'delete'.tr(),
                                )
                              ],
                            ),
                            child: ListTile(
                              // 图标
                              leading: SizedBox(
                                width: 50,
                                height: 50,
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: _loadImage(pluginInfoModel.icon),
                                ),
                              ),
                              // 名称：唯一性ID
                              title: Text(
                                pluginInfoModel.name,
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                              // ip+port
                              subtitle: Row(
                                children: [
                                  // ip+port
                                  Text(
                                    "${pluginInfoModel.version} ${pluginInfoModel.pluginType.tr()} ${pluginInfoModel.pluginCategory.tr()}",
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  const SizedBox(width: 20),
                                  // 连接时间
                                  Expanded(
                                    // 加上 Expanded 以避免 TextOverflow 问题
                                    child: Text(
                                      pluginInfoModel.description,
                                      style: TextStyle(fontSize: 10),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              // 状态
                              trailing: GestureDetector(
                                onTap: () {
                                  Map<String, dynamic> a = plugin.toJson();
                                  a["status"] = !plugin.status;
                                  ServerStoreDataPlugin()
                                      .updatePluginInfo(plugin.id, a);
                                  // 更新
                                  setState(() {});
                                  serverUiTool.updateShowInfo();
                                },
                                child: Text(
                                  (plugin.status ? "Enabled" : "Disabled")
                                      .tr(), // 这里你原来有个 `.tr()` 是多语言翻译的标志，如果你使用了某个国际化插件（如 `easy_localization`），可以保留，否则去掉
                                  style: TextStyle(
                                    color: plugin.status
                                        ? Colors.green
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
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

  Widget _loadImage(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      // 网络图片
      return Image.network(path, fit: BoxFit.cover);
    } else if (path.startsWith('/')) {
      // 本地文件系统图片
      return Image.file(File(path), fit: BoxFit.cover);
    } else {
      // asset 图片
      return Image.asset(path, fit: BoxFit.cover);
    }
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
