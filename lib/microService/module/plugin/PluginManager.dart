import 'PluginType.dart';
import 'common.dart';
import 'extensions/EnumExtension.dart';
import 'plugin/FunctionalityPlugin.dart';
import 'pluginInsert/PluginCategory.dart';
import 'pluginInsert/PluginInsertPointManager.dart';
import './storeData/ServerStoreDataPlugin.dart';
import 'Plugin.dart';
import 'storeData/PluginInfoDataStore.dart';
import 'storeData/PluginModel.dart';

class PluginManager extends ServerStoreDataPlugin with PluginCommon {
  // 私有构造函数，确保无法从外部实例化该类
  PluginManager._privateConstructor();
  // 静态变量，保存类的唯一实例
  static final PluginManager _instance = PluginManager._privateConstructor();

  // 存储已注册的插件
  static List<Plugin> _registeredPlugins = [];

  // 提供公共的静态方法来获取类的唯一实例
  factory PluginManager() {
    // 初始化管理器
    _initial();
    return _instance;
  }

  /*
   初始化管理器
   */
  static void _initial() {
    // 加载本地存储的插件列表
    loadPluginFromStore();
  }

  /*
   实例化一个注入器
   用法:
   */
  final PluginInsertPointManager pluginInjector = PluginInsertPointManager();

  /*
   从存储中加载插件列表
   */
  static void loadPluginFromStore() {
    // 从本地存储获取插件列表
    List<PluginModel> pluginModels =
        ServerStoreDataPlugin.getPluginListInHive();
    // 取出封装插件
    pluginModels.forEach((pluginModel) {
      late Plugin value;
      /*
       根据不同插件类型封装插件plugin
       */
      switch (PluginTypeEnumExtension.fromIndex(pluginModel.type)) {
        case PluginType.Functionality:
          value = FunctionalityPlugin(
            id: pluginModel.id,
            evc: pluginModel.evc,
            time: pluginModel.time,
            status: pluginModel.status,
            category: PluginCategory.values[pluginModel.category],
            path: pluginModel.path,
            name: pluginModel.name,
          );
          break;
        case PluginType.Integration:
          // 处理 Integration 类型
          break;
        case PluginType.UI:
          // 处理 UI 类型
          break;
        case PluginType.Security:
          // 处理 Security 类型
          break;
        case PluginType.Analytics:
          // 处理 Analytics 类型
          break;
        case PluginType.ContentManagement:
          // 处理 ContentManagement 类型
          break;
        case PluginType.DevelopmentTools:
          // 处理 DevelopmentTools 类型
          break;
        case PluginType.Automation:
          // 处理 Automation 类型
          break;
        case PluginType.DataProcessing:
          // 处理 DataProcessing 类型
          break;
        case PluginType.Communication:
          // 处理 Communication 类型
          break;
        case PluginType.miniApp:
          // 处理 miniApp 类型
          break;
        default:
          // 处理未知类型
          throw ArgumentError('Unknown PluginType: ${pluginModel.type}');
      }
      // add进入
      _registeredPlugins.add(value);
    });
  }

  /*
   注册插件
   */
  void registerPlugin(Plugin plugin) {
    // 添加进入数组中
    _registeredPlugins.add(plugin);
    print('Plugin registered successfully.');
    print(
        "+++++++++++++++++++++++++++++++++++: ${plugin.pluginModel.toJson()}");
    // 存储在本地
    addPluginInfo(plugin.pluginModel.toJson());

    // 调用插件本身注册插件
    plugin.registerPlugin();
  }

  /*
   注销插件
   */
  void unregisterPlugin(String id) {
    print("Unregistering plugin: id=$id");
    // 移除列表元素
    _registeredPlugins.removeWhere((plugin) {
      if (plugin.id == id) {
        // 调用插件本身注销函数
        plugin.dispose();
        return true;
      }
      return false;
    });
    // 删除在本地存储
    deletePluginInfo(id);
  }

  /*
   获取已注册的插件
   */
  Plugin? getPlugin(String id) {
    return _registeredPlugins.firstWhere((plugin) => plugin.id == id,
        orElse: () => null!);
  }

  /*
   初始化所有已注册的插件
   */
  void initialAll() {
    print("Initializing all plugins");
    _registeredPlugins.forEach((plugin) {
      plugin.initial();
    });
  }

  /*
   获取所有已注册的插件
   */
  List<Plugin> getRegisterPlugins() {
    return _registeredPlugins;
  }

  /*
   根据提供的pluginType获取所有插件
   */
  List<Plugin> getPluginsByType(PluginType pluginType) {
    return _registeredPlugins
        .where((plugin) => plugin.type == pluginType)
        .toList();
  }

  /*
   释放所有已注册插件
   */
  void disposeAll() {
    print("Disposing all plugins");
    // 执行各个插件的释放函数
    _registeredPlugins.forEach((plugin) {
      plugin.dispose();
    });
    // 清除列表
    _registeredPlugins.clear();
    // 释放本地存储的插件
    clearPluginsInHive();
  }
}
