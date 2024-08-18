/*
本地存储的离线消息封装
 */

import '../../store/OffMessageDateStore.dart';
import '../model/OffLineDataModel.dart';

class OffDataStoreQueue extends OffMessageDateStore {
  OffDataStoreQueue() {
    // 获取本地消息列表
    _queue = OffMessageDateStore.getPluginListInHive();
  }

  // 获取本地存储列表
  late List<OffLineDataModel> _queue;

  // 将消息入队
  void enqueue(Map<String, dynamic> message) {
    // 添加进入队列
    addOffLineData(message);
    // 更新列表数据
    _queue = OffMessageDateStore.getPluginListInHive();
  }

  // 从队列中取出消息
  OffLineDataModel? dequeue() {
    if (_queue.isNotEmpty) {
      // 删除
      OffLineDataModel first = _queue.removeAt(0);
      // 删除本地存储
      deleteOffData(first.id);
      // 更新
      _queue = OffMessageDateStore.getPluginListInHive();
      return first;
    } else {
      return null;
    }
  }

  // 获取队列的长度
  int get length => _queue.length;

  // 清空队列
  void clear() {
    clearPluginsInHive();
    _queue.clear();
  }
}
