/*
枚举的拓展
 */

import '../PluginType.dart';
import '../pluginInsert/PluginCategory.dart';

/*
PluginType枚举类型拓展
 */
extension PluginTypeEnumExtension on PluginType {
  // 将整数索引转换为 PluginType 值
  static PluginType fromIndex(int index) {
    if (index < 0 || index >= PluginType.values.length) {
      throw ArgumentError('Invalid index: $index');
    }
    return PluginType.values[index];
  }

  // 根据字符串获取 PluginType 枚举值
  static PluginType fromString(String type) {
    switch (type) {
      case 'Functionality':
        return PluginType.Functionality;
      case 'Integration':
        return PluginType.Integration;
      case 'UI':
        return PluginType.UI;
      case 'Security':
        return PluginType.Security;
      case 'Analytics':
        return PluginType.Analytics;
      case 'ContentManagement':
        return PluginType.ContentManagement;
      case 'DevelopmentTools':
        return PluginType.DevelopmentTools;
      case 'Automation':
        return PluginType.Automation;
      case 'DataProcessing':
        return PluginType.DataProcessing;
      case 'Communication':
        return PluginType.Communication;
      case 'miniApp':
        return PluginType.miniApp;
      default:
        throw ArgumentError('Invalid PluginType string: $type');
    }
  }

  // 获取枚举的字符串名称
  String get name => toString().split('.').last;
}

/*
PluginType枚举类型拓展
 */
extension PluginCategoryEnumExtension on PluginCategory {
  // 将整数索引转换为 PluginType 值
  static PluginCategory fromIndex(int index) {
    print("================================================");
    print("index=$index  enum=${PluginCategory.values[index]}");
    if (index < 0 || index >= PluginCategory.values.length) {
      throw ArgumentError('Invalid index: $index');
    }
    return PluginCategory.values[index];
  }

  // 根据字符串获取 PluginCategory 枚举值
  static PluginCategory fromString(String category) {
    switch (category) {
      case 'Authentication':
        return PluginCategory.Authentication;
      case 'Backup':
        return PluginCategory.Backup;
      case 'Communication':
        return PluginCategory.Communication;
      case 'Database':
        return PluginCategory.Database;
      case 'Encryption':
        return PluginCategory.Encryption;
      case 'FileManagement':
        return PluginCategory.FileManagement;
      case 'Graphics':
        return PluginCategory.Graphics;
      case 'Hosting':
        return PluginCategory.Hosting;
      case 'Integration':
        return PluginCategory.Integration;
      case 'JobScheduler':
        return PluginCategory.JobScheduler;
      case 'KeyManagement':
        return PluginCategory.KeyManagement;
      case 'Reporting':
        return PluginCategory.Reporting;
      case 'Monitoring':
        return PluginCategory.Monitoring;
      case 'Notification':
        return PluginCategory.Notification;
      case 'Optimization':
        return PluginCategory.Optimization;
      case 'Payment':
        return PluginCategory.Payment;
      case 'QueryProcessing':
        return PluginCategory.QueryProcessing;
      default:
        throw ArgumentError('Invalid PluginCategory string: $category');
    }
  }

  // 获取枚举的字符串名称
  String get name => toString().split('.').last;
}
