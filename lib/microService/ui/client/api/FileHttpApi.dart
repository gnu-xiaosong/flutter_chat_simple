/*
聊天的文件接口类
 */

import 'package:dio/dio.dart';

import '../../../../api/BasedApi.dart';
import '../../../../config/ConstConfig.dart';

class FileHttpApi extends BasedApi {
  /*
  上传文件
   */
  uploadFile(String filename, String filePath) async {
    // 发起请求的URL
    String url = "/upload";

    // 参数:其他参数
    Map<String, dynamic> params = {"type": "json"};

    try {
      // 构建FormData，用于包含文件和其他参数
      FormData formData = FormData.fromMap({
        "filename": await MultipartFile.fromFile(filePath, filename: filename),
        ...params,
      });

      // 发起POST请求进行文件上传
      Map data =
          await appHttp.api(url, parameters: formData, method: METHODS.FILE);

      // 打印服务器的响应
      print("---------------------获取消息-----------------");
      print(data);
      return data;
    } catch (e) {
      print("文件上传失败: $e");
    }
  }
}
