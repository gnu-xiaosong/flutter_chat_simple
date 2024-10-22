/*
desc: ChatDao类DAO操作: 聊天记录DAO类集中管理 CRUD 操作
*/

import 'package:drift/drift.dart';
import 'package:socket_service/microService/module/common/Console.dart';

import '../../microService/module/manager/GlobalManager.dart';
import '../LocalStorage.dart';
import 'BaseDao.dart';

class ChatDao with Console implements BaseDao<Chat> {
  // 获取database单例
  var db = GlobalManager.database;
  /*
   根据双方deviceId查询聊天信息
   列表
   */
  Future<List<Chat>> selectChatMessagesByDeviceId(
      ChatsCompanion chatsCompanion) async {
    // 构建查询: 获取双方的聊天信息，限制20条
    final query = db.select(db.chats)
          ..where((tbl) =>
              (tbl.senderId.equals(chatsCompanion.recipientId.value!) |
                  tbl.recipientId.equals(chatsCompanion.recipientId.value!)))
          ..orderBy([
            (tbl) => OrderingTerm.asc(tbl.timestamp)
          ]) // 或者使用 `tbl.id` 代替 `tbl.timestamp`
        ;

    // 获取查询结果
    final result = await query.get();
    printSuccess("查询聊天数量:${result.toList().length}");
    return result.toList();
  }

  // 插入聊天信息
  Future<dynamic> insertChat(ChatsCompanion chatsCompanion) async {
    // 构建
    final result = await db.into(db.chats).insert(chatsCompanion);
    printSuccess("@@@@@插入结果: ${result}");
    return result;
  }

  // 更新数据
  Future<int> updateChat(ChatsCompanion chatsCompanion) async {
    // 获取database单例
    var db = GlobalManager.database;
    int result = 0;
    await db.update(db.chats)
      ..where((tbl) => tbl.id.equals(chatsCompanion.id.value))
      ..write(chatsCompanion).then((value) {
        // print("update result: $value");
        result = value;
      });

    return result;
  }

  // 删除数据
  int deleteChat(ChatsCompanion chatsCompanion) {
    // 获取database单例
    var db = GlobalManager.database;
    // 删除条数
    int result = 0;
    db.delete(db.users)
      ..where((tbl) => tbl.id.equals(chatsCompanion.id as int))
      ..go().then((value) {
        // print("delete data count: $value");
        result = value;
      });

    return result;
  }
}
