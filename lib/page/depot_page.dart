import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healing_music/controller/depot_controller.dart';
import 'package:healing_music/controller/main_controller.dart';
import 'package:healing_music/widget/edit_name_view.dart';
import 'package:healing_music/widget/edit_nickname_view.dart';
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
  final MainController mainController = Get.find();

  @override
  Widget build(BuildContext context) {
    mainController.synUserInfo();
    mainController.agency.setLogTime(mainController.currentLogTime);
    mainController.agency.update();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 25,
        title: PageTitle('User & Report'),
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
                UserParagraphListTile(
                  title: "机构：${mainController.userName.value}",
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return EditNameView();
                        });
                  },
                ),
                UserItemListTile(
                  title: '工作机入网码（18位）',
                  subtitle: " ${mainController.userCode.value}",
                  onTap: () {},
                ),
                UserItemListTile(
                  title: '注册时间',
                  subtitle: " ${mainController.regTime.value}",
                  onTap: () {},
                ),
                UserItemListTile(
                  title: '上次登录',
                  subtitle: " ${mainController.logTime.value}",
                  onTap: () {},
                ),
                UserParagraphBottomListTile(
                  title: '.',
                  onTap: () {},
                ),
                UserParagraphListTile(
                  title: "管理员：${mainController.userNickname.value}",
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) {
                          return EditNicknameView();
                        });
                  },
                ),
                UserItemListTile(
                  title: '联系电话',
                  subtitle: " ${mainController.userPhoneNumber.value}",
                  onTap: () {},
                ),
                UserItemListTile(
                  title: '联系地址',
                  subtitle: " ${mainController.userAddress.value}",
                  onTap: () {},
                ),
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
                                  if (!mainController.agency.getLogin()) {
                                    if (!mainController.user.getRegister()) {
                                      return RegisterView();
                                    } else {
                                      return LoginView();
                                    }
                                  } else {
                                    return const SizedBox(
                                      height: 200,
                                      child: Center(
                                        child: Text('您已登录'),
                                      ),
                                    );
                                  }
                                });
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('工作机登录/注册'),
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
                            //Get.to(ChatPage());
                          },
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('AI'),
                              Icon(
                                Icons.login,
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
