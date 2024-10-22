/*
工具函数
 */
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import '../../service/server/model/ClientModel.dart';
import '../manager/GlobalManager.dart';

mixin CommonTool {
  /*
  获取内网ip
   */
  Future<String?> getLocalIPv4Address() async {
    try {
      // 获取所有网络接口
      List<NetworkInterface> interfaces = await NetworkInterface.list(
        includeLoopback: false, // 排除回环接口
        includeLinkLocal: true, // 包括链路本地地址
      );

      // 遍历所有网络接口
      for (var interface in interfaces) {
        // 遍历接口的所有地址
        for (var address in interface.addresses) {
          print("地址: ${address.address}");
          // 如果地址是 IPv4 地址
          if (address.type == InternetAddressType.IPv4) {
            return address.address; // 返回 IPv4 地址
          }
        }
      }

      // 如果没有找到 IPv4 地址
      return null;
    } catch (e) {
      print('获取本地 IPv4 地址时发生错误: $e');
      return null;
    }
  }

  // 在某个指定字符后插入字符
  String insertAfterCharacter(
      String original, String targetChar, String toInsert) {
    int position = original.indexOf(targetChar);
    if (position == -1) {
      throw ArgumentError("Character not found in the string");
    }
    return original.substring(0, position + targetChar.length) +
        toInsert +
        original.substring(position + targetChar.length);
  }

  Map? stringToMap(String data) {
    // print("------json decode for string to map--------");
    // print("待转string: $data");
    try {
      // 检查输入字符串是否是有效的JSON格式
      if (data != null && data.isNotEmpty) {
        // 使用json.decode将JSON字符串解析为Map
        Map re = json.decode(data);
        // print("转换map: $re");
        return re;
      } else {
        print("Input data is empty or null");
      }
    } catch (e) {
      // 处理解析错误，输出错误信息并返回一个空的Map
      print('Error parsing JSON: $e');
      return {};
    }
  }

  //auth认证加密算法认证:md5算法
  String generateMd5Secret(String data) {
    var bytes = utf8.encode(data); // data being hashed
    var digest = md5.convert(bytes);
    return digest.toString();
  }

  // 生成32字符长度的随机字符串作为密钥
  String generateRandomKey() {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return List.generate(32, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  /// 尝试将字符串转换为InternetAddress对象
  ///
  /// @param ipAddress 要转换的IP地址字符串
  /// @return 返回转换后的InternetAddress对象，如果转换失败则返回null
  InternetAddress? tryConvertToInternetAddress(String ipAddress) {
    try {
      return InternetAddress(ipAddress);
    } on FormatException {
      // 打印错误信息，也可以选择抛出异常或者返回特定的错误信息
      print('转换失败: 无效的IP地址格式');
      return null;
    }
  }

  /*
  获取调试位置
   */
  getPosition(int line) {
    List p = [];
    // 获取当前脚本的路径
    final scriptUri = Platform.script;

    // 转换为文件路径
    final scriptPath = scriptUri.toFilePath();

    // 获取文件名
    final scriptFileName = scriptUri.pathSegments.last;

    p.add(scriptPath.toString());
    p.add(scriptFileName.toString());
    p.add(line.toString());

    return p;
  }

  //*********************以下方法都是获取在线的clientObject对象**************************
  // 根据deviceId设备ID获取对应于的clientObject对象
  ClientModel? getClientObjectByDeviceId(String deviceId) {
    // 遍历list
    for (ClientModel clientObject in GlobalManager.onlineClientList) {
      // print(clientObject.deviceId);
      if (clientObject.deviceId == deviceId) return clientObject;
    }
    return null;
  }

  /*
  由HttpRequest request, WebSocket webSocket 获取ClientObject对象
   */
  ClientModel getClientObject(HttpRequest request, WebSocket webSocket) {
    late ClientModel clientObject;
    for (ClientModel clientObject_item in GlobalManager.onlineClientList) {
      // 根据ip地址匹配查找
      if ((clientObject_item.ip ==
                  request.connectionInfo?.remoteAddress.address &&
              clientObject_item.port ==
                  request.connectionInfo?.remotePort.toInt()) ||
          clientObject_item.socket == webSocket) {
        // 匹配成功
        clientObject = clientObject_item;
      }
    }

    return clientObject;
  }
}
