import 'package:hive/hive.dart';

class AppClientSettingModel {
  // 用户名称
  String _username;

  // server ip
  String _serverIp;

  // server port端口地址
  int _serverPort;

  // http ip
  String _httpIp;

  // http port端口地址
  int _httpPort;

  // websocket协议类型
  String _wsType;

  AppClientSettingModel({
    required String username,
    required String serverIp,
    required int serverPort,
    required String httpIp,
    required int httpPort,
    required String wsType,
  })  : _username = username,
        _serverIp = serverIp,
        _serverPort = serverPort,
        _httpIp = httpIp,
        _httpPort = httpPort,
        _wsType = wsType;

  // Getters
  String get username => _username;
  String get serverIp => _serverIp;
  int get serverPort => _serverPort;
  String get httpIp => _httpIp;
  int get httpPort => _httpPort;
  String get wsType => _wsType;

  // Setters with automatic data storing
  set username(String value) {
    _username = value;
    storeData();
  }

  set serverIp(String value) {
    _serverIp = value;
    storeData();
  }

  set serverPort(int value) {
    _serverPort = value;
    storeData();
  }

  set httpIp(String value) {
    _httpIp = value;
    storeData();
  }

  set httpPort(int value) {
    _httpPort = value;
    storeData();
  }

  set wsType(String value) {
    _wsType = value;
    storeData();
  }

  // Factory method to create an instance from JSON
  factory AppClientSettingModel.fromJson(Map<String, dynamic> json) {
    return AppClientSettingModel(
      username: json['username'],
      serverIp: json['serverIp'],
      serverPort: json['serverPort'],
      httpIp: json['httpIp'],
      httpPort: json['httpPort'],
      wsType: json['wsType'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': _username,
      'serverIp': _serverIp,
      'serverPort': _serverPort,
      'httpIp': _httpIp,
      'httpPort': _httpPort,
      'wsType': _wsType,
    };
  }

  /*
  保存数据
   */
  void storeData() {
    var box = Hive.box('client');
    box.put("clientConfig", toJson());
  }
}
