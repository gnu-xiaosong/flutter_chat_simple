/*
Functionality插件类型的实现
 */
import 'package:uuid/uuid.dart';

import '../Plugin.dart';
import '../PluginType.dart';
import '../pluginInsert/PluginCategory.dart';
import '../storeData/PluginModel.dart';

class FunctionalityPlugin extends Plugin {
  /*
  初始化传参
   */
  FunctionalityPlugin(
      {required PluginCategory category,
      bool? evc,
      String? id,
      DateTime? time,
      required String path,
      bool? status,
      required String name}) {
    this.evc = evc ?? true;
    this.name = name;
    this.path = path;
    this.category = category;
    this.status = status ?? true;
    this.id = id ?? const Uuid().v4();
    this.time = time ?? DateTime.now();
    this.type = PluginType.Functionality;

    // 初始化pluginModel
    this.pluginModel = PluginModel(
        id: this.id,
        name: this.name,
        category: this.category.index,
        path: this.path,
        evc: this.evc,
        type: this.type.index,
        status: this.status);
  }

  @override
  dispose() {
    // 实现该类型插件操作：在插件被释放时调用
    print("FunctionalityPlugin: 释放插件");
  }

  @override
  void initial() {
    // 实现该类型插件操作: 在插件再初始化时调用
    print("FunctionalityPlugin: 初始化插件");
  }

  @override
  registerPlugin() {
    // 实现该类型插件操作：在插件注册时被调用
    print("FunctionalityPlugin: 注册插件");
  }
}
