/*
* 文档地址：https://pub-web.flutter-io.cn/packages/bottom_bar_with_sheet#getting-started
* */
import 'package:bottom_bar_with_sheet/bottom_bar_with_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BottomBarWithSheetComponent extends StatefulWidget {
  int currentIndex;
  // 底部导航列表
  List bottomTabs;
  // 选中状态颜色
  Color activeColor = Colors.blue;
  // 未选中状态颜色
  Color unActiveColor = Colors.red;
  // index改变回调函数
  Function callback;

  BottomBarWithSheetComponent({
    Key? key, // 当前nav的index
    required this.currentIndex,
    // 底部导航列表
    required this.bottomTabs,
    // 选中状态颜色
    this.activeColor = Colors.blue,
    // 未选中状态颜色
    this.unActiveColor = Colors.red,
    // index改变回调函数
    required this.callback,
  }) : super(key: key);

  @override
  State<BottomBarWithSheetComponent> createState() => _IndexState(
      currentIndex: currentIndex, bottomTabs: bottomTabs, callback: callback);
}

class _IndexState extends State<BottomBarWithSheetComponent> {
  int currentIndex;
  // 底部导航列表
  List bottomTabs;
  // 选中状态颜色
  Color activeColor = Colors.blue;
  // 未选中状态颜色
  Color unActiveColor = Colors.red;
  // index改变回调函数
  Function callback;

  late var _bottomBarController;

  _IndexState({
    required this.currentIndex,
    // 底部导航列表
    required this.bottomTabs,
    // 选中状态颜色
    this.activeColor = Colors.blue,
    // 未选中状态颜色
    this.unActiveColor = Colors.red,
    // index改变回调函数
    required this.callback,
  }) {
    _bottomBarController =
        BottomBarWithSheetController(initialIndex: currentIndex);
  }

  @override
  void initState() {
    _bottomBarController.stream.listen((opened) {
      debugPrint('Bottom bar ${opened ? 'opened' : 'closed'}');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomBarWithSheet(
      controller: _bottomBarController,
      bottomBarTheme: const BottomBarTheme(
        mainButtonPosition: MainButtonPosition.middle,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 0.0 /*边缘完全不模糊*/,
              // blurRadius: 45/*边缘模糊*/,
            ),
          ],
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        itemIconColor: Colors.grey,
        itemTextStyle: TextStyle(
          color: Colors.grey,
          fontSize: 10.0,
        ),
        selectedItemTextStyle: TextStyle(
          color: Colors.blue,
          fontSize: 10.0,
        ),
      ),
      onSelectItem: (index) => callback(index),
      sheetChild: Center(
        child: Text(
          "Another content".tr(),
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      items: bottomTabs
          .map((item) => _BottomNavigationBarItem(
              label: item.label.toString().tr(),
              activeColor: activeColor,
              unActiveColor: unActiveColor,
              icon: item.icon,
              index: bottomTabs.indexOf(item)))
          .toList(),
    );
  }
}

//底部导航栏item
BottomBarWithSheetItem _BottomNavigationBarItem(
    {
    // label名
    required String label,
    // 选中状态颜色
    required Color activeColor,
    // 未选中状态颜色
    required Color unActiveColor,
    // icon
    required IconData icon,
    // index标识
    required int index}) {
  return BottomBarWithSheetItem(icon: icon, label: label);
}
