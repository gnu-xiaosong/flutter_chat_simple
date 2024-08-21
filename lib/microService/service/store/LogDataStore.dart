import 'package:hive/hive.dart';
import '../server/model/LogModel.dart';

class LogDataStore {
  static var box = Hive.box('common');
  static var name = "logModelList";

  /*
  获取日志模型列表
   */
  static List<LogModel> getLogModelListInHive() {
    List logModelList = box.get(name, defaultValue: <Map>[]);
    List<LogModel> logModelLists = logModelList.map((json) {
      return LogModel.fromJson(Map<String, dynamic>.from(json));
    }).toList();
    return logModelLists;
  }

  /*
  异步添加日志信息到列表
   */
  Future<void> addLogInfo(Map<String, dynamic> json) async {
    // 取出
    List a = box.get(name, defaultValue: <Map>[]);

    // 增加:剔除已存在的
    a.removeWhere((json1) => json["id"] == json1["id"]);
    // 增加
    a.add(Map<String, dynamic>.from(json));
    // 存储
    box.put(name, a);
  }

  /*
  异步删除日志信息
  @parameter: id - 插件的唯一标识符
   */
  Future<void> deleteLogInfo(String id) async {
    // 取出
    List a = box.get(name, defaultValue: <Map>[]);

    // 增加:剔除已存在的
    a.removeWhere((json) => LogModel.fromJson(json).id == id);

    // 存储
    box.put(name, a);
  }

  /*
  删除所有
   */
  clearLogsInHive() {
    box.clear();
  }

  /*
  异步更新日志信息
  @parameter: id - 插件的唯一标识符
  @parameter: updatedPlugin - 更新后的插件模型
   */
  Future<void> updateLogInfo(String id, Map<String, dynamic> json) async {
    LogModel b = LogModel.fromJson(json);
    // 取出
    List a = box.get(name, defaultValue: <Map>[]);

    // 更新
    a = a.map((json) {
      LogModel c = LogModel.fromJson(json);
      if (c.id == id) {
        // 目标
        return b.toJson();
      }
      return json;
    }).toList();

    // 存储
    box.put(name, a);
  }
}
