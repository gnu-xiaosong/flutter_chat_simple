import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluid_dialog/fluid_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:smooth_sheets/smooth_sheets.dart';
import '../../../../database/LocalStorage.dart';
import '../../../../database/daos/UserDao.dart';
import '../../../module/common/BroadcastModule.dart';
import '../../../module/manager/GlobalManager.dart';
import '../common/Tool.dart';
import '../component/ChatStyleSettingComponent.dart';
import '../component/ChatViewComponent.dart';
import '../model/enum.dart';
import '../widget/userOnlineStatusWidget.dart';

class ChatPage extends StatefulWidget {
  ChatPage({super.key}) {}

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  UserDao userDao = UserDao();
  UiTool uiTool = UiTool();
  String? deviceId;
  late User user; // 用户信息
  late bool isInline; // 是否在线

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 获取页面传递过来的ddeviceId
    deviceId = uiTool.getDeviceId(context);
    // 获取是否在线
    setState(() {
      isInline = GlobalManager.userMapMsgQueue.containsKey(deviceId);
      // 全局
      GlobalManager.isOnline = isInline;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  /*
  手势返回
   */
  Future<bool> _onWillPop() async {
    // 清空对应的消息队列: bug 在清空meesage会触发监控
    GlobalManager.userMapMsgQueue[deviceId]?.clear();
    BroadcastModule().globalBroadcast(BroadcastType.refresh);
    return true;
  }

  /*
  获取user信息
   */
  Future<User> getUserInfo() async {
    // 查询
    user = await userDao.selectUserByDeviceId(deviceId!);
    // print("chat user info: ${user}");

    return user;
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: _onWillPop,
      child: DefaultSheetController(
        child: FutureBuilder(
          future: getUserInfo(),
          builder: (BuildContext context, AsyncSnapshot<User> user) {
            if (user.connectionState == ConnectionState.done) {
              if (user.hasError) {
                return Text('Error: ${user.error}');
              } else {
                return Scaffold(
                  extendBody: true,
                  appBar: AppBar(
                    // 设置背景色
                    backgroundColor: Colors.grey,
                    // 设置 icon 主题
                    iconTheme: IconThemeData(
                      // 颜色
                      color: Colors.blue,
                      // 不透明度
                      opacity: 0.5,
                    ),
                    // 标题居中
                    centerTitle: true,
                    // 标题左右间距为
                    leadingWidth: 50.sp,
                    //标题间隔
                    titleSpacing: 1,
                    //左边
                    leading: Builder(builder: (BuildContext context) {
                      return IconButton(
                          iconSize: 20.sp,
                          icon: const Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            // 清空对应的消息队列: bug 在清空meesage会触发监控
                            GlobalManager.userMapMsgQueue[deviceId]?.clear();
                            BroadcastModule()
                                .globalBroadcast(BroadcastType.refresh);
                            // 返回
                            Navigator.of(context).pop();
                          });
                    }),
                    //标题--双标题
                    title: Column(children: [
                      Text(
                        user.data!.username.toString().tr(),
                        style: const TextStyle(fontSize: 18),
                      ),
                      // 在线状态
                      UserOnlineStatus(deviceId)
                    ]),
                    //action（操作）right
                    actions: [
                      // 主题设置
                      IconButton(
                        onPressed: () {
                          // 设置主题
                          showDialog(
                            context: context,
                            builder: (context) => FluidDialog(
                              // Use a custom curve for the alignment transition
                              alignmentCurve: Curves.easeInOutCubicEmphasized,
                              // Setting custom durations for all animations.
                              sizeDuration: const Duration(milliseconds: 300),
                              alignmentDuration:
                                  const Duration(milliseconds: 600),
                              transitionDuration:
                                  const Duration(milliseconds: 600),
                              reverseTransitionDuration:
                                  const Duration(milliseconds: 50),
                              // Here we use another animation from the animations package instead of the default one.
                              // transitionBuilder: (child, animation) => ZoomIn(
                              //   child: child,
                              // ),
                              // Configuring how the dialog looks.
                              defaultDecoration: BoxDecoration(
                                color: NeumorphicTheme.baseColor(context),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              rootPage: FluidDialogPage(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(32),
                                  color: NeumorphicTheme.baseColor(context),
                                ),
                                alignment: Alignment
                                    .center, //Aligns the dialog to the bottom left.
                                builder: (context) =>
                                    const ChatStyleSettingComponent(), // This can be any widget.
                              ),
                            ),
                          );
                        },
                        icon: Iconify(Ic.outline_color_lens),
                      ),
                      // DropdownButtonHideUnderline(
                      //   child: DropdownButton1(),
                      // )
                    ],
                    // 自定义图标样式
                    actionsIconTheme: IconThemeData(
                      color: Colors.blue,
                    ),
                    shadowColor: Theme.of(context).shadowColor,
                    //灵活区域
                    flexibleSpace: SizedBox(
                        width: double.infinity, //无限
                        height: 160.h,
                        child: Container(
                          color: Colors.orange,
                        )),
                  ),
                  body: chatView(),
                );
              }
            } else {
              return CircularProgressIndicator(); // 显示加载指示器
            }
          },
        ),
      ));
}
