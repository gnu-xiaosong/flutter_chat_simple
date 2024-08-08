import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomInfoComponent extends StatefulWidget {
  const BottomInfoComponent({super.key});

  @override
  State<BottomInfoComponent> createState() => _IndexState();
}

class _IndexState extends State<BottomInfoComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40.h,
      padding: EdgeInsets.all(10),
      child: Center(
        child: Text(
          "Copyright by xskj © 2024",
          style: TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}
