/*
公共函数
 */

import 'dart:io';
import 'package:dart_eval/dart_eval_bridge.dart';

mixin PluginCommon {
  // 包名
  String packetName = "plugin_system";

  /*
  index转枚举值
   */

  /*
  读取文件内容
   */
  String readFileContent(String path) {
    // 指定文件路径
    var file = File(path);

    // 检查文件是否存在
    if (file.existsSync()) {
      // 读取文件内容
      String contents = file.readAsStringSync();

      // 输出文件内容
      return contents;
    } else {
      print('File does not exist at the specified path: $path');
      return "";
    }
  }

  /*
  读取文件二进制byte
   */
  readFileBytes(String path) {
    // 指定文件路径
    var file = File(path);

    // 检查文件是否存在
    if (file.existsSync()) {
      // 读取文件内容
      final bytes = file.readAsBytesSync().buffer.asByteData();

      // 输出文件内容
      return bytes;
    } else {
      print('File does not exist at the specified path: $path');
    }
  }

  /*
  从$Value中解构出Value值
   valueList: $value列表
   index  取出的列表index
   */
  dynamic getValueFrom$Value(List<$Value?> valueList, {int index = 0}) =>
      valueList[index]?.$reified;
}
