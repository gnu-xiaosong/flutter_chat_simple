/*
Functionality插件类型的实现
 */
import 'package:socket_service/microService/pluginSystem/Plugin.dart';
import 'package:socket_service/microService/pluginSystem/PluginType.dart';
import 'package:uuid/uuid.dart';
import '../pluginInsert/PluginCategory.dart';

class FunctionalityPlugin extends Plugin {
  /*
  初始化传参
   */
  FunctionalityPlugin(
      {required PluginCategory category, required String name}) {
    super.name = name;
    super.category = category;
    super.id = const Uuid().v4();
    super.status = true;
    super.type = PluginType.Functionality;
  }

  @override
  dispose() {
    // 实现该类型插件操作：在插件被释放时调用
  }

  @override
  void initial() {
    // 实现该类型插件操作: 在插件再初始化时调用
  }

  @override
  registerPlugin() {
    // 实现该类型插件操作：在插件注册时被调用
  }
}
