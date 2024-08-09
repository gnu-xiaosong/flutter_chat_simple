import 'package:flutter/material.dart';
import '../../config/EmbedingConfig.dart' show isBasicLayout, isShowAppBar;
import '../../pages/embed/Home.dart';
import '../../widgets/embed/appBars/EmbedAppBar.dart';
import '../../widgets/embed/bodys/EmbedBody.dart';

class EmbedLayout extends StatefulWidget {
  const EmbedLayout({super.key});

  @override
  State<EmbedLayout> createState() => _EmbedLayoutState();
}

class _EmbedLayoutState extends State<EmbedLayout> {
  @override
  Widget build(BuildContext context) {
    return _scaffold(context);
  }
}

Scaffold _scaffold(BuildContext context) {
  return isShowAppBar
      ? Scaffold(
          //顶部区域
          appBar: embedAppBar(),
          //底部主体部分: 两种形式:单页面 or 基本结构新形势
          body: isBasicLayout ? EmbedBody() : EmbedHome())
      : Scaffold(
          //底部主体部分: 两种形式:单页面 or 基本结构新形势
          body: isBasicLayout ? EmbedBody() : EmbedHome());
}
