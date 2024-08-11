/*
好友用户列表
 */
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'SettingPage.dart';

class PersonPage extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<PersonPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("person".tr()),
        centerTitle: true,
        actions: [
          // settiing
          IconButton(
            onPressed: () {
              // 跳转设置页面
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return const SettingPage();
                  },
                ),
              );
            },
            icon: const Icon(
              Icons.settings,
              size: 30,
            ),
          )
        ],
      ),
      body: Container(
        child: Text("PersonPage"),
      ),
    );
  }
}
