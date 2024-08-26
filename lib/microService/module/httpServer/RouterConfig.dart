/*
路由配置文件
 */
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_router/shelf_router.dart';
import 'Api.dart';

class RouterConfig extends Api {
  late Router router;

  RouterConfig() : super() {
    //设置参数
    setRouter();
  }

  /*
   配置路由
   */
  setRouter() {
    router = Router();
    //**************路由设置**********************
    /*
    测试路由
     */
    router.get('/test', (shelf.Request request) async {
      return await test(request);
    });

    /*
     文件上传路由
     */
    router.post('/upload', (shelf.Request request) async {
      return await uploadFile(request);
    });

    /*
     文件访问路由
     */
    router.get('/file/<filename>',
        (shelf.Request request, String filename) async {
      return await getFile(request, filename);
    });
  }
}
