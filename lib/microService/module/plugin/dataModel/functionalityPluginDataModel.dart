/*
插件类型为Functionality的插件数据模型类
 */
import 'package:eval_annotation/eval_annotation.dart';

@Bind()
class FunctionalityPluginDataModel {
  final String id; // 模型id
  final String name; // 数据模型名称
  final Map<String, dynamic> payload; // 通讯数据

  FunctionalityPluginDataModel(
      {required this.id, required this.name, required this.payload});

  // 将数据模型对象转换为 Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'payload': payload,
    };
  }
}
