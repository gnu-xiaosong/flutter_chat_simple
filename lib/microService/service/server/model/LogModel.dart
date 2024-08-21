/*
日志封装模型
*/

class LogModel {
  // id
  late String id;

  // 命令行类型
  late String type;

  // 创建时间
  late DateTime time;

  // 文本显示
  late String content;

  // 构造函数
  LogModel({
    required this.id,
    required this.type,
    required this.time,
    required this.content,
  });

  // 将 LogModel 转换为 Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'time': time.toString(),
      'content': content,
    };
  }

  // 将 LogModel 转换为 JSON 字符串
  String toJson() {
    return toMap().toString();
  }

  // 通过 JSON 创建 LogModel 实例
  factory LogModel.fromJson(Map<String, dynamic> json) {
    return LogModel(
      id: json['id'],
      type: json['type'],
      time: DateTime.parse(json['time']),
      content: json['content'],
    );
  }
}
