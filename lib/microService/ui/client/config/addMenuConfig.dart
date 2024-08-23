import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ep.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:popup_menu_plus/popup_menu_plus.dart';
import '../component/FindServerComponent.dart';
import '../page/MyQrPage.dart';
import '../page/ScanPage.dart';
import '../page/SettingPage.dart';

/*
add按钮弹出菜单配置
 */
List menus = <Map>[
  {
    "menu": PopUpMenuItem(
        title: 'setting'.tr(),
        image: const Iconify(Ep.setting, color: Colors.white)),
    "click": (BuildContext context) {
      // 跳转设置页面
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return const SettingPage();
          },
        ),
      );
    }
  },
  {
    "menu": PopUpMenuItem(
        title: 'scan'.tr(),
        image: const Iconify(Mdi.line_scan, color: Colors.white)),
    "click": (BuildContext context) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return ScanPage();
          },
        ),
      );
    }
  },
  {
    "menu": PopUpMenuItem(
        title: 'QR'.tr(),
        image: const Iconify(Ic.sharp_qr_code, color: Colors.white)),
    "click": (BuildContext context) {
      print("-----------------error---------------------");
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return const MyQrPage();
          },
        ),
      );
    }
  },
  {
    "menu": PopUpMenuItem(
        title: 'find'.tr(),
        image: const Iconify(MaterialSymbols.wifi_find_outline_rounded,
            color: Colors.white)),
    "click": (BuildContext context) {
      print("-----------------error---------------------");
      showCupertinoModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => const FindServerComponent(),
      );
    }
  },
];

// 顶部下拉菜单栏
List topMenus() {
  return menus;
}

void onDismiss() {
  print('Menu is dismiss');
}

void onShow() {
  print('Menu is show');
}
