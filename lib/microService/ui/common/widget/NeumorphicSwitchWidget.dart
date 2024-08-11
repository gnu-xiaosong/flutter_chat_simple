import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class NeumorphicSwitchWidget extends StatefulWidget {
  final String label;
  final bool value;
  int flex;

  final ValueChanged<bool> onChanged;

  NeumorphicSwitchWidget(
      {required this.label,
      required this.flex,
      required this.value,
      required this.onChanged});

  @override
  __TextFieldState createState() => __TextFieldState();
}

class __TextFieldState extends State<NeumorphicSwitchWidget> {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  NeumorphicSwitch(
                    style: NeumorphicSwitchStyle(
                        activeThumbColor: Colors.white,
                        activeTrackColor: Colors.green.shade500,
                        inactiveThumbColor: Colors.grey.shade500,
                        thumbDepth: 10),
                    value: widget.value,
                    onChanged: widget.onChanged,
                  )
                ],
              )),
        ],
      ),
    );
  }
}
