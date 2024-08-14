/*
功能拓展模块插件Functionality注入点类
 */
import 'package:socket_service/microService/pluginSystem/Plugin.dart';
import 'package:socket_service/microService/pluginSystem/PluginManager.dart';
import 'package:socket_service/microService/pluginSystem/PluginType.dart';
import 'package:socket_service/microService/pluginSystem/pluginInsert/PluginInsertPoint.dart';
import 'package:socket_service/microService/pluginSystem/pluginInsert/PluginInsertPointType.dart';

class FunctionalityModulePluginInsertPoint implements PluginInsertPoint {
  late PluginManager pluginManager;

  FunctionalityModulePluginInsertPoint() {
    // 实例化插件管理类
    pluginManager = PluginManager();
  }

  /*
  获取对应地所有插件
   */
  List<Plugin> _getAllModulePlugin() {
    List<Plugin> plugins = pluginManager
        .getRegisterPlugins()
        .map((plugin) {
          // 筛选出该模块插件类型的插件
          if (plugin.type == PluginType.Functionality) return true;
          return false;
        })
        .cast<Plugin>()
        .toList();
    return plugins;
  }

  /*
  实现存在的Functionality模块插件列表
   */
  @override
  List<Plugin> get pluginAll => _getAllModulePlugin();

  /*
  实现插件间连接的类型: 默认串联类型
   */
  @override
  ConPluginType get pluginConnType => ConPluginType.series;

  /*
  实现插件的类型:
   */
  @override
  PluginType get type => PluginType.Functionality;
}
