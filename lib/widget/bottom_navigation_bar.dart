import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healing_music/controller/main_controller.dart';

class BottomNavigationBarWidget extends StatelessWidget {
  BottomNavigationBarWidget({super.key});
  final MainController controller =
      Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
          items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: '疗愈音乐',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.hearing),
            label: '音疗服务',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: '能量驿站',
          ),
          ],
        ));
  }
}
