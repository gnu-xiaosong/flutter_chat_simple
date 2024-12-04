/*
server端群组管理模块
 */
import '../../../module/manager/GroupManager.dart';

class GroupInServerManeger extends GroupManager {
  /*
  创建群组
  [name] 群组名称
  [description] 群组描述
  [creatorId] 群组创建者的用户 ID
   返回创建的群组 ID
   */
  @override
  String createGroup(String name, String description, String creatorId) {
    return null ?? "";
  }

  /*
   删除群组
   [groupId] 要删除的群组 ID
   返回创建的群组 ID
   */
  @override
  bool deleteGroup(String groupId) {
    return true;
  }

  /*
  查询群组
  [groupId] 群组 ID
   */
  Map<String, dynamic> getGroup(String groupId) {
    return null ?? {};
  }

  /*
  修改群组信息
  [groupId] 群组 ID
  [name] 新的群组名称（可选）
  [description] 新的群组描述（可选）
   */
  void updateGroup(String groupId, {String? name, String? description}) {
    throw UnimplementedError();
  }
}
