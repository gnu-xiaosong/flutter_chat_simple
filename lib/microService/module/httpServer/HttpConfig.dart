/*
http配置
 */

import 'dart:io';

import 'package:path_provider/path_provider.dart';

// import 'package:path_provider/path_provider.dart';

class HttpConfig {
  int port = 5200;
  late String workDir;

  HttpConfig() {
    setWorkDir();
  }

  // Set the working directory
  setWorkDir() async {
    // 适用于flutter版本
    workDir = (await getApplicationDocumentsDirectory()).path + "/httpServer";
    // 这里判断是否为纯dart脚本
    // workDir = "./source";

    // 创建目录
    final directory = Directory(workDir);
    if (!await directory.exists()) {
      // 如果目录不存在，则创建它
      await directory.create(recursive: true);
      print('Directory created: $workDir');
    } else {
      print('Directory already exists: $workDir');
    }
  }
}
