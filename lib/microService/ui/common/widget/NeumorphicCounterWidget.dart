import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class NeumorphicCounterWidget extends StatefulWidget {
  final String label;
  final double value;
  int flex;

  final ValueChanged<String> onChanged;

  NeumorphicCounterWidget(
      {required this.label,
      required this.flex,
      required this.value,
      required this.onChanged});

  @override
  __TextFieldState createState() => __TextFieldState();
}

class __TextFieldState extends State<NeumorphicCounterWidget> {
  int flexSum = 18;
  int hintFlex = 4;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Expanded(flex: flexSum - hintFlex - widget.flex, child: SizedBox()),
          Expanded(
            flex: widget.flex,
            // Expanded 应该直接放在 Row 中
            child: Neumorphic(
              style: NeumorphicStyle(
                depth: NeumorphicTheme.embossDepth(context),
                boxShape: NeumorphicBoxShape.stadium(),
              ),
              padding: EdgeInsets.symmetric(vertical: 1, horizontal: 18),
              child: TextFormField(
                initialValue: widget.value.toString(),
                keyboardType: TextInputType.number, // 限定输入键盘类型为数字键盘
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly, // 仅允许输入数字
                ],
                decoration: InputDecoration(
                  border: InputBorder.none, // 移除默认边框
                  enabledBorder: InputBorder.none, // 移除启用状态下的边框
                  focusedBorder: InputBorder.none, // 移除聚焦状态下的边框
                  // hintText: this.widget.value, // 设置提示文字
                  fillColor: Colors.transparent, // 设置背景色为透明
                  filled: false, // 不填充背景色
                ),
                onChanged: widget.onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
