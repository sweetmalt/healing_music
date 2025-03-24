import 'package:get/get.dart';

class MusicController extends GetxController {
  // 在这里定义你的状态和方法
  final count = 0.obs;

  void increment() {
    count.value++;
  }
}