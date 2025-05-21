import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healing_music/controller/depot_controller.dart';
import 'package:healing_music/page/main_page.dart';
import 'package:healing_music/widget/login_view.dart';
import 'package:healing_music/widget/register_view.dart';
import 'package:healing_music/widget/rotating_button.dart';

class DepotPage extends StatelessWidget {
  DepotPage({super.key});
  final DepotController controller = Get.put(DepotController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(40),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyTextP3("HealingAI", colorPrimary),
                const SizedBox(width: 10),
                RotatingButton(
                  onPressed: () {
                    Get.back();
                  },
                  image: const AssetImage("assets/images/logo.png"),
                ),
                const SizedBox(width: 10),
                 MyTextP3("能量驿站", colorPrimary),
              ],
            ),
            const MyTextH1("我的，"),
            Obx(() => MyTextH3(
                "机构名称：${controller.user.agencyName.value}", colorSecondary)),
            Obx(() => MyTextP2(
                  "注册时间：${controller.user.registTimestamp.value}",
                )),
            Obx(() => MyTextP2(
                  "上次登录：${controller.user.lastLoginTimestamp.value}",
                )),
            Obx(() => MyTextH3(
                "账户余额：${controller.user.tokens.value}", colorSecondary)),
            Obx(() => MyTextH3(
                "账户等级：VIP${controller.user.vip.value}", colorSecondary)),
            Obx(() => MyTextH3(
                "昵称：${controller.user.adminNickname.value}", colorPrimary)),
            Obx(() => MyTextH3("联系电话：${controller.user.adminPhonenumber.value}",
                colorSecondary)),
            Obx(() => MyTextH3(
                "联系地址：${controller.user.adminAddress.value}", colorSecondary)),
            SizedBox(
              height: 200,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircularIconTextButton(
                      icon: Icons.login,
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      text: "登录",
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return LoginView();
                            });
                      },
                    ),
                    CircularIconTextButton(
                      icon: Icons.group,
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      text: "注册",
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return RegisterView();
                            });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
