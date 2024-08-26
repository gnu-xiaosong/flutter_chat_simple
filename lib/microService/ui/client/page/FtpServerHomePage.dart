import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FtpServerHomePage extends StatefulWidget {
  const FtpServerHomePage({super.key});

  @override
  State<FtpServerHomePage> createState() => _IndexState();
}

class _IndexState extends State<FtpServerHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('ftp server'.tr()),
          actions: [],
        ),
        body: Text("test"));
  }
}
