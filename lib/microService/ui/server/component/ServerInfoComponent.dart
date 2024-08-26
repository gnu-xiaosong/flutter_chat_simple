import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluid_dialog/fluid_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ic.dart';
import 'package:iconify_flutter_plus/icons/material_symbols.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:iconify_flutter_plus/icons/zondicons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../../module/manager/GlobalManager.dart';
import '../../../module/plugin/storeData/ServerStoreDataPlugin.dart';
import '../../../service/server/extentions/EnumExtension.dart';
import '../../../service/store/LogDataStore.dart';
import 'LogInfoComponent.dart';
import 'MessageHandlerModuleComponent.dart';
import 'OnlineClientListComponent.dart';
import 'PluginListComponent.dart';

class ServerInfoComponent extends StatefulWidget {
  const ServerInfoComponent({super.key});

  @override
  State<ServerInfoComponent> createState() => _IndexState();
}

class _IndexState extends State<ServerInfoComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: Center(
              child: gridLayout(),
            ),
          ),
        ],
      ),
    );
  }

  /*
  设置
   */
  Widget labelTool(Map label) {
    return GestureDetector(
      onTap: label["onTap"],
      child: Neumorphic(
        style: NeumorphicStyle(
            shape: NeumorphicShape.flat,
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(40)),
            depth: 5,
            color: const Color.fromRGBO(221, 221, 221, 1),
            intensity: 1),
        child: Container(
          width: 40.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // left： icon
              label["icon"],
              const SizedBox(width: 5),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // right: text
                  Text(
                    label["text"].toString(),
                    style: const TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                  // center: label
                  Text(label["label"].toString().tr()),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // inner布局内容
  Widget gridLayout() {
    List<Map<String, dynamic>> labelToolList = [
      {
        "icon": const Iconify(
          Ic.outline_connect_without_contact,
          size: 40,
        ),
        "label": "connected",
        "text": 0,
        "onTap": () {
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
              transitionBuilder: (child, animation) => ZoomIn(
                child: child,
              ),
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
                    .bottomCenter, //Aligns the dialog to the bottom left.
                builder: (context) =>
                    const OnlineClientListComponent(), // This can be any widget.
              ),
            ),
          );
        }
      },
      {
        "icon": const Iconify(
          Mdi.wifi_refresh,
          size: 40,
        ),
        "label": "retry",
        "text": 0,
        "onTap": () {}
      },
      {
        "icon": const Iconify(
          Mdi.file_document_edit_outline,
          size: 40,
        ),
        "label": "log",
        "text": LogDataStore.getLogModelListInHive().length,
        "onTap": () {
          showMaterialModalBottomSheet(
            context: context,
            builder: (context) => const LogInfoComponent(),
          );
        }
      },
      {
        "icon": const Iconify(
          Zondicons.plugin,
          size: 40,
        ),
        "label": "plugin",
        "text":
            "${ServerStoreDataPlugin.getPluginListInHive().where((e) => e.status).length}/${ServerStoreDataPlugin.getPluginListInHive().length}",
        "onTap": () {
          // 显示
          showCupertinoModalBottomSheet(
            context: context,
            builder: (context) => const PluginListComponent(),
          );
        }
      },
      {
        "icon": const Iconify(
          MaterialSymbols.view_module,
          size: 40,
        ),
        "label": "ws modules",
        "text": MsgTypeEnumExtension.count,
        "onTap": () {
          showCupertinoModalBottomSheet(
            expand: true,
            context: context,
            builder: (context) => const MessageHandlerModuleComponent(),
          );
        }
      },
    ];
    // 创建一个 ValueNotifier
    GlobalManager.globalListValueNotifier.value = labelToolList;

    return ValueListenableBuilder<List>(
        valueListenable: GlobalManager.globalListValueNotifier,
        builder: (context, labelToolLists, child) {
          return StaggeredGrid.count(
            crossAxisCount: 4,
            mainAxisSpacing: 10,
            crossAxisSpacing: 8,
            children: labelToolLists.map((item) {
              return StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 1,
                child: labelTool(item),
              );
            }).toList(),
          );
        });
  }
}
