import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:iconify_flutter_plus/iconify_flutter_plus.dart';
import 'package:iconify_flutter_plus/icons/ion.dart';
import 'package:iconify_flutter_plus/icons/mdi.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../common/Tool.dart';
import '../module/StoreDataClientModule.dart';

class ChatStyleSettingComponent extends StatefulWidget {
  const ChatStyleSettingComponent({super.key});

  @override
  State<ChatStyleSettingComponent> createState() => _IndexState();
}

class _IndexState extends State<ChatStyleSettingComponent> {
  StoreDataClientModule storeDataClientModule = StoreDataClientModule();
  UiTool uiTool = UiTool();

  File? _image;
  String? _localImagePath;

  bool isShowDelet = false;

  Future<void> _pickAndSaveImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // 选择的图片文件
      File imageFile = File(pickedFile.path);

      // 获取应用程序的文档目录
      Directory appDocumentsDirectory =
          await getApplicationDocumentsDirectory();
      String appDocumentsPath = appDocumentsDirectory.path;

      // 创建wallpaper目录
      String wallpaperDirectoryPath = '$appDocumentsPath/wallpaper';
      Directory wallpaperDirectory = Directory(wallpaperDirectoryPath);

      if (!(await wallpaperDirectory.exists())) {
        await wallpaperDirectory.create(recursive: true);
      }

      // 保存图片到wallpaper目录
      String fileName = basename(imageFile.path);
      String localImagePath = '$wallpaperDirectoryPath/$fileName';
      await imageFile.copy(localImagePath);

      setState(() {
        _image = imageFile;
        _localImagePath = localImagePath;
        // 更新
        storeDataClientModule.setChatPaper(_localImagePath!);
      });

      print('Image saved to wallpaper directory: $localImagePath');
    }
  }

  @override
  Widget build(BuildContext context) {
    List paths = storeDataClientModule.getChatWallPaper();
    return Container(
      padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
      width: 400,
      height: 400,
      child: Column(
        children: [
          // 标题
          Center(
            child: NeumorphicText(
              "chat ui".tr(),
              style: NeumorphicStyle(color: Colors.black),
              textStyle: NeumorphicTextStyle(
                  fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          SizedBox(height: 20),
          // 壁纸设置
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "wall paper".tr(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          // 壁纸设置
          ValueListenableBuilder(
              valueListenable:
                  Hive.box("client").listenable(keys: ["wallPaper"]),
              builder: (_, box, child) {
                List<Widget> a = paths.map((path) {
                  return StaggeredGridTile.count(
                      crossAxisCellCount: 1,
                      mainAxisCellCount: 1,
                      child: GestureDetector(
                        onLongPress: () {
                          // 长按用于删除图片
                          print("long press ");
                          // 显示图片
                          setState(() {
                            isShowDelet = true;
                          });
                        },
                        onTap: () {
                          // 切换背景图
                          storeDataClientModule.setChatPaper(path);
                        },
                        child: Stack(children: [
                          Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: _loadImage(path),
                          ),
                          // 使用 Positioned 进行绝对定位
                          isShowDelet
                              ? Positioned(
                                  bottom: -14, // 从父组件顶部的距离
                                  right: -14, // 从父组件左侧的距离
                                  child: IconButton(
                                    onPressed: () {
                                      // 判断为本地文件时才进行删除

                                      if (path.startsWith('/')) {
                                        // 删除
                                        uiTool.deleteFile(path);
                                      }

                                      if (path.startsWith('/') ||
                                          path.startsWith('http://') ||
                                          path.startsWith('https://')) {
                                        setState(() {
                                          // 删除缓存
                                          storeDataClientModule
                                              .deleteChatPaper(path);
                                          isShowDelet = false;
                                        });
                                      }
                                    },
                                    icon: const Iconify(
                                      Mdi.delete_circle,
                                      color: Colors.red,
                                    ),
                                  ))
                              : const SizedBox(),
                        ]),
                      ));
                }).toList();

                // 添加
                a.add(addImgWidget());

                return StaggeredGrid.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 8,
                  children: a,
                );
              })
        ],
      ),
    );
  }

  Widget _loadImage(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      // 网络图片
      return Image.network(path, fit: BoxFit.cover);
    } else if (path.startsWith('/')) {
      // 本地文件系统图片
      return Image.file(File(path), fit: BoxFit.cover);
    } else {
      // asset 图片
      return Image.asset(path, fit: BoxFit.cover);
    }
  }

  /*
  添加图片
   */
  Widget addImgWidget() {
    return StaggeredGridTile.count(
        crossAxisCellCount: 1,
        mainAxisCellCount: 1,
        child: GestureDetector(
          onTap: () {
            // 选择图片
            _pickAndSaveImage();
          },
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey.shade100,
            child: Iconify(
              Ion.add,
              size: 70,
            ),
          ),
        ));
  }
}
