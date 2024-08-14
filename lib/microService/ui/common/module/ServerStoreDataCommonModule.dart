/*
数据存储公共模块模块
 */
import 'dart:io';

import 'package:hive/hive.dart';

import '../../../module/model/CommandInfoModel.dart';

class ServerStoreDataCommonModule {
  // 打开box
  var box = Hive.box('common');
  var name = "commonInfoList";

  /*
   初始化所有参数值
   */
  initialHiveParameter() async {
    getCommandInfoListInHive();
  }

  /*
  获取命令行Info模型列表
   */
  List getCommandInfoListInHive() {
    var commandInfoList = box.get(name);
    if (commandInfoList == null) {
      print("---------serverConfig Hive is not exist----------------");
      // 无，创建
      box.put(name, <CommandInfoModel>[]);
    }
    return box.get(name);
  }

  addCommandInfoList(CommandInfoModel commandInfoModel) {
    // 取出
    List commandInfoLIst = box.get(name);

    // 增加
    commandInfoLIst.add(commandInfoModel);

    // 存储
    box.put(name, commandInfoLIst);
  }
}
