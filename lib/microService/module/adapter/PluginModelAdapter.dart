/*
Hive自定义模型CommandInfoModel调制器
 */

import 'package:hive/hive.dart';

import '../../pluginSystem/storeData/PluginModel.dart';

class PluginModelAdapter extends TypeAdapter<PluginModel> {
  @override
  PluginModel read(BinaryReader reader) {
    // 假设 PluginModel 有属性 id、name 和 version
    final name = reader.readString();
    final category = reader.readString();
    final time = reader.readString();
    final path = reader.readString();
    final evc = reader.readBool();

    return PluginModel(
        name: name,
        category: category,
        path: path,
        evc: evc,
        time: DateTime.parse(time));
  }

  @override
  void write(BinaryWriter writer, PluginModel obj) {
    // 将 PluginModel 的属性写入二进制流
    writer.writeString(obj.name); // 将一个字符串写入二进制流
    writer.writeString(obj.category);
    writer.writeString(obj.time.toString());
    writer.writeString(obj.path);
    writer.writeBool(obj.evc);
  }

  @override
  int get typeId => 1;
}
