/*
底部样式导航菜单模块
 */

import 'package:flutter/material.dart';
import 'package:socket_service/microService/ui/client/module/AppSettingModule.dart';
import '../../common/component/BottomNavigationBars/AnimatedNotchBottomComponent_.dart';
import '../../common/component/BottomNavigationBars/BottomBarWithSheetComponent.dart';
import '../config/bottomNavigaterMenuConfig.dart';

class AppBottomBarStyleModule extends AppClientSettingModule {
  /*
  获取底部导航样式
  styleIndex:对应枚举的index值
  callback: index改变回调函数
 */
  Widget getBottomNavStyle(
      {required int styleIndex,
      required int index,
      required Function callback}) {
    // int 转 enum
    BottomNavigatorStyle bottomNavigatorStyle = commonModel.indexTranslateEnum(
        styleIndex, BottomNavigatorStyle.values.toList());
    // 筛选
    switch (bottomNavigatorStyle) {
      case BottomNavigatorStyle.AnimatedNotchBottomComponent:
        /*
       样式1
       */
        return AnimatedNotchBottomComponent(
            activeColor: Colors.white,
            unActiveColor: Colors.white,
            currentIndex: index,
            bottomTabs: bottomNavigaterMenuBottomNavMenuModelList,
            callback: callback);
      case BottomNavigatorStyle.BottomBarWithSheetComponent:
        /*
       样式2
       */
        return BottomBarWithSheetComponent(
            activeColor: Colors.white,
            unActiveColor: Colors.white,
            currentIndex: index,
            bottomTabs: bottomNavigaterMenuBottomNavMenuModelList,
            callback: callback);
    }
  }
}
