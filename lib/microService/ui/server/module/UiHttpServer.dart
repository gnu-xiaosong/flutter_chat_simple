/*
基于UI的httpServer实现
 */

import 'package:http_multi_server/http_multi_server.dart';
import 'package:socket_service/microService/module/httpServer/HttpServer.dart';
import '../../../module/manager/GlobalManager.dart';
import 'AppModule.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

class UiHttpServer extends HttpServer {
  // Private constructor
  UiHttpServer._internal();

  AppModule appModule = AppModule();
  // Static instance variable
  static final UiHttpServer _instance = UiHttpServer._internal();

  // Factory constructor to return the same instance
  factory UiHttpServer() {
    return _instance;
  }

  @override
  boot() async {
    server = await HttpMultiServer.bind('0.0.0.0', port, shared: true);
    shelf_io.serveRequests(server!, router);
    print('Server listening on: 0.0.0.0:$port');
    // Ui设置
    // 停止旋转
    GlobalManager.globalControlHttp.stop();
    // 改变bootServer ui
    appModule.setHttpIsRunningInHive(true);
  }
}
