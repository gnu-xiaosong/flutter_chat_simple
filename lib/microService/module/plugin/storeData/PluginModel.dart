/*
该类为Hive中自定义类型的模型实体
 */
import 'package:uuid/uuid.dart';

class PluginModel {
  final String name;

  final int type;

  final int category;

  final DateTime time;

  final bool evc;

  final String path;

  final String id;

  final bool status;

  // 构造函数
  PluginModel(
      {required this.name,
      required this.type,
      required this.status,
      required this.category,
      required this.path,
      required this.evc,
      String? id,
      DateTime? time})
      : id = id ?? Uuid().v4(),
        time = time ?? DateTime.now();

  // 可选：重写 toString 方法，便于调试
  @override
  String toString() {
    return 'PluginModel{id: $id, name: $name, category: $category, time: $time, evc: $evc, path: $path}';
  }

  // 将 PluginModel 实例转换为 JSON 对象
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'category': category,
      'time': time.toIso8601String(), // 转换 DateTime 为 ISO 8601 格式字符串
      'evc': evc,
      'path': path,
      'id': id,
      'status': status,
    };
  }

  // 从 JSON 对象创建 PluginModel 实例
  factory PluginModel.fromJson(Map<String, dynamic> json) {
    return PluginModel(
      name: json['name'],
      type: json['type'],
      category: json['category'],
      time: DateTime.parse(json['time']),
      evc: json['evc'],
      path: json['path'],
      id: json['id'],
      status: json['status'],
    );
  }
}
