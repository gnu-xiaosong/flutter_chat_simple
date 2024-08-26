/*
client客户端功能模块
 */
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:socket_service/microService/module/DAO/common.dart';
import 'package:socket_service/microService/ui/client/model/AppSettingModel.dart';
import 'package:socket_service/microService/ui/client/module/AppSettingModule.dart';
import '../../../module/DAO/UserChat.dart';
import '../../../module/encryption/MessageEncrypte.dart';
import '../../../module/manager/GlobalManager.dart';
import '../model/CommunicationMessageObject.dart';

class ClientModule extends MessageEncrypte {
  late Map decode_msg;
  UserChat userChat = UserChat();
  CommunicationMessageObject communicationMessageObject =
      CommunicationMessageObject();
  CommonDao commonDao = CommonDao();
  AppClientSettingModule appClientSettingModule = AppClientSettingModule();

  /*
  send方法:该方法负责客户端的chat  MESSAGE类型消息发送函数
   */
  void sendMessage(
      {required String recipientId,
      String? groupOrUser,
      String? contentText,
      String? timestamp,
      String? username,
      String? senderId,
      String? avatar,
      String? msgType,
      Map metadata = const {
        "messageId": "msg123", // 消息的唯一标识符
        "status": "sent" // 消息状态，例如 sent, delivered, read
      },
      List<Map> attachments = const [
        // 附件列表，如图片、文件等（可选）
        {"type": "", "url": "", "name": ""}
      ]}) {
    // 消息封装
    Map msg = communicationMessageObject.message(
        msgType: msgType,
        senderId: senderId,
        username: username,
        avatar: avatar,
        recipientId: recipientId,
        groupOrUser: groupOrUser,
        contentText: contentText,
        attachments: attachments,
        timestamp: timestamp,
        metadata: metadata);

    // 插入数据库中
    commonDao.insertMessageToDataStorage(msg["info"]);

    printError("发送消息: ${msg}");
    String secret = appClientSettingModule.getSecretInHive();
    if (secret.isEmpty) {
      print("-warning: 通讯秘钥 'chat_secret' 为空！消息加密失败。");
    } else {
      try {
        msg["info"] = MessageEncrypte().encodeMessage(secret, msg["info"]);
        // 发送
        GlobalManager.GlobalChatWebsocket.send(json.encode(msg));
      } catch (e) {
        print("发送消息失败：$e");
      }
    }
  }

  /*
  好友请求处理方法一: 弹窗提示
  scan Qr instance dialog to show
   */
  addUserMsgQueue(Map data) async {
    try {
      // 通讯秘钥
      String? secret = appClientSettingModule.getSecretInHive();
      // 加密info字段
      data?["info"] = encodeMessage(secret, data["info"]);

      // 添加进消息队列中
      GlobalManager.clientWaitUserAgreeQueue.enqueue(data);
    } catch (e) {
      printCatch("ERROR: the wait user agree process som error in enqueue!");
    }
  }

  /*
  回复扫码添加好友状态
   */
  replayAddStatus() {
    Map? single = GlobalManager.clientWaitUserAgreeQueue.dequeue();
    singleAgreeUserHandler(single!);
  }

  /*
  处理等待好友同意消息队列: 单条消息信息处理
  mag 铭文未加密
      {
     "type": "REQUEST_SCAN_ADD_USER",
     "info": {
         // 发送方：扫码方
         "sender": {"id": send_deviceId, "username": qr_map["username"]},
         // 接收方: 等待接受
         "recipient": {"id": qr_map["deviceId"], "username": AppConfig.username},
         // 留言
         "content": qr_map["msg"] // 这个字段不是二维码扫描出的，而是用户自定义加上去的
     }
 }
   */
  singleAgreeUserHandler(Map msg) {
    // 数据解密
    // 解密秘钥
    String? secret = appClientSettingModule.getSecretInHive();
    // 解密info字段
    msg?["info"] = decodeMessage(secret!, msg["info"]);

    this.decode_msg = msg;

    printSuccess("扫码数据: ${this.decode_msg}");
    return QuickAlert.show(
      context: GlobalManager.context,
      type: QuickAlertType.confirm,
      title: 'add user request'.tr(),
      confirmBtnText: 'Agree'.tr(),
      cancelBtnText: 'Cancel'.tr(),
      barrierDismissible: false,
      confirmBtnColor: Colors.green,
      // customAsset: 'assets/images/app_icon.png',
      widget: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(height: 15),
        Text(
          'from'.tr() + ": " + msg["info"]["sender"]["id"],
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          'username'.tr() + ": " + msg["info"]["sender"]["username"],
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          'leave message'.tr() + ": " + msg["info"]["content"],
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ]),
      onCancelBtnTap: cancelAgreeUser,
      onConfirmBtnTap: confirmAgreeUser,
    );
  }

  /*
  拒绝好友申请
  msg map 已经解密
   */
  cancelAgreeUser() {
    Map msg = this.decode_msg;
    // 发送消息给服务端
    msg["info"]["type"] = "response"; // 响应
    msg["info"]["status"] = "disagree"; // 拒绝

    // sender 与 recipient互换
    Map tmp = msg["info"]["sender"];
    msg["info"]["sender"] = msg["info"]["recipient"];
    msg["info"]["recipient"] = tmp;

    // 消息加密
    msg["info"] =
        encodeMessage(appClientSettingModule.getSecretInHive(), msg["info"]);
    // 发送消息
    GlobalManager.GlobalChatWebsocket.send(json.encode(msg));
  }

  /*
  同意好友申请,已解密
   */
  confirmAgreeUser() {
    Map msg = this.decode_msg;
    printInfo("------send agreee------");
    printInfo("msg: $msg");
    try {
      // 写入数据库中
      userChat.addUserChat(
          msg["info"]["sender"]["id"].toString(),
          msg["info"]["sender"]["avatar"].toString(),
          msg["info"]["sender"]["username"].toString());

      // 发送消息给服务端
      msg["info"]["type"] = "response"; // 响应
      msg["info"]["status"] = "agree"; // 同意
      // sender 与 recipient互换
      Map tmp = msg["info"]["sender"];
      msg["info"]["sender"] = msg["info"]["recipient"];
      msg["info"]["recipient"] = tmp;

      // 消息加密
      msg["info"] =
          encodeMessage(appClientSettingModule.getSecretInHive(), msg["info"]);

      // 发送请求给服务端
      GlobalManager.GlobalChatWebsocket.send(json.encode(msg));
      // 打印
      printSuccess("response send to request is successful!");
    } catch (e, stacktrace) {
      printCatch("add user response, more detail : $e"); // 打印异常信息
      printCatch("Stacktrace: $stacktrace"); // 打印调用栈信息
    }
    // 返回
    Navigator.of(GlobalManager.context).pop();
  }
}
