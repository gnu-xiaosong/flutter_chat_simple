import 'package:easy_localization/easy_localization.dart';

class TimeTool {
  /*
  根据给定的秒数字符化时间
   */
  String secondFormateTime(int second) {
    // 取出小时整数
    int hours = second ~/ (60 * 60);
    // 取出余下分钟数
    int minutes = (second - hours * (60 * 60)) ~/ 60;
    // 取出秒数
    int seconds = second % 60;

    String re = "${hours}" +
        "h".tr() +
        ":" +
        "${minutes}" +
        "m".tr() +
        ":" "${seconds}" +
        "s".tr();

    return re;
  }
}
