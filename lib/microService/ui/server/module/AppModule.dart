/*
项目配置模块
 */
import 'dart:io';

import 'package:app_template/microService/ui/server/module/StoreDataModule.dart';
import '../model/AppConfigModel.dart';

class AppModule extends StoreDataModule {
  /*
  获取内网ip
   */
  Future<String> getLocalIpAddress() async {
    String localIp = 'Not Found';
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (addr.address.contains('.')) {
          // To ensure it is an IPv4 address
          localIp = addr.address;
          break;
        }
      }
    }
    return localIp;
  }

  /*
  读取文件的配置信息
   */
  AppConfigModel? getAppConfig() {
    Map<String, dynamic>? data = getServerConfigInHive();
    if (data == null) {
      return null;
    } else {
      return AppConfigModel.fromJson(data);
    }
  }
}
