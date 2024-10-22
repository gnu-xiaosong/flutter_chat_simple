import 'dart:async';
import 'dart:io';
import 'package:chalkdart/chalkstrings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as Flutter;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../database/daos/ChatDao.dart';
import '../../../module/manager/GlobalManager.dart';
import '../../../service/server/queues/MessageQueue.dart';
import '../common/Tool.dart';
import '../model/ChatAuthor.dart';
import '../module/ChatPageModule.dart';
import '../module/StoreDataClientModule.dart';
import '../widget/chatBubbleWidget.dart';
import 'ChatBottomComponent.dart';

class chatView extends StatefulWidget {
  const chatView({super.key});

  @override
  State<chatView> createState() => _chatViewState();
}

class _chatViewState extends State<chatView> {
  // 存储消息的列表
  List<types.Message> _messages = [];
  late ChatPageModel chatPageModel;
  // 获取该roomId对应的消息队列
  late final MessageQueue? _messageQueue;
  String? myDeviceId;
  ChatDao chatDao = ChatDao();
  UiTool uiTool = UiTool();
  // user本机类
  ChatAuthor chatAuthor = ChatAuthor();

  StoreDataClientModule storeDataClientModule = StoreDataClientModule();

  String? deviceId;
  late AnimationController animControl;
  bool animate = false;

  late StreamSubscription<Map<dynamic, dynamic>> _subscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 获取页面传递过来的ddeviceId
    deviceId = uiTool.getDeviceId(context);
    // 设置用户消息队列监听
    if (GlobalManager.userMapMsgQueue.containsKey(deviceId)) {
      print("******************开始监听***************************");
      print(deviceId);
      // 在线才进行监听
      listenUserMessageQueue(deviceId!);
    }

    // 实例化逻辑类
    chatPageModel = ChatPageModel(addMessageCallback: (message) {
      // 新增消息时调用该函数
      setState(() {
        insertMessage(0, message);
        // _messages.insert();
      });
    }, changeMessageCallback: (messages) {
      // message列表更改时触发
      setState(() {
        _messages = messages;
      });
    });
    // 设置参数
    chatPageModel.deviceId = deviceId;
    // 加载聊天数据
    loadData();
  }

  @override
  dispose() {
    // 取消订阅
    if (GlobalManager.userMapMsgQueue.containsKey(deviceId)) {
      _subscription.cancel();
    }
    super.dispose();
  }

  /*
  加载聊天数据
   */
  loadData() async {
    List<types.Message> tmp_messages = await chatPageModel.loadMessages();
    // 加载历史聊天数据
    setState(() {
      _messages = tmp_messages;
      // print("chat message history: $_messages");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          // 背景图
          ValueListenableBuilder(
              valueListenable:
                  Hive.box("client").listenable(keys: ["wallpaper"]),
              builder: (_, box, child) => Container(
                    width: double.infinity,
                    height: double.infinity,
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 47.h),
                    child:
                        _loadImage(storeDataClientModule.getChatWallPaper()[0]),
                  )),
          // 聊天信息
          Flutter.Chat(
            theme:
                Flutter.DefaultChatTheme(backgroundColor: Colors.transparent),
            scrollPhysics: const BouncingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            messages: _messages, // 消息列表
            onAttachmentPressed:
                chatPageModel.handleAttachmentPressed, // 附件按钮点击事件
            onMessageTap: chatPageModel.handleMessageTap, // 消息点击事件
            onPreviewDataFetched:
                chatPageModel.handlePreviewDataFetched, // 预览数据加载完成事件
            onSendPressed: chatPageModel.handleSendPressed, // 发送按钮点击事件
            showUserAvatars: true, // 显示用户头像
            showUserNames: true, // 显示用户名
            user: chatAuthor.user(), // 本机用户
            // 自定义底部菜单栏
            customBottomWidget: ChatBottom(chatPageModel),
            bubbleBuilder: chatBubbleBuilder,
          ),
        ],
      ),
    );
  }

  Widget _loadImage(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      // 网络图片
      return Image.network(path, fit: BoxFit.cover);
    } else if (path.startsWith('/')) {
      // 本地文件系统图片
      return Image.file(File(path), fit: BoxFit.cover);
    } else {
      // asset 图片
      return Image.asset(path, fit: BoxFit.cover);
    }
  }

  /*
  监听user消息队列
   */
  listenUserMessageQueue(String deviceId) {
    // 设置msgQueue
    _messageQueue = GlobalManager.userMapMsgQueue[deviceId];
    // 打印deviceID
    // print(
    //     "chat page: myDeviceId=${GlobalManager.deviceId}  receiveDeviceID=${deviceId}");
    // 设置监听
    _subscription = _messageQueue!.stream!.listen((message) {
      // print("监听到消息队列变化,新增消息message: $message");
      // 这里监听队列变化进行相应的执行操作
      /// 1. 封装接收方的message
      final addMessage = chatPageModel.messageInChat(message);

      /// 2. 添加数据
      setState(() {
        // add message
        insertMessage(0, addMessage); // 将新消息插入到列表的开头
      });

      // 打印deviceID
      // print("chat page: myDeviceId=${myDeviceId}  receiveDeviceID=${deviceId}");
    });
  }

  // 插入项目
  void insertMessage(int index, types.Message item) {
    // 检查索引是否在范围内
    if (index < 0 || index > _messages.length) {
      print("Invalid index: $index");
      return;
    }
    // print("********************测试******************************");
    // print("message update: ${_messages}");
    _messages.insert(index, item);
  }

  // 删除项目
  void removeMessage(int index) {
    if (index < 0 || index >= _messages.length) {
      print("Invalid index: $index");
      return;
    }
    _messages.removeAt(index);
  }
}
