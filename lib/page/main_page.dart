import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healing_music/controller/main_controller.dart';
import 'package:healing_music/page/face_page.dart';
import 'package:healing_music/page/music_page.dart';
import 'package:healing_music/page/healing_page.dart';
import 'package:healing_music/page/depot_page.dart';
import 'package:healing_music/widget/app_bar_title.dart';
import 'package:healing_music/widget/bottom_navigation_bar.dart';

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
        toolbarHeight: 25,
        title: AppBarTitle('AI音疗 HealingMusic'),
        centerTitle: true,
      ),
      body: GetX<MainController>(
        init: MainController(),
        builder: (controller) {
          return IndexedStack(
            index: controller.currentIndex.value,
            children: [
              MusicPage(),
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
