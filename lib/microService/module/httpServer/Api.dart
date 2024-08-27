/*
http接口函数
 */
import 'dart:convert';
import 'dart:io';
// import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:shelf/shelf.dart' as shelf;
import 'package:mime/mime.dart';
import 'package:uuid/uuid.dart';
import '../common/tools.dart';
import 'HttpConfig.dart';

class Api extends HttpConfig with CommonTool {
  Api() : super();
  /*
  测试接口
   */
  test(shelf.Request request) async {
    return shelf.Response.ok("hello ichat");
  }

  /*
  文件上传接口: filename 字段
   */
  Future<shelf.Response> uploadFile(shelf.Request request) async {
    late Map re;

    // 消息id
    String messageId = Uuid().v4(); // 你可以从请求或其他地方获取实际值

    try {
      final boundary = request.headers['content-type']?.split('boundary=').last;
      if (boundary == null) {
        return shelf.Response.badRequest(body: 'No boundary found.');
      }

      final transformer = MimeMultipartTransformer(boundary);
      final bodyBytes = await request
          .read()
          .expand((element) => element)
          .toList(); // 读取并保存请求体
      final parts = transformer.bind(Stream.fromIterable([bodyBytes])); // 转换成流

      await for (final part in parts) {
        final contentDisposition = part.headers['content-disposition'];
        final filename = RegExp(r'filename="([^"]*)"')
            .firstMatch(contentDisposition!)
            ?.group(1);

        // 使用文件名规则：文件名_发送者_消息唯一性id
        final originalFileName = p.basenameWithoutExtension(filename!);
        final fileExtension = p.extension(filename);
        final newFileName = "${originalFileName}_${messageId}${fileExtension}";

        if (filename != null) {
          final file = File(p.join(workDir, newFileName));
          await part.pipe(file.openWrite());
        }
        // 封装为网络url
        String? ip = await getLocalIPv4Address();
        re = {"code": 200, "msg": "文件上传成功", "url": "/file/$newFileName"};
      }
    } catch (e) {
      re = {"code": 500, "msg": "文件上传失败: $e"};
    }

    // 回复客户端
    return shelf.Response.ok(json.encode(re));
  }

  /*
  文件访问接口
   */
  Future<shelf.Response> getFile(shelf.Request request, String filename) async {
    // 解码文件名
    String decodedFilename = Uri.decodeComponent(filename);

    final file = File(p.join(workDir, decodedFilename));
    print(file.path);
    if (await file.exists()) {
      final mimeType = lookupMimeType(filename) ?? 'application/octet-stream';
      final fileStream = file.openRead();
      return shelf.Response.ok(fileStream, headers: {
        HttpHeaders.contentTypeHeader: mimeType,
      });
    } else {
      return shelf.Response.notFound('File not found.');
    }
  }
}
