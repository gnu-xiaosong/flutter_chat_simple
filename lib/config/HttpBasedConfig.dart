/*
 * @Author: xskj
 * @Date: 2023-12-30 18:54:06
 * @LastEditors: xskj
 * @LastEditTime: 2023-12-30 21:52:07
 * @Description: http请求参数配置类
 */

import 'package:dio/dio.dart';

import '../microService/ui/client/model/AppSettingModel.dart';
import '../microService/ui/client/module/AppSettingModule.dart';
import 'AppConfig.dart';

AppClientSettingModule appModule = AppClientSettingModule();
AppClientSettingModel? appConfigModel = appModule.getAppConfig();

class HttpBasedConfig extends AppConfig {
  //配置参数
  final BaseOptions _httpBasedConfig = BaseOptions(
      //基本网址:暂时支持http协议
      baseUrl: "http://${appConfigModel?.httpIp}:${appConfigModel?.httpPort}",
      //连接超时
      connectTimeout: AppConfig.httpConfig['connectTimeout'],
      //接收超时
      receiveTimeout: AppConfig.httpConfig['receiveTimeout'],
      // //包头
      // headers: {"Content-Type": "application/json;Charset=UTF-8"},
      // //内容类型
      // contentType: 'application/json;Charset=UTF-8',

      //响应类型——期待已那种方式接收数据，默认是json
      responseType: ResponseType.plain);

  //获取基础配置
  BaseOptions get getBasedOptions => _httpBasedConfig;
}
