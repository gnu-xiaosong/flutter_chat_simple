/*
 * @Author: xskj
 * @Date: 2023-12-29 16:19:41
 * @LastEditors: xskj
 * @LastEditTime: 2023-12-30 12:42:13
 * @Description: home页 topTab切换标签tabview
 */

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

//主页面组件
Widget Index() {
  return Center(
    child: Text("tabview 3"),
  );
}

//刷新控制器获取控制器
RefreshController _refreshController = RefreshController(initialRefresh: false);
void _onRefresh() async {
  // monitor network fetch
  await Future.delayed(const Duration(milliseconds: 1000));
  // if failed,use refreshFailed()
  _refreshController.refreshCompleted();
}

void _onLoading() async {
  // monitor network fetch
  await Future.delayed(const Duration(milliseconds: 1000));
  // if failed,use loadFailed(),if no data return,use LoadNodata()
  // items.add((items.length + 1).toString());
  // if (mounted) setState(() {});
  _refreshController.loadComplete();
}

class TabView3 extends StatefulWidget {
  const TabView3({super.key});

  @override
  State<TabView3> createState() => _TabView3State();
}

class _TabView3State extends State<TabView3> {
  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: const WaterDropHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: Index());
  }
}
