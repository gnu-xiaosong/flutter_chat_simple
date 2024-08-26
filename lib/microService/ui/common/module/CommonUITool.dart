import 'dart:io';

import 'package:flutter/material.dart';

class CommonUITool {
  Widget loadImage(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      // 网络图片
      return Image.network(path, fit: BoxFit.cover);
    } else if (path.startsWith('/')) {
      // 本地文件系统图片
      return Image.file(File(path), fit: BoxFit.cover);
    } else {
      // asset 图片
      return Image.asset(path, fit: BoxFit.cover);
    }
  }
}
