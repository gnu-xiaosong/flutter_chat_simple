/*
聊天的文件接口类
 */

import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../api/BasedApi.dart';

class FileHttpApi extends BasedApi {
  Future<Map<String, dynamic>?> uploadFile(String filePath,
      {Map<String, dynamic>? extraParams}) async {
    try {
      String api = "/upload";

      String url = baseUrl + api;
      print("URL:$url");

      // 构建 FormData，用于包含文件和其他参数
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(filePath,
            filename: filePath.split('/').last),
        if (extraParams != null) ...extraParams, // 如果有额外参数，加入到 FormData 中
      });

      // 打印调试信息
      print("开始上传文件: $filePath");

      // 发送 POST 请求上传文件
      Response response = await dio.post(
        url,
        data: formData,
        onSendProgress: (int sent, int total) {
          // onSendProgress!(sent, total);
          // 打印上传进度
          print("上传进度: ${((sent / total) * 100).toStringAsFixed(2)}%");
        },
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data", // 设置请求头
          },
        ),
      );

      // 检查响应状态码
      if (response.statusCode == 200) {
        print("文件上传成功: ${response.data}");
        return jsonDecode(response.data) as Map<String, dynamic>;
      } else {
        print("文件上传失败，状态码: ${response.statusCode}");
      }
    } catch (e) {
      print("文件上传过程中发生错误: $e");
    }
  }
}
