/*
Hive自定义模型CommandInfoModel调制器
 */

import 'package:hive/hive.dart';

import '../model/CommandInfoModel.dart';

class CommandInfoAdapter extends TypeAdapter<CommandInfoModel> {
  @override
  int get typeId => 0;

  @override
  CommandInfoModel read(BinaryReader reader) {
    final commandName =
        reader.readString(); // Reading commandName from the binary stream
    final commandDetail = reader.readString(); // Reading commandDetail
    final timestamp = reader.readString(); // Reading timestamp

    return CommandInfoModel(
      commandName: commandName,
      commandDetail: commandDetail,
      timestamp: DateTime.parse(timestamp),
    );
  }

  @override
  void write(BinaryWriter writer, CommandInfoModel obj) {
    writer.writeString(
        obj.commandName); // Writing commandName to the binary stream
    writer.writeString(obj.commandDetail); // Writing commandDetail
    writer.writeString(obj.timestamp.toString()); // Writing timestamp
  }
}
