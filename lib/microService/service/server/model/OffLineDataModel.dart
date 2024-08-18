/*
离线数据存储模型
 */

// 离线消息处理类型
import 'dart:convert';

enum OffLineType {
  message, // 消息类型
  addUser // 添加用户消息类型
}

class OffLineDataModel {
  // 唯一性id
  late String id;

  // 消息类型
  late OffLineType type;

  // 设备唯一性id
  late String deviceId;

  // 传输消息
  late Map<String, dynamic> content;

  OffLineDataModel({
    required this.id,
    required this.type,
    required this.deviceId,
    required this.content,
  });

  // Converts the model to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type.index, // Assuming OffLineType has a toString method
      'deviceId': deviceId,
      'content': content,
    };
  }

  @override
  String toString() {
    return "${toMap()}";
  }

  // Converts the model to a JSON string
  String toJson() {
    return jsonEncode(toMap());
  }

  // Create a factory method to generate an instance from a map
  factory OffLineDataModel.fromMap(Map<String, dynamic> map) {
    return OffLineDataModel(
      id: map['id'],
      type: OffLineType.values[int.parse(map['type'].toString())],
      deviceId: map['deviceId'],
      content: Map<String, dynamic>.from(map['content']),
    );
  }

  // Create a factory method to generate an instance from a JSON string
  factory OffLineDataModel.fromJson(String source) {
    return OffLineDataModel.fromMap(jsonDecode(source));
  }
}
