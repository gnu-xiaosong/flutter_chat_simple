/*
该类为Hive中自定义类型的模型实体
 */

import 'package:hive/hive.dart';

@HiveType(typeId: 1) // typeId 必须唯一
class PluginModel extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final DateTime time;

  @HiveField(3)
  final bool evc;

  @HiveField(4)
  final String path;

  // 构造函数
  PluginModel({
    required this.name,
    required this.category,
    required this.path,
    required this.evc,
    DateTime? time,
  }) : time = time ?? DateTime.now();

  // 可选：重写 toString 方法，便于调试
  @override
  String toString() {
    return 'PluginModel{name: $name, category: $category, time: $time, evc: $evc, path: $path}';
  }
}
