/*
项目配置模块
 */
import 'dart:io';
import '../model/AppConfigModel.dart';
import 'StoreDataModule.dart';

class AppModule extends ServerStoreDataModule {
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
