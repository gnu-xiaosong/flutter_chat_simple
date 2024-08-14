/*
插件注入点抽象类
 */

import 'package:socket_service/microService/pluginSystem/Plugin.dart';
import 'package:socket_service/microService/pluginSystem/PluginType.dart';
import 'PluginInsertPointType.dart';

abstract class PluginInsertPoint {
  // plugin插件类型: PluginType
  PluginType get type;

  // 串并联控制类型
  ConPluginType get pluginConnType;

  // 已注册的插件: 用于使用插件  使用(插件类型、插件类别)确定插件集合
  List<Plugin> get pluginAll;
}
