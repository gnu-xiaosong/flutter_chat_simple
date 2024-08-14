/*
插件类:抽象类接口
 */
import 'package:socket_service/microService/pluginSystem/pluginInsert/PluginCategory.dart';

import 'PluginType.dart';

// 插件分类类别
class Plugin {
  // 插件ID：唯一性标识
  String? id;

  // 插件名称
  late String name;

  // 插件类型: 采用枚举类型T
  late PluginType type;

  // 插件分类: 即对于该插件类型中的插件再进行插件分类，设计为枚举类型
  late PluginCategory category;

  // 启用状态
  late bool status;

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
