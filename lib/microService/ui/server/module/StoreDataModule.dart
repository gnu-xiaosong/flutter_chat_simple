/*
数据存储模块server端
 */
import 'dart:io';

import 'package:hive/hive.dart';

import '../../common/module/ServerStoreDataCommonModule.dart';

class ServerStoreDataModule extends ServerStoreDataCommonModule {
  // 打开box
  var box = Hive.box('server');

  /*
  初始化
   */
  initial() {
    setIsRunningInHive(false);
    setHttpIsRunningInHive(false);
  }

  /*
  获取http端口
   */
  int getHttpPortInHive() {
    return int.parse(box.get("httpPort", defaultValue: 5200).toString());
  }

  /*
  设置http端口
   */
  setHttpPortInHive(int port) {
    box.put("httpPort", port);
  }

  /*
  获取断线重连次数
   */
  int getMaxRetryInHive() {
    return int.parse(box.get("maxRetry", defaultValue: 10).toString());
  }

  /*
  设置断线重连次数
   */
  setMaxRetryInHive(int max) {
    box.put("maxRetry", max);
  }

  /*
  获取断线重连参数
   */
  bool getRetryInHive() {
    return box.get("retry", defaultValue: true);
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
    return box.get("darkMode", defaultValue: false);
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
    var isRunning = box.get("isRunning", defaultValue: false);

    // 获取
    return isRunning;
  }

  /*
  设置Hive中的server运行状态bool
   */
  void setIsRunningInHive(bool result) {
    box.put("isRunning", result);
  }

  /*
  获取Hive中的http server运行状态bool
   */
  bool getHttpIsRunningInHive() {
    var isRunning = box.get("httpIsRunning", defaultValue: false);

    // 获取
    return isRunning;
  }

  /*
  设置Hive中的http server运行状态bool
   */
  void setHttpIsRunningInHive(bool result) {
    box.put("httpIsRunning", result);
  }
}
