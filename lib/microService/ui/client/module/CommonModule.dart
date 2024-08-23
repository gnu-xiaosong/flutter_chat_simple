import 'dart:io';
import 'dart:math';

class CommonModule {
  /*
  测试socket连接
   */
  Future<bool> testSocketConnection(String host, int port) async {
    try {
      // 创建一个socket
      final socket = await Socket.connect(host, port);
      // 关闭socket连接
      socket.close();
      // 如果没有异常发生，返回true
      return true;
    } on SocketException catch (e) {
      // 打印异常信息，这有助于调试
      print('Socket连接失败: $e');
      // 如果发生异常，返回false
      return false;
    }
  }

  /*
  获取ip子网地址
   */
  String ipToCSubnet(String ip) {
    List<String> parts = ip.split('.');
    return "${parts[0]}.${parts[1]}.${parts[2]}";
  }

  /*
  随机生成用户名函数
   */
  String generateRandomUsername(int length) {
    const String chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();

    // 生成用户名
    String username =
        List.generate(length, (index) => chars[random.nextInt(chars.length)])
            .join();

    return username;
  }
}
