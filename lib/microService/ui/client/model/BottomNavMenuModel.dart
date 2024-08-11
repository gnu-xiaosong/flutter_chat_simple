/*
底部导航菜单menu模型
 */

import 'package:hive/hive.dart';

class BottomNavMenuModel {
  // label
  String label;
  // 页面
  var page;
  // icon
  var icon;

  BottomNavMenuModel({
    required String label,
    required var page,
    this.icon,
  })  : label = label,
        page = page;

  // Factory method to create an instance from JSON
  factory BottomNavMenuModel.fromJson(Map<String, dynamic> json) {
    return BottomNavMenuModel(
        label: json['label'], page: json['page'], icon: json['icon']);
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'page': page,
      'icon': icon,
    };
  }

  /*
  保存数据:动态update
   */
  void storeData() {
    // 保存配置文件
    var box = Hive.box('app');
    box.put("serverConfig", toJson());
  }
}
