/*
 * @Author: xskj
 * @Date: 2023-12-29 13:25:12
 * @LastEditors: xskj
 * @LastEditTime: 2023-12-29 13:40:14
 * @Description: 聊天websocket管理器类
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:lan_scanner/lan_scanner.dart';
import 'package:network_info_plus/network_info_plus.dart';
import '../../../config/AppConfig.dart';
import '../../service/client/websocket/ChatWebsocketClient.dart';
import '../../service/server/websocket/ChatWebsocketServer.dart';
import '../encryption/MessageEncrypte.dart';
import '../manager/GlobalManager.dart';

class ChatWebsocketBoth extends MessageEncrypte {
  // 静态属性，存储唯一实例
  static ChatWebsocketBoth? _instance;
  // 私有的命名构造函数，确保外部不能实例化该类
  ChatWebsocketBoth._internal() {
    // 初始化逻辑
    // printInfo("-------chatWebsocket instance-----");
  }

  // 提供一个静态方法来获取实例
  static ChatWebsocketBoth getInstance() {
    _instance ??= ChatWebsocketBoth._internal();
    return _instance!;
  }

  /*
    选择本机为服务器端还是客户端策略
   */
  // IP地址
  InternetAddress? server_ip;
  String _ip = "";

  // 端口port
  final int port = AppConfig.port;
  bool result = true; // 是否作为服务端
  bool isServer = true; // 是否作为服务端
  // 限制扫描最大ip数
  Object limitPort = 10;

  Future<bool> selectLocalHostAsServerStrategy() async {
    if (!GlobalManager.appCache.containsKey("server_ip") ||
        GlobalManager.appCache.getString("server_ip")?.length == 0) {
      //设置
      await GlobalManager.appCache.setString("server_ip", "192.168.1.1");
    }
    // 获取ip
    _ip = GlobalManager.appCache.getString("server_ip")!;
    // 存在server_进行连接性测试
    bool isConnected = await testConnection(_ip, AppConfig.port);

    // printInfo("--------isConnected=$isConnected---------------");
    if (isConnected) {
      printSuccess("server检测成功: ${_ip.toString()}:$port");
      // 检测连接成功
      result = false;
    } else {
      // 1. 获取子网
      // 192.168.0.1
      var wifiIP = await NetworkInfo().getWifiIP();

      // 192.168.0
      var subnet = ipToCSubnet(wifiIP!);
      printInfo("本机: $wifiIP 子网ip:$subnet");
      // 2. 进行连接性测试: 策略为ip+端口连接检测
      int i = 1;
      while (result && i != limitPort) {
        printInfo("测试地址: $subnet.$i:${AppConfig.port}");
        _ip = "$subnet.$i";
        bool isConnected = await testConnection(_ip, AppConfig.port);
        if (isConnected) {
          // 服务端ip
          server_ip = InternetAddress(_ip);

          printSuccess("server检测成功: ${_ip}:$port");
          result = false;

          // 存储server的ip地址，备下次直接使用
          await GlobalManager.appCache.setString("server_ip", _ip.toString());
          break;
        } else {
          printFaile("${_ip.toString()}:$port   连接失败!");
        }
        i++;
      }
    }

    // 3. 如果存在服务端则返回：false 并设置服务端ip地址绑定 启动客户端服务

    return result;
  }

  /*
    启动websocket服务
   */
  void bootWebsocket() async {
    // 1.判断是否作为server端
    bool isServer = await selectLocalHostAsServerStrategy();

    // 2.启动对用的socket
    if (isServer) {
      // 配置参数
      String? ip = InternetAddress.anyIPv4.address.toString();
      int port = AppConfig.port;
      ChatWebsocketServer chatWebsocketServer =
          ChatWebsocketServer(ip: ip, port: port);
      // 启动server
      chatWebsocketServer.bootServer();
      //**************启动一个client本地websocket服务***********
      // rebootClientServer("127.0.0.1");
      //*****************************************************
    } else {
      // 启动client
      rebootClientServer(_ip);
    }
  }

  /*
  启动client服务websocket
   */
  rebootClientServer(String ip) {
    // 配置参数
    int port = 1314;

    ChatWebsocketClient chatWebsocketClient =
        ChatWebsocketClient(ip: ip, port: port);
    // 连接server
    chatWebsocketClient.connServer();
  }

  Future<bool> testConnection(String ipAddress, int port) async {
    try {
      // 尝试连接到指定的IP和端口
      final socket =
          await Socket.connect(ipAddress, port, timeout: Duration(seconds: 1));
      // 发送消息
      socket.listen((event) {
        // 接收到服务器的数据
        String response = utf8.decode(event); // 将字节数组转换为字符串
        // 解密数据
        Map re = json.decode(response);
        if (re["type"] == "SCAN") {
          // 验证正确:关闭
          socket.destroy();
          printInfo("已关闭SCAN连接");
        }
      }, onError: (error) {
        printError('Error: $error');
      }, onDone: () {
        printInfo('SCAN Connection closed!');
        socket.destroy(); // 关闭连接
      });

      // 发送消息
      Map req = {
        "type": "SCAN",
        "info": {"msg": "scan server task!"}
      };

      // 加密
      req["info"] = encodeAuth(req["info"]);
      // 发送
      socket.write(json.encode(req));
      print("SCAN: ${req}");

      return true;
    } catch (e) {
      // 如果连接失败，打印错误信息并返回false
      printCatch('test  connect disinterrupt: $e');
      return false;
    }
  }
}
