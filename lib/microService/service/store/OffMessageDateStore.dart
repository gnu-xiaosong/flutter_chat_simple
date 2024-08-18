/*
离线消息本地持久还存储
 */
import 'package:hive/hive.dart';
import 'package:socket_service/microService/module/encryption/MessageEncrypte.dart';
import 'package:socket_service/microService/module/manager/GlobalManager.dart';
import '../server/model/OffLineDataModel.dart';

class OffMessageDateStore {
  static var box = Hive.box('offLineBox');
  static var name = "offDataList";

  /*
   初始化所有参数值
   */
  static Future<void> initialize() async {
    await Hive.openBox('offLineBox');
  }

  /*
  获取插件模型列表
   */
  static List<OffLineDataModel> getPluginListInHive() {
    List commandInfoList = box.get(name, defaultValue: <Map>[]);
    List<OffLineDataModel> commandInfoListOffLineDataModel =
        commandInfoList.map((json) {
      return OffLineDataModel.fromMap(Map<String, dynamic>.from(json));
    }).toList();
    return commandInfoListOffLineDataModel;
  }

  /*
  异步添加插件信息到列表
   */
  Future<void> addOffLineData(Map<String, dynamic> json) async {
    // 取出
    List commandInfoList = box.get(name, defaultValue: <Map>[]);

    // 增加:剔除已存在的
    commandInfoList.removeWhere((json1) => json1["id"] == json["id"]);
    // 增加: 枚举转换位int

    commandInfoList.add(json);
    // 存储
    box.put(name, commandInfoList);
  }

  /*
  异步删除插件信息
  @parameter: id - 插件的唯一标识符
   */
  Future<void> deleteOffData(String id) async {
    // 取出
    List OffDataList = box.get(name, defaultValue: <Map>[]);

    // 增加:剔除已存在的
    OffDataList.removeWhere((json) => json["id"] == id);

    // 存储
    box.put(name, OffDataList);
  }

  /*
  删除所有
   */
  clearPluginsInHive() {
    box.clear();
  }
}
