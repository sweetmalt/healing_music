import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healing_music/controller/healing_controller.dart';
import 'package:healing_music/controller/main_controller.dart';
import 'package:healing_music/controller/players_controller.dart';
import 'package:healing_music/widget/circular_button.dart';
import 'package:healing_music/widget/page_title.dart';

class AlbumPage extends StatelessWidget {
  final MainController mainController = Get.find();
  final HemController hemController = Get.find();
  final EnvController envController = Get.find();
  final HealingController healingController = Get.find();

  AlbumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        title: PageTitle('Music Album'),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bgi.png"),
            fit: BoxFit.cover,
          ),
        ),
        width: MediaQuery.of(context).size.width, // 使用屏幕宽度
        height: MediaQuery.of(context).size.height,

        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 40,
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  decoration: const BoxDecoration(),
                  child: Obx(() => Text(healingController.title.value,
                      style: TextStyle(
                          color: ThemeData().colorScheme.surface,
                          fontSize: 20,
                          fontWeight: FontWeight.bold))),
                ),
                Container(
                  height: 40,
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  decoration: const BoxDecoration(),
                  child: Text("疗愈时长选择",
                      style: TextStyle(
                          color: ThemeData().colorScheme.secondary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
                CircularButton(
                  text: '15分钟',
                  icon: Icons.timer,
                  onPressed: () {
                    hemController.play();
                    envController.play();
                    hemController.setTimer(900);
                    envController.setTimer(900);
                    mainController.changePage(1);
                    Get.back();
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                CircularButton(
                  text: '30分钟',
                  icon: Icons.timer,
                  onPressed: () {
                    hemController.play();
                    envController.play();
                    hemController.setTimer(1800);
                    envController.setTimer(1800);
                    mainController.changePage(1);
                    Get.back();
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                CircularButton(
                  text: '45分钟',
                  icon: Icons.timer,
                  onPressed: () async {
                    hemController.play();
                    envController.play();
                    hemController.setTimer(2700);
                    envController.setTimer(2700);
                    mainController.changePage(1);
                    Get.back();
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                CircularButton(
                  text: '60分钟',
                  icon: Icons.timer,
                  onPressed: () async {
                    hemController.play();
                    envController.play();
                    hemController.setTimer(3600);
                    envController.setTimer(3600);
                    mainController.changePage(1);
                    Get.back();
                  },
                ),
                SizedBox(
                  height: 120,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                ThemeData().colorScheme.primaryContainer,
                            foregroundColor: ThemeData().colorScheme.primary,
                          ),
                          onPressed: () {
                            Get.back();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.arrow_back,
                                size: 15,
                                color: ThemeData().colorScheme.primary,
                              ),
                              const Text('返回'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
