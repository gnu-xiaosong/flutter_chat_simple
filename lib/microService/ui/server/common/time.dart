import 'package:intl/intl.dart';

import '../../../module/common/Time.dart';

class ServerUiTime extends TimeTool {
  String formatDateTime(DateTime dateTime) {
    // 创建一个 DateFormat 对象，指定日期时间格式为 'yyyy-MM-dd HH:mm:ss'
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    // 使用 format 方法将 DateTime 转换为格式化的字符串
    return formatter.format(dateTime);
  }
}
