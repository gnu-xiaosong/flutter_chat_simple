import 'dart:isolate';
import 'package:dio/dio.dart';

import '../../../module/httpServer/HttpServer.dart';
import 'AppModule.dart';
import '../../../module/manager/GlobalManager.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:http_multi_server/http_multi_server.dart';

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
    server = await HttpMultiServer.bind('any', port, shared: true);
    shelf_io.serveRequests(server, router);
    print('Server listening on: 0.0.0.0:$port');
    // 停止旋转
    GlobalManager.globalControlHttp.stop();
    // 改变bootServer ui
    appModule.setHttpIsRunningInHive(!appModule.getHttpIsRunningInHive());
  }

  @override
  void close() {
    server.close();
    print('HTTP Server stopped.');
    appModule.setHttpIsRunningInHive(!appModule.getHttpIsRunningInHive());
  }
}
