/*
生成适用于Functionlity的evc字节码文件，与pluginInsertPointsClass目录中FunctionalityModulePluginInsertPoint对应
 */
import 'dart:io';
import 'package:uuid/uuid.dart';
import '../pluginInsertPointsClass/FunctionalityModulePluginInsertPoint.dart';

main() {
  FunctionalityModulePluginInsertPoint functionalityModulePluginInsertPoint =
      FunctionalityModulePluginInsertPoint();
  // dart源码文件
  final dartPath =
      'D:\\ProjectDevelopment\\plugin_system\\dart_plugin_system\\assets\\plugin\\pluginName_plugin.dart';
  // evc文件名
  final fileName = "functionality_${Uuid().v1()}_plugin.evc";
  // 储存路径
  final evcPath =
      "D:\\ProjectDevelopment\\plugin_system\\dart_plugin_system\\lib\\evc\\" +
          fileName;

  // 读取文件源码
  String source =
      functionalityModulePluginInsertPoint.readFileContent(dartPath);
  // 编译成evc字节码文件
  final program = functionalityModulePluginInsertPoint.compileEvc(source);
  // 写入文件中
  final bytecode = program.write();
  final file = File(evcPath);
  file.writeAsBytesSync(bytecode);
  print("evc write successful! path:$evcPath");
}
