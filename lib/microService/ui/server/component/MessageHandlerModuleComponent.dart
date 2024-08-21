import 'package:graphview/GraphView.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../service/client/common/CommunicationTypeClientModulator.dart';
import '../../../service/server/extentions/EnumExtension.dart';

class MessageHandlerModuleComponent extends StatefulWidget {
  const MessageHandlerModuleComponent({super.key});

  @override
  State<MessageHandlerModuleComponent> createState() => _IndexState();
}

class _IndexState extends State<MessageHandlerModuleComponent> {
  final Graph graph = Graph()..isTree = true;
  BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();

  @override
  void initState() {
    int id = 0;
    // 总节点
    final rootNode = Node.Id(id);

    // 创建连接

    MsgTypeEnumExtension.labelList.forEach((value) {
      final node = Node.Id(++id);
      graph.addEdge(rootNode, node,
          paint: Paint()
            ..color = Colors.blue
            ..style = PaintingStyle.stroke);
    });

    // 构建器设置
    builder
      ..siblingSeparation = (50)
      ..levelSeparation = (60)
      ..subtreeSeparation = (60)
      ..orientation = (BuchheimWalkerConfiguration.ORIENTATION_LEFT_RIGHT);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
      width: double.infinity,
      height: 400.h,
      child: Column(
        children: [
          // 标题
          Center(
            child: NeumorphicText(
              "handler module".tr(),
              style: NeumorphicStyle(color: Colors.black),
              textStyle: NeumorphicTextStyle(
                  fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          SizedBox(height: 10),
          // 在线列表
          Expanded(
            // 或者使用 Flexible
            child: MsgTypeEnumExtension.count == 0
                ? Center(
                    child: Text(
                      "no ws module".tr(),
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                          fontWeight: FontWeight.w100),
                    ),
                  )
                : Container(
                    child: Expanded(
                      child: InteractiveViewer(
                          constrained: false,
                          boundaryMargin: EdgeInsets.all(100),
                          minScale: 0.01,
                          maxScale: 5.6,
                          child: GraphView(
                            graph: graph,
                            algorithm: BuchheimWalkerAlgorithm(
                                builder, TreeEdgeRenderer(builder)),
                            paint: Paint()
                              ..color = Colors.green
                              ..strokeWidth = 1
                              ..style = PaintingStyle.stroke,
                            builder: (Node node) {
                              // I can decide what widget should be shown here based on the id
                              List names = MsgTypeEnumExtension.labelList;
                              names.insert(
                                  0, "CommunicationTypeServerModulator");

                              var a = node.key?.value as int;

                              return rectangleWidget(a, names[a]);
                            },
                          )),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget rectangleWidget(int a, String lable) {
    return InkWell(
      onTap: () {
        print('clicked');
      },
      child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(color: Colors.blue.shade100, spreadRadius: 1),
            ],
          ),
          child: Text(
            lable.toString().tr(),
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          )),
    );
  }
}
