/*
APP全局配置信息模型
 */
import 'package:hive/hive.dart';

class AppClientSettingModel {
  // 用户名称
  String _username;
  // server ip
  String _serverIp;
  // server port端口地址
  int _serverPort;
  // websocket协议类型
  String _wsType;

  AppClientSettingModel(
      {required String username,
      required String serverIp,
      required int serverPort,
      required String wsType})
      : _username = username,
        _serverIp = serverIp,
        _serverPort = serverPort,
        _wsType = wsType;

  // Getters
  String get username => _username;
  String get serverIp => _serverIp;
  int get serverPort => _serverPort;
  String get wsType => _wsType;

  // Setters
  set username(String value) {
    _username = value;
    // 保存配置文件
    storeData();
  }

  set serverIp(String value) {
    _serverIp = value;
    // 保存配置文件
    storeData();
  }

  set serverPort(int value) {
    _serverPort = value;
    // 保存配置文件
    storeData();
  }

  set wsType(String value) {
    _wsType = value;
    // 保存配置文件
    storeData();
  }

  // Factory method to create an instance from JSON
  factory AppClientSettingModel.fromJson(Map<String, dynamic> json) {
    return AppClientSettingModel(
      username: json['username'],
      serverIp: json['serverIp'],
      serverPort: json['serverPort'],
      wsType: json['wsType'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': _username,
      'serverIp': _serverIp,
      'serverPort': _serverPort,
      'wsType': _wsType
    };
  }

  /*
  保存数据
   */
  void storeData() {
    // 保存配置文件
    var box = Hive.box('client');
    box.put("clientConfig", toJson());
  }
}
