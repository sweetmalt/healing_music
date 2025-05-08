import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healing_music/controller/main_controller.dart';
import 'package:healing_music/widget/page_title.dart';

class IndexPage extends StatelessWidget {
  final MainController mainController = Get.find();

  IndexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Image.asset(
        "assets/images/bgi.png",
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 50,
          title: PageTitle('BCI'),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 200,
                  width: Get.width,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ThemeData().colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      TextButton(onPressed: () {}, child: const Text("脑电检测")),
                ),
                Container(
                  height: 200,
                  width: Get.width,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: ThemeData().colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      TextButton(onPressed: () {}, child: const Text("脑电创作")),
                ),
                Container(
                  height: 400,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(),
                  child: const Text("Welcome to HealingAI"),
                ),
              ],
            ),
          ),
        ),
      )
    ]);
  }
}
