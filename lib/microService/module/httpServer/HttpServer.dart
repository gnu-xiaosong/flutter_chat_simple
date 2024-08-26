import 'package:http_multi_server/http_multi_server.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as p;
// import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'RouterConfig.dart';

class HttpServer extends RouterConfig {
  HttpServer() : super();
  var server;
  /*
  开启服务
   */
  Future<void> boot() async {
    if (server == null) {
      // 启动监听并设置 shared 标志为 true
      server = await HttpMultiServer.bind('0.0.0.0', port, shared: true);
      shelf_io.serveRequests(server!, router);
      print('Server listening on port $port');
    } else {
      print('Server is already running.');
    }
  }

  /*
  关闭服务
   */
  close() {
    if (server == null) {
      print('Server is null');
    } else {
      server.close();
    }
  }
}

main() {
  HttpServer httpServer = HttpServer();
  httpServer.boot();
}
