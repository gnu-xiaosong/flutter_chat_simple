/*
 * @Author: xskj
 * @Date: 2023-12-30 18:54:06
 * @LastEditors: xskj
 * @LastEditTime: 2023-12-30 21:52:07
 * @Description: api请求基类
 */
import 'package:dio/dio.dart';

import '../microService/module/manager/GlobalManager.dart';

class BasedApi extends GlobalManager {
  //基础url
  String baseUrl = "http://192.168.1.4:5200";
  // 创建 Dio 实例
  Dio dio = Dio();
  // 上传进度回调函数
  Function? onSendProgress;
}
