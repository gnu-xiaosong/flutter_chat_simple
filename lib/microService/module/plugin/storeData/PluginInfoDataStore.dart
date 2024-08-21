/*
存储插件信息：主要为插件包里面的info.json文件里的数据对象
 */
import 'package:hive/hive.dart';
import '../dataModel/PluginInfoModel.dart';

class PluginInfoDataStore {
  static var box = Hive.box('plugin');
  static var name = "pluginInfoList";

  /*
  获取插件模型列表
   */
  static List<PluginInfoModel> getPluginInfoListInHive() {
    List commandInfoList = box.get(name, defaultValue: <Map>[]);
    List<PluginInfoModel> commandInfoListPluginModel =
        commandInfoList.map((json) {
      return PluginInfoModel.fromJson(json);
    }).toList();
    return commandInfoListPluginModel;
  }

  /*
  异步添加插件信息到列表
   */
  Future<void> addPluginInfo(Map<String, dynamic> json) async {
    // 取出
    List pluginList = box.get(name, defaultValue: <Map>[]);

    // 增加:剔除已存在的
    pluginList.removeWhere((json1) => json1["id"] == json["id"]);
    // 增加
    pluginList.add(json);
    // 存储
    box.put(name, pluginList);
  }

  /*
  根据id获取PluginInfo
   */
  PluginInfoModel? getPluginInfoById(String id) {
    // 取出
    List pluginList = box.get(name, defaultValue: <Map>[]);
    // print("id:$id");
    // print("插件列表: ${pluginList.length}");
    // 遍历
    for (var e in pluginList) {
      if (e["id"] == id) {
        return PluginInfoModel.fromJson(Map<String, dynamic>.from(e));
      }
    }

    return null;
  }

  /*
  异步删除插件信息
  @parameter: id - 插件的唯一标识符
   */
  Future<void> deletePluginInfo(String id) async {
    // 取出
    List pluginList = box.get(name, defaultValue: <Map>[]);

    // 增加:剔除已存在的
    pluginList.removeWhere((json) => json["id"] == id);

    // 存储
    box.put(name, pluginList);
  }

  /*
  删除所有
   */
  clearPluginsInHive() {
    box.clear();
  }

  /*
  异步更新插件信息
  @parameter: id - 插件的唯一标识符
  @parameter: updatedPlugin - 更新后的插件模型
   */
  Future<void> updatePluginInfo(String id, Map<String, dynamic> json) async {
    PluginInfoModel updatedPlugin = PluginInfoModel.fromJson(json);
    // 取出
    List pluginList = box.get(name, defaultValue: <Map>[]);

    // 更新
    pluginList = pluginList.map((json) {
      if (json["id"] == id) {
        // 目标
        return updatedPlugin.toJson();
      }
      return json;
    }).toList();

    // 存储
    box.put(name, pluginList);
  }
}
