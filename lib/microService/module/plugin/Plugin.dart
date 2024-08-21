/*
插件类:抽象类接口
 */

import 'PluginType.dart';
import 'pluginInsert/PluginCategory.dart';
import 'storeData/PluginModel.dart';

// 插件分类类别
class Plugin {
  // 插件ID：唯一性标识
  late String id;

  // 插件名称
  late String name;

  // 插件类型: 采用枚举类型T
  late PluginType type;

  // 创建时间
  late DateTime time;

  // 插件分类: 即对于该插件类型中的插件再进行插件分类，设计为枚举类型
  late PluginCategory category;

  // 启用状态
  late bool status;

  // 是否为evc文件
  late bool evc;

  // 文件路径
  late String path;

  // 插件数据存储模型
  late PluginModel pluginModel;

  /*
  抽象实现接口1: 注册插件
   */
  registerPlugin() {
    //
  }

  /*
  抽象实现接口2:: 注销插件
   */
  dispose() {
    //
  }

  /*
  初始化插件
   */
  void initial() {
    //
  }
}
