/*
Hive自定义模型CommandInfoModel调制器
 */
import 'package:hive/hive.dart';
import 'PluginModel.dart';

class PluginModelAdapter extends TypeAdapter<PluginModel> {
  @override
  PluginModel read(BinaryReader reader) {
    // 假设 PluginModel 有属性 id、name 和 version
    final name = reader.readString();
    final id = reader.readString();
    final category = reader.readInt();
    final time = reader.readString();
    final path = reader.readString();
    final evc = reader.readBool();
    final type = reader.readInt();
    final status = reader.readBool();

    return PluginModel(
        name: name,
        id: id,
        category: category,
        path: path,
        evc: evc,
        time: DateTime.parse(time),
        type: type,
        status: status);
  }

  @override
  void write(BinaryWriter writer, PluginModel obj) {
    // 将 PluginModel 的属性写入二进制流
    writer.writeString(obj.name); // 将一个字符串写入二进制流
    writer.writeString(obj.id);
    writer.writeInt(obj.category);
    writer.writeString(obj.time.toString());
    writer.writeString(obj.path);
    writer.writeBool(obj.evc);
    writer.writeInt(obj.type);
    writer.writeBool(obj.status);
  }

  @override
  int get typeId => 12;
}
