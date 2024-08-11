/*
项目配置模块
 */
import 'dart:io';
import '../../../module/common/CommonModule.dart';
import '../model/AppSettingModel.dart';
import 'ClientStoreDataModule.dart';
import 'StoreDataClientModule.dart';

class AppClientSettingModule extends StoreDataClientModule {
  CommonModel commonModel = CommonModel();
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
  AppClientSettingModel? getAppConfig() {
    Map<String, dynamic>? data = getClientConfigInHive();
    if (data == null) {
      return null;
    } else {
      return AppClientSettingModel.fromJson(data);
    }
  }
}
