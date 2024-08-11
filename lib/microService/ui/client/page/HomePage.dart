import 'package:bottom_sheet_scaffold/bottom_sheet_scaffold.dart';
import 'package:flutter/material.dart';
import '../../../../config/AppConfig.dart';
import '../websocket/UiWebsocketClient.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _PageHomeState();
}

class _PageHomeState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      //initialIndex: 1,  //初始化tab index
      length: AppConfig.TopTabs.length,
      child: _scaffold(context),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}

Text _scaffold(BuildContext context) {
  return Text("home");
}

class BottomSheetHeader extends StatelessWidget {
  const BottomSheetHeader({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 6,
      color: Colors.red,
    );
  }
}

class BottomSheetBody extends StatelessWidget {
  const BottomSheetBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("BottomSheetBody"),
    );
  }
}
