import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FtpClientHomePage extends StatefulWidget {
  const FtpClientHomePage({super.key});

  @override
  State<FtpClientHomePage> createState() => _IndexState();
}

class _IndexState extends State<FtpClientHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ftp client'.tr()),
          actions: [],
        ),
        body: Text("test"));
  }
}
