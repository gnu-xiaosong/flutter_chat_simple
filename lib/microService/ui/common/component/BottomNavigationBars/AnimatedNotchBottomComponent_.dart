import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:molten_navigationbar_flutter/molten_navigationbar_flutter.dart';

Widget AnimatedNotchBottomComponent({
  // 当前nav的index
  required int currentIndex,
  // 底部导航列表
  required List bottomTabs,
  // 选中状态颜色
  Color activeColor = Colors.blue,
  // 未选中状态颜色
  Color unActiveColor = Colors.red,
  // index改变回调函数
  required Function callback,
}) {
  return MoltenBottomNavigationBar(
      //tabbar的背景色
      barColor: Colors.blue,
      selectedIndex: currentIndex,
      onTabChange: (index) => callback(index),
      tabs: bottomTabs
          .map((item) => _BottomNavigationBarItem(
              label: item.label.toString().tr(),
              activeColor: activeColor,
              unActiveColor: unActiveColor,
              icon: item.icon,
              index: bottomTabs.indexOf(item)))
          .toList());
}

//底部导航栏item
MoltenTab _BottomNavigationBarItem(
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
  return MoltenTab(
      icon: Icon(icon),
      title: Text(label.toString().tr()),
      selectedColor: activeColor,
      unselectedColor: unActiveColor);
}
