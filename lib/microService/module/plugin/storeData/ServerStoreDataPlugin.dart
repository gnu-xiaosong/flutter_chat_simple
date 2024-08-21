import 'package:dart_eval/stdlib/core.dart';
import 'package:hive/hive.dart';
import '../common.dart';
import 'PluginModel.dart';

class ServerStoreDataPlugin with PluginCommon {
  static var box = Hive.box('plugin');
  static var name = "pluginList";

  /*
   初始化所有参数值
   */
  static Future<void> initialize() async {
    await Hive.openBox('plugin');
  }

  /*
  获取插件模型列表
   */
  static List<PluginModel> getPluginListInHive() {
    List commandInfoList = box.get(name, defaultValue: <Map>[]);
    List<PluginModel> commandInfoListPluginModel = commandInfoList.map((json) {
      return PluginModel.fromJson(Map<String, dynamic>.from(json));
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
    // pluginList.removeWhere(
    //     (json1) => PluginModel.fromJson(json1) == PluginModel.fromJson(json));
    // 增加
    pluginList.add(json);
    // 存储
    box.put(name, pluginList);
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
    PluginModel updatedPlugin = PluginModel.fromJson(json);
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
