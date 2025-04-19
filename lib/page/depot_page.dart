import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healing_music/controller/depot_controller.dart';
//import 'package:healing_music/widget/edit_agencyname_view.dart';
//import 'package:healing_music/widget/edit_admininfo_view.dart';
import 'package:healing_music/widget/item.dart';
import 'package:healing_music/widget/login_view.dart';
import 'package:healing_music/widget/page_title.dart';
import 'package:healing_music/widget/paragraph.dart';
import 'package:healing_music/widget/paragraph_bottom.dart';
import 'package:healing_music/widget/register_view.dart';
import 'package:healing_music/widget/rotating_button.dart';

class DepotPage extends StatelessWidget {
  DepotPage({super.key});
  final DepotController controller = Get.put(DepotController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 25,
        title: Obx(() => switch (controller.user.loginState.value) {
              0 => PageTitle('User Center - 未登录'),
              1 => const CircularProgressIndicator(),
              2 => PageTitle('User Center - 已登录'),
              int() => throw UnimplementedError(),
            }),
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
                const SizedBox(
                  height: 40,
                ),
                RotatingButton(
                  onPressed: () {},
                  image: const AssetImage('assets/images/logo.png'),
                ),
                Obx(() => UserParagraphListTile(
                      title: "机构：${controller.user.agencyName.value}",
                      onTap: () {
                        // showModalBottomSheet(
                        //     context: context,
                        //     isScrollControlled: true,
                        //     builder: (context) {
                        //       return EditAgencyNameView();
                        //     });
                      },
                    )),
                Obx(() => UserItemListTile(
                      title: '注册时间',
                      subtitle: " ${controller.user.registTimestamp.value}",
                      onTap: () {},
                    )),
                Obx(() => UserItemListTile(
                      title: '上次登录',
                      subtitle: " ${controller.user.lastLoginTimestamp.value}",
                      onTap: () {},
                    )),
                Obx(() => UserItemListTile(
                      title: '账户余额',
                      subtitle: " ${controller.user.tokens.value}",
                      onTap: () {},
                    )),
                Obx(() => UserParagraphBottomListTile(
                      title: "VIP等级：${controller.user.vip.value}",
                      onTap: () {},
                    )),
                Obx(() => UserParagraphListTile(
                      title: "联系人：${controller.user.adminNickname.value}",
                      onTap: () {
                        // showModalBottomSheet(
                        //     context: context,
                        //     isScrollControlled: true,
                        //     builder: (context) {
                        //       return EditAdminInfoView();
                        //     });
                      },
                    )),
                Obx(() => UserItemListTile(
                      title: '联系电话',
                      subtitle: " ${controller.user.adminPhonenumber.value}",
                      onTap: () {},
                    )),
                Obx(() => UserItemListTile(
                      title: '联系地址',
                      subtitle: " ${controller.user.adminAddress.value}",
                      onTap: () {},
                    )),
                UserParagraphBottomListTile(
                  title: '.',
                  onTap: () {},
                ),
                SizedBox(
                  height: 120,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.deepPurple,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return LoginView();
                                });
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('登录'),
                              Icon(
                                Icons.login,
                                size: 15,
                                color: Colors.deepPurple,
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.deepPurple,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return RegisterView();
                                });
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('注册'),
                              Icon(
                                Icons.group,
                                size: 15,
                                color: Colors.deepPurple,
                              ),
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
