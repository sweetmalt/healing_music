import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:healing_music/controller/main_controller.dart';
import 'package:healing_music/style/style.dart';

class EditNicknameView extends StatelessWidget {
  EditNicknameView({super.key});
  final MainController mainController = Get.find();
  void back() {
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Column(
          children: [
            ListTile(
              title: Text('修改联系信息', style: MyStyle.paragraphTitleTextStyle),
              subtitle: const Text('请输入新的管理员信息'),
              trailing: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.close)),
            ),
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ThemeData().colorScheme.primaryContainer,
                borderRadius: const BorderRadius.all(Radius.circular(20)),
              ),
              child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      TextFormField(
                          initialValue: mainController.user.getNickname(),
                          decoration: const InputDecoration(
                            labelText: '常用昵称',
                          ),
                          onChanged: (value) {
                            mainController.user.setNickname(value);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入昵称';
                            } else if (value.length < 2) {
                              return '昵称不能少于2个字符';
                            }
                            return null;
                          }),
                      TextFormField(
                          initialValue: mainController.user.getPhoneNumber(),
                          decoration: const InputDecoration(
                            labelText: '联系电话',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(11),
                          ],
                          onChanged: (value) {
                            mainController.user.setPhoneNumber(value);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入联系电话';
                            } else if (value.length != 11) {
                              return '只能是11位数字';
                            }
                            return null;
                          }),
                      TextFormField(
                          initialValue: mainController.user.getAddress(),
                          decoration: const InputDecoration(
                            labelText: '联系地址',
                          ),
                          onChanged: (value) {
                            mainController.user.setAddress(value);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入地址';
                            } else if (value.length < 2) {
                              return '地址不能少于2个字符';
                            }
                            return null;
                          }),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (mainController.user.getNickname().length >= 2 &&
                                mainController.user.getPhoneNumber().length ==
                                    11 &&
                                mainController.user.getAddress().length >= 2) {
                              if (await mainController.user.update()) {
                                mainController.userNickname.value =
                                    mainController.user.getNickname();
                                mainController.userPhoneNumber.value =
                                    mainController.user.getPhoneNumber();
                                mainController.userAddress.value =
                                    mainController.user.getAddress();
                                back();
                                Get.snackbar(
                                  '成功！',
                                  '修改成功',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor:
                                      ThemeData().colorScheme.primary,
                                  colorText:
                                      ThemeData().colorScheme.primaryContainer,
                                );
                              }
                            } else {
                              Get.snackbar(
                                '失败！',
                                '内容有误',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor:
                                    ThemeData().colorScheme.secondary,
                                colorText:
                                    ThemeData().colorScheme.secondaryContainer,
                              );
                            }
                          },
                          child: const Text('确定'),
                        ),
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
