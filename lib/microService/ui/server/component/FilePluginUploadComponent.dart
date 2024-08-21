import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:socket_service/microService/module/common/NotificationInApp.dart';
import 'package:socket_service/microService/module/plugin/Plugin.dart';
import 'package:socket_service/microService/module/plugin/PluginManager.dart';
import 'package:socket_service/microService/module/plugin/PluginType.dart';
import 'package:uuid/uuid.dart';
import '../../../module/plugin/extensions/EnumExtension.dart';
import '../../../module/plugin/plugin/FunctionalityPlugin.dart';
import '../../../module/plugin/storeData/PluginInfoDataStore.dart';
import '../common/serverTool.dart';
import '../widget/DashedBorderPainterWidget.dart';
import 'package:path/path.dart' as p;

class FileUploadComponent extends StatefulWidget {
  final VoidCallback onPressedAddFiles;
  final String placeholderText;

  const FileUploadComponent({
    Key? key,
    required this.onPressedAddFiles,
    required this.placeholderText,
  }) : super(key: key);

  @override
  _FileUploadComponentState createState() => _FileUploadComponentState();
}

class _FileUploadComponentState extends State<FileUploadComponent> {
  String? selectedFilePath;
  String? savedFilePath;

  Future<void> _pickFile() async {
    // 使用file_picker选择文件
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        selectedFilePath = result.files.single.path;
      });
      _saveFile();
    }
  }

  Future<void> _saveFile() async {
    if (selectedFilePath == null) return;

    // 获取应用程序的文档目录
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    // 生成唯一目录路径
    String uniqueDirPath = '$appDocPath/plugins/${Uuid().v4()}';
    Directory uniqueDir = Directory(uniqueDirPath);

    // 确保目录存在
    if (!await uniqueDir.exists()) {
      await uniqueDir.create(recursive: true);
    }

    // 重命名文件后缀为 .zip
    String fileName = selectedFilePath!.split('/').last;
    String zipFileName = fileName.replaceAll(RegExp(r'\.[^\.]+$'), '.zip');
    String savePath = '$uniqueDirPath/$zipFileName';

    // 文件后缀检查
    String type = fileName.split(".").last;

    if (type != "plugin") {
      // 不符合
      NotificationInApp().successToast("Unrecognized plugin type");
    } else {
      // 将文件重命名为 .zip
      File selectedFile = File(selectedFilePath!);
      await selectedFile.copy(savePath);

      // 解压缩文件
      final bytes = await File(savePath).readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      // 将解压缩的文件存放在指定目录
      for (final file in archive) {
        final filename = '$uniqueDirPath/${file.name}';
        if (file.isFile) {
          final outputFile = File(filename);
          await outputFile.create(recursive: true);
          await outputFile.writeAsBytes(file.content);
          if (file.name.split(".").last == "dart" ||
              file.name.split(".").last == "evc") {
            // 脚本文件
            String path = outputFile.path;
            // 注册插件
            await registerPlugin(
              evc: file.name.split(".").last == "evc" ? true : false,
              path: path, //
            );

            // 更新
            ServerUiTool().updateShowInfo();
          }
        }
      }
    }

    setState(() {
      savedFilePath = uniqueDirPath;
    });
  }

  /*
  注册插件
   */
  registerPlugin({
    bool evc = true,
    required String path,
  }) async {
    PluginManager pluginManager = PluginManager();
    // 利用指定的插件类型分类处理
    late Plugin plugin;
    // 读取info json插件配置文件为Map
    String pathInfo = p.join(p.dirname(path), "info.json");

    // 读取文件内容
    String fileContent = await File(pathInfo).readAsString();

    // 解析 JSON 文件内容
    Map<String, dynamic> jsonData = json.decode(fileContent);

    // id
    String id = const Uuid().v4();

    switch (PluginTypeEnumExtension.fromString(jsonData["pluginType"])) {
      case PluginType.Functionality:
        // 插件类型Functionality
        // 实例化中间处理模块化插件 继承至Plugin类
        plugin = FunctionalityPlugin(
            category: PluginCategoryEnumExtension.fromString(
                jsonData["pluginCategory"]), // 插件的对应的类别，枚举类型，具体类别见
            evc: evc, // 是否为evc字节码
            path: path, // 插件脚本的文件地址，注意要求有访问权限
            id: id,
            name: jsonData["name"] //插件名称
            );
        break;
      case PluginType.Integration:
      // TODO: Handle this case.
      case PluginType.UI:
      // TODO: Handle this case.
      case PluginType.Security:
      // TODO: Handle this case.
      case PluginType.Analytics:
      // TODO: Handle this case.
      case PluginType.ContentManagement:
      // TODO: Handle this case.
      case PluginType.DevelopmentTools:
      // TODO: Handle this case.
      case PluginType.Automation:
      // TODO: Handle this case.
      case PluginType.DataProcessing:
      // TODO: Handle this case.
      case PluginType.Communication:
      // TODO: Handle this case.
      case PluginType.miniApp:
      // TODO: Handle this case.
    }

    // 注册插件
    pluginManager.registerPlugin(plugin);

    // 存储pluginInfo

    // 替换id
    jsonData["id"] = id;
    jsonData["icon"] = File(p.join(p.dirname(path), "icon.png")).existsSync()
        ? p.join(p.dirname(path), "icon.png")
        : jsonData["icon"];

    // 保存本地
    PluginInfoDataStore().addPluginInfo(jsonData);
    /*
    插件初始化:
    1.方式一：仅初始化该插件
    2.方式二: 初始化所有已注册插件：包括方式1和2
   */
    plugin.initial(); // 方式1 推荐

    // 提示
    NotificationInApp().successToast("add plugin successful!");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickFile,
      child: Stack(
        children: [
          Container(
            width: 300,
            height: 200,
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.upload_file, size: 50, color: Colors.white),
                const SizedBox(height: 10),
                Text(
                  selectedFilePath == null
                      ? widget.placeholderText
                      : "已选择: ${selectedFilePath!.split('/').last}",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 10),
                if (savedFilePath != null)
                  Text(
                    "文件已保存到: $savedFilePath",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
              ],
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: DashedBorderPainter(
                color: Colors.white70,
                strokeWidth: 2.0,
                dashWidth: 5.0,
                dashSpace: 3.0,
                borderRadius: 12.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
