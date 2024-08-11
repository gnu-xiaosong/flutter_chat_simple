/*
client页面
 */
import 'package:bottom_sheet_scaffold/bottom_sheet_scaffold.dart';
import 'package:flutter/material.dart';
import '../../../../config/AppConfig.dart';
import '../config/bottomNavigaterMenuConfig.dart';
import '../module/AppBottomBarStyleModule.dart';

class ClientIndexLayout extends StatefulWidget {
  const ClientIndexLayout({super.key});
  @override
  State<ClientIndexLayout> createState() => _IndexState();
}

class _IndexState extends State<ClientIndexLayout> {
  AppBottomBarStyleModule appBottomBarStyleModule = AppBottomBarStyleModule();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body是否可expend
      extendBody: true,
      // body
      body:
          bottomNavigaterMenuBottomNavMenuModelList[currentBottomNavigatorIndex]
              .page,
      // 底部导航菜单
      bottomNavigationBar: GestureDetector(
        // onVerticalDragEnd: (DragEndDetails details) {
        //   _isDragging = false;
        //   slideControl.open();
        // },
        // onHorizontalDragStart: (details) {
        //   print("horizontal");
        // },
        // onTap: () {
        //   if (!_isDragging) {
        //     // 处理点击事件（如果需要的话）
        //     print('Tap Detected');
        //   }
        // },
        //垂直拖拽结束
        // onVerticalDragDown: (detail) {
        //   //显示
        //   // slideControl.open();
        //   print("onVerticalDragEnd" + detail.globalPosition.toString());
        // },
        child: Container(
            child: appBottomBarStyleModule.getBottomNavStyle(
                callback: (index) {
                  setState(() {
                    print("点击了");
                    currentBottomNavigatorIndex = index;
                  });
                },
                // 样式index
                styleIndex:
                    BottomNavigatorStyle.AnimatedNotchBottomComponent.index,
                index: currentBottomNavigatorIndex)),
      ),
    );
  }
}
