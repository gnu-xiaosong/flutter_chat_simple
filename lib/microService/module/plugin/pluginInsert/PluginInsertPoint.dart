/*
插件注入点抽象类
 */
import '../Plugin.dart';
import '../PluginType.dart';
import 'PluginInsertPointType.dart';

abstract class PluginInsertPoint {
  // plugin插件类型: PluginType
  PluginType get type;

  // 串并联控制类型
  ConPluginType get pluginConnType;

  // 已注册的插件: 用于使用插件  使用(插件类型、插件类别)确定插件集合
  List<Plugin> get pluginAll;

  List<Plugin> getAllModulePlugin();

  /*
   运行程序函数: 数据封装
   */
  dynamic run(dynamic data);

  /*
  初始化
   */
  initial();

  /*
   输入数据处理装饰函数
   */
  dynamic inputDataHandler(dynamic data);

  /*
  输出数据处理装饰函数
   */
  dynamic outputDataHandler(dynamic data);
}
