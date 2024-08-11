import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class NeumorphicTextField extends StatefulWidget {
  final String label;
  final String hint;
  final int flex;

  final ValueChanged<String> onChanged;

  NeumorphicTextField(
      {required this.label,
      required this.flex,
      required this.hint,
      required this.onChanged});

  @override
  __TextFieldState createState() => __TextFieldState();
}

class __TextFieldState extends State<NeumorphicTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.hint);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int flexSum = 18;
    int hintFlex = 4;

    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              flex: hintFlex,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  widget.label.toString().tr(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              )),
          Expanded(flex: flexSum - widget.flex - hintFlex, child: SizedBox()),
          Expanded(
            flex: widget.flex,
            // Expanded 应该直接放在 Row 中
            child: Neumorphic(
              style: NeumorphicStyle(
                depth: NeumorphicTheme.embossDepth(context),
                boxShape: NeumorphicBoxShape.stadium(),
              ),
              padding: EdgeInsets.symmetric(vertical: 1, horizontal: 18),
              child: TextField(
                onChanged: this.widget.onChanged,
                controller: _controller,
                decoration: InputDecoration(
                  border: InputBorder.none, // 移除默认边框
                  enabledBorder: InputBorder.none, // 移除启用状态下的边框
                  focusedBorder: InputBorder.none, // 移除聚焦状态下的边框
                  hintText: this.widget.hint, // 设置提示文字
                  fillColor: Colors.transparent, // 设置背景色为透明
                  filled: false, // 不填充背景色
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
