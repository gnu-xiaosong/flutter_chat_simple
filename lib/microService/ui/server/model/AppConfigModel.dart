/*
APP全局配置信息模型
 */
import 'package:hive/hive.dart';
import '../module/AppModule.dart';

class AppConfigModel extends AppModule {
  // app应用名称
  String _name;
  // websocket ip地址
  String _websocketIp;
  // websocket port端口地址
  int _websocketPort;

  AppConfigModel({
    required String name,
    required String websocketIp,
    required int websocketPort,
  })  : _name = name,
        _websocketIp = websocketIp,
        _websocketPort = websocketPort;

  // Getters
  String get name => _name;
  String get websocketIp => _websocketIp;
  int get websocketPort => _websocketPort;

  // Setters
  set name(String value) {
    _name = value;
    // 保存配置文件
    storeData();
  }

  set websocketIp(String value) {
    _websocketIp = value;
    // 保存配置文件
    storeData();
  }

  set websocketPort(int value) {
    _websocketPort = value;
    // 保存配置文件
    storeData();
  }

  // Factory method to create an instance from JSON
  factory AppConfigModel.fromJson(Map<String, dynamic> json) {
    return AppConfigModel(
      name: json['name'],
      websocketIp: json['websocket_ip'],
      websocketPort: json['websocket_port'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': _name,
      'websocket_ip': _websocketIp,
      'websocket_port': _websocketPort,
    };
  }

  /*
  保存数据
   */
  void storeData() {
    // 保存配置文件
    var box = Hive.box('app');
    box.put("serverConfig", toJson());
  }
}
