/*
底部导航菜单配置文件
 */

import 'package:flutter/material.dart';
import '../model/BottomNavMenuModel.dart';
import '../page/MessagePage.dart';
import '../page/PersonPage.dart';
import '../page/UserPage.dart';

/*
底部导航样式枚举： 对应于该类名
 */
enum BottomNavigatorStyle {
  AnimatedNotchBottomComponent,
  BottomBarWithSheetComponent
}

// 默认底部导航栏的索引
int currentBottomNavigatorIndex = 0;

/*
底部导航菜单Map menus
 */
List<Map> bottomNavigaterMenuMapList = [
  {
    "label": "message", //item名称
    "page": const MessagePage(), // 页面文件
    "icon": Icons.chat_bubble_outlined // icon
  },
  {
    "label": "user", //
    "page": UserPage(), //
    "icon": Icons.supervised_user_circle //
  },
  {
    "label": "person", //
    "page": PersonPage(), //
    "icon": Icons.person //
  }
];

/*
底部导航菜单BottomNavMenuModel menus
 */
List<BottomNavMenuModel> bottomNavigaterMenuBottomNavMenuModelList =
    bottomNavigaterMenuMapList.map((json) {
  // 强制类型转换
  final castedJson = Map<String, dynamic>.from(json);
  // 转换
  return BottomNavMenuModel.fromJson(castedJson);
}).toList();
