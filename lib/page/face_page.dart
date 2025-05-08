import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healing_music/page/main_page.dart';
import 'package:healing_music/widget/rotating_button.dart';

class FacePage extends StatelessWidget {
  const FacePage({super.key});

  @override
  Widget build(BuildContext context) {
    //3秒钟后，返回主界面
    Future.delayed(const Duration(seconds: 3), () {
      Get.back();
    });
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Container(
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
                  RotatingButton(
                    onPressed: () {
                      Get.off(MainPage());
                    },
                    image: const AssetImage('assets/images/logo.png'),
                  ),
                  const SizedBox(
                    height: 30,
                    child: Text(
                      "欢迎使用",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                    child: Text(
                      "Healing Music",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
