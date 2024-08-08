/*
数据存储模块
 */
import 'dart:io';

import 'package:hive/hive.dart';

class StoreDataModule {
  // 打开box
  var box = Hive.box('app');

  /*
   初始化所有参数值
   */
  initialHiveParameter() async {
    getIsRunningInHive();
    getServerConfigInHive();
    getDarkModeInHive();
    getRetryInHive();
    getMaxRetryInHive();
    // 初始化参数
    setIsRunningInHive(false);
  }

  /*
  获取断线重连次数
   */
  double getMaxRetryInHive() {
    var serverConfig = box.get("maxRetry");
    if (serverConfig == null) {
      print("---------serverConfig Hive is not exist----------------");
      // 无，创建
      box.put("maxRetry", 10.0);
    }
    return double.parse(box.get("maxRetry").toString());
  }

  /*
  设置断线重连次数
   */
  setMaxRetryInHive(double max) {
    box.put("maxRetry", max);
  }

  /*
  获取断线重连参数
   */
  bool getRetryInHive() {
    var serverConfig = box.get("retry");
    if (serverConfig == null) {
      print("---------serverConfig Hive is not exist----------------");
      // 无，创建
      box.put("retry", true);
    }
    return box.get("retry");
  }

  /*
  设置断线重连参数
   */
  setRetryInHive(bool mode) {
    box.put("retry", mode);
  }

  /*
  模式获取：dark，light
   */
  bool getDarkModeInHive() {
    var serverConfig = box.get("darkMode");
    if (serverConfig == null) {
      print("---------serverConfig Hive is not exist----------------");
      // 无，创建
      box.put("darkMode", false);
    }
    return box.get("darkMode");
  }

  /*
  模式切换：dark，light
   */
  setDarkModeInHive(bool mode) {
    box.put("darkMode", mode);
  }

  /*
  获取Hive中box=app的serverConfig的键值
   */
  Map<String, dynamic>? getServerConfigInHive() {
    var serverConfig = box.get("serverConfig");
    if (serverConfig == null) {
      print("---------serverConfig Hive is not exist----------------");
      // 无，创建
      Map<String, dynamic> config = {
        "name": "websocket server",
        "websocket_ip": InternetAddress.anyIPv4.address,
        "websocket_port": 1314,
      };
      box.put("serverConfig", config);
    }

    serverConfig = box.get("serverConfig");

    if (serverConfig is Map) {
      Map<String, dynamic> serverConfigMap =
          Map<String, dynamic>.from(serverConfig);
      print('Server Config: $serverConfigMap');
      //转为AppConfigModel
      return serverConfigMap;
    } else {
      print('serverConfig is not a Map');
      return null;
    }
  }

  /*
  获取Hive中的server运行状态bool
   */
  bool getIsRunningInHive() {
    var isRunning = box.get("isRunning");
    if (isRunning == null) {
      print("---------serverConfig Hive is not exist----------------");
      // 无，创建
      box.put("isRunning", false);
    }
    // 获取
    return box.get("isRunning");
  }

  /*
  设置Hive中的server运行状态bool
   */
  void setIsRunningInHive(bool result) {
    box.put("isRunning", result);
  }
}
