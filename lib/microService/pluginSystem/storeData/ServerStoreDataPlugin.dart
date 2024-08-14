/*
数据存储公共模块模块
 */
import 'package:hive/hive.dart';

import 'PluginModel.dart';

class ServerStoreDataPlugin {
  // 打开box
  var box = Hive.box('plugin');
  var name = "pluginList";

  /*
   初始化所有参数值
   */
  initialHiveParameter() async {
    // 初始化
    getPluginListInHive();
  }

  /*
  获取命令行Info模型列表
   */
  List<PluginModel> getPluginListInHive() {
    var commandInfoList = box.get(name);
    if (commandInfoList == null) {
      print("---------serverConfig Hive is not exist----------------");
      // 无，创建
      box.put(name, <PluginModel>[]);
    }
    return box.get(name);
  }

  addCommandInfoList(PluginModel pluginModel) {
    // 取出
    List pluginList = box.get(name);

    // 增加
    pluginList.add(pluginList);

    // 存储
    box.put(name, pluginList);
  }
}
