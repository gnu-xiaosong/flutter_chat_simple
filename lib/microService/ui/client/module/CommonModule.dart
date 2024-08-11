import 'dart:math';

class CommonModule {
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
