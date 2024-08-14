/*
命令行消息封装Hive模型
 */
import 'package:hive/hive.dart';

@HiveType(typeId: 0) // typeId 必须唯一
class CommandInfoModel extends HiveObject {
  @HiveField(0)
  String commandName;

  @HiveField(1)
  String commandDetail;

  @HiveField(2)
  DateTime timestamp;

  CommandInfoModel({
    required this.commandName,
    required this.commandDetail,
    required this.timestamp,
  });
}
