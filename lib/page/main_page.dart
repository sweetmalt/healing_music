import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:healing_music/controller/main_controller.dart';
import 'package:healing_music/page/face_page.dart';
import 'package:healing_music/page/music_page.dart';
import 'package:healing_music/page/healing_page.dart';
import 'package:healing_music/page/depot_page.dart';
import 'package:healing_music/widget/app_bar_title.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    //开机显示face页面
    Future.delayed(const Duration(seconds: 1), () {
      Get.to(() => const FacePage());
    });

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        title: AppBarTitle('AI音疗 HealingMusic'),
        centerTitle: true,
        shadowColor: ThemeData().colorScheme.primary,
        leading: IconButton(onPressed: () => {}, icon: const Icon(Icons.menu)),
        actions: [
          CloseButton(
            onPressed: () => SystemNavigator.pop(),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                  ThemeData().colorScheme.primaryContainer),
            ),
          )
        ],
      ),
      body: GetX<MainController>(
        init: MainController(),
        builder: (controller) {
          return IndexedStack(
            index: controller.currentIndex.value,
            children: [
              const MusicPage(),
              HealingPage(),
              DepotPage(),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBarWidget(),
    );
  }
}

class BottomNavigationBarWidget extends StatelessWidget {
  BottomNavigationBarWidget({super.key});
  final MainController controller = Get.put(MainController());

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
