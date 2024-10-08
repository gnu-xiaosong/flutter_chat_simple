/*
 * @Author: xskj
 * @Date: 2023-12-31 19:23:17
 * @LastEditors: xskj
 * @LastEditTime: 2023-12-31 19:23:41
 * @Description: 工具管理器类
 */
import 'dart:ui';

import '../../../config/AppConfig.dart';
import '../../../models/AppModel.dart';

class ToolsManager {
  static AppModel loadAppModelConfig() {
    return AppModel.fromJson(AppConfig.appConfig);
  }

  //将普通颜色转化为Color对象
  static Color colorToMaterialColor(String color) {
    //var c = "dc380d";
    //Color(int.parse(c,radix:16)|0xFF000000);//通过位运算符将Alpha设置为FF
    return Color(int.parse(color, radix: 16)).withAlpha(255); //通过方法将Alpha设置为FF
  }

  void printLongString(String str) {
    const int chunkSize = 800; // 每次打印的字符数
    int startIndex = 0;
    while (startIndex < str.length) {
      int endIndex = startIndex + chunkSize;
      if (endIndex > str.length) {
        endIndex = str.length;
      }
      print(str.substring(startIndex, endIndex));
      startIndex = endIndex;
    }
  }
}
