/*
 * @Author: xskj
 * @Date: 2023-12-29 13:25:12
 * @LastEditors: xskj
 * @LastEditTime: 2023-12-29 13:40:14
 * @Description: 测试工具类
 */

import 'package:dio/dio.dart';

import '../microService/module/common/Console.dart';

class TestManager with Console {
  // 公共调试函数
  static void debug() {
    print("------------------debug task test-----------");
    // 调试ADO
    // testADO();
  }

  //http返回数据打印输出
  static void textPrint(Response response) {
    print("----------------------测试调试-----------------");
    print("请求状态: ${response?.statusCode}");
    print("请求头: ${response?.headers}");
    print("请求参数: ${response?.requestOptions.toString()}");
    print("返回数据: ${response?.data}");
  }
}
