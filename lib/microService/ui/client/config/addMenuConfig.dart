import 'package:easy_localization/easy_localization.dart';
import 'package:fluid_dialog/fluid_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ep.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:iconify_flutter_plus/icons/octicon.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:popup_menu_plus/popup_menu_plus.dart';
import '../component/FindServerComponent.dart';
import '../component/FtpSelectComponent.dart';
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
  {
    "menu": PopUpMenuItem(
        title: 'file synergy'.tr(),
        image: const Iconify(
          Octicon.file_directory_open_fill_16,
          color: Colors.white,
        )),
    "click": (BuildContext context) {
      print("-----------------error---------------------");

      showDialog(
        context: context,
        builder: (context) => FluidDialog(
          // Use a custom curve for the alignment transition
          alignmentCurve: Curves.easeInOutCubicEmphasized,
          // Setting custom durations for all animations.
          sizeDuration: const Duration(milliseconds: 300),
          alignmentDuration: const Duration(milliseconds: 600),
          transitionDuration: const Duration(milliseconds: 600),
          reverseTransitionDuration: const Duration(milliseconds: 50),
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
            alignment: Alignment.center,
            builder: (context) =>
                const FtpSelectComponent(), // This can be any widget.
          ),
        ),
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
