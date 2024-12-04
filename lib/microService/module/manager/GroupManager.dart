/*
该类为群组管理基础类： server和client端继承该类实现具体逻辑
 */

import '../encryption/MessageEncrypte.dart';

class GroupManager extends MessageEncrypte {
  /// 创建群组
  /// [name] 群组名称
  /// [description] 群组描述
  /// [creatorId] 群组创建者的用户 ID
  /// 返回创建的群组 ID
  String createGroup(String name, String description, String creatorId) {
    throw UnimplementedError();
  }

  /// 删除群组
  /// [groupId] 要删除的群组 ID
  bool deleteGroup(String groupId) {
    throw UnimplementedError();
  }

  /// 修改群组信息
  /// [groupId] 群组 ID
  /// [name] 新的群组名称（可选）
  /// [description] 新的群组描述（可选）
  void updateGroup(String groupId, {String? name, String? description}) {
    throw UnimplementedError();
  }

  /// 查询群组
  /// [groupId] 群组 ID
  /// 返回群组的详细信息
  Map<String, dynamic> getGroup(String groupId) {
    throw UnimplementedError();
  }

  /// 处理消息
  /// [groupId] 群组 ID
  /// [senderId] 发送者的用户 ID
  /// [content] 消息内容
  /// [attachments] 附件列表（可选）
  void handleMessage(String groupId, String senderId, String content,
      {List<Map<String, dynamic>>? attachments}) {
    throw UnimplementedError();
  }
}
