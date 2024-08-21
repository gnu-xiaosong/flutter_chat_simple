/*
 console控制打印封装类
 */
import 'package:chalkdart/chalkstrings.dart';
import 'package:chalkdart/chalkstrings_x11.dart';
import 'package:socket_service/microService/service/server/model/LogModel.dart';
import 'package:uuid/uuid.dart';

import '../../service/store/LogDataStore.dart';
import '../../ui/server/common/serverTool.dart';

mixin Console {
  LogDataStore logDataStore = LogDataStore();
  ServerUiTool serverUiTool = ServerUiTool();
  /*
  信息统一处理函数
   */
  handle(dynamic info) {
    // 封装数据模型
    LogModel logModel = LogModel(
        id: Uuid().v4(),
        type: "log",
        time: DateTime.now(),
        content: info.toString());
    // 存储本地中
    logDataStore.addLogInfo(logModel.toMap());
    // // 保存
    // serverUiTool.updateShowInfo();
  }

  // 正常消息
  printInfo(dynamic info) {
    handle(info);
    var data = info.toString().whiteBright;
    print(data);
  }

  // 打印成功消息
  printSuccess(dynamic info) {
    handle(info);
    var data = info.toString().green.font10;
    print(data);
  }

  // 打印失败消息
  printFaile(dynamic e) {
    handle(e);
    var str = e.toString().redBright.bold;
    print(str);
  }

  //错误信息
  printError(dynamic err) {
    handle(err);
    var errstr = err.toString().redBright;
    print(errstr);
  }

  //警告信息
  printWarn(dynamic warn) {
    handle(warn);
    var warning = warn.toString().keyword("orange");
    print(warning);
  }

  //打印进度条
  printProgress(dynamic data) {
    handle(data);
    print(data);
  }

  // 打印表格输出
  printTable(Map data) {
    handle(data);
  }

  // 报错异常catch捕获
  printCatch(dynamic e) {
    handle(e);
    var catche = e.toString().redX11;
    print(catche);
  }
}
