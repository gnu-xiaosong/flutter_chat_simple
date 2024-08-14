/*
Functionality模块注入点实现类
 */

import 'package:socket_service/microService/pluginSystem/Plugin.dart';
import 'package:socket_service/microService/pluginSystem/PluginType.dart';
import 'package:socket_service/microService/pluginSystem/pluginInsert/PluginCategory.dart';
import 'package:socket_service/microService/pluginSystem/pluginInsert/PluginInsertPoint.dart';
import 'package:socket_service/microService/pluginSystem/pluginInsert/PluginInsertPointType.dart';

class FunctionalityInsertPoint implements PluginInsertPoint {
  @override
  List<Plugin> get pluginAll => [];

  @override
  ConPluginType get pluginConnType => throw UnimplementedError();

  @override
  PluginType get type => throw UnimplementedError();

  /*
  根据指定的插件类别获取对应的插件列表
   */
  List<Plugin> getPluginsByCategory(PluginCategory pluginCategory) {
    return pluginAll
        .where((plugin) => plugin.category == pluginCategory)
        .toList();
  }
}
