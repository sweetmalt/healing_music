import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:healing_music/controller/main_controller.dart';
import 'package:healing_music/style/style.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});
  final MainController mainController = Get.find();
  void back() {
    Get.back();
  }

  final RxInt _sex = 0.obs;

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
              title: Text('注册', style: MyStyle.paragraphTitleTextStyle),
              subtitle: const Text('以下全为必填项'),
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
                          initialValue: mainController.user.getName(),
                          decoration: const InputDecoration(
                            labelText: '机构名称',
                          ),
                          onChanged: (value) {
                            mainController.user.setName(value);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入机构名称';
                            } else if (value.length < 2) {
                              return '机构名称应不少于2位字符';
                            }
                            return null;
                          }),
                      TextFormField(
                          initialValue: mainController.user.getNickname(),
                          decoration: const InputDecoration(
                            labelText: '联系人昵称',
                          ),
                          onChanged: (value) {
                            mainController.user.setNickname(value);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入联系人昵称';
                            } else if (value.length < 2) {
                              return '联系人昵称应不少于2位字符';
                            }
                            return null;
                          }),
                      //性别选择
                      Row(
                        children: [
                          const Text('性别：'),
                          Obx(() => Radio(
                                value: 0,
                                groupValue: _sex.value,
                                onChanged: (value) {
                                  if (value is int) {
                                    _sex.value = value;
                                    mainController.user.setSex(_sex.value);
                                  }
                                },
                              )),
                          const Text('女'),
                          Obx(() => Radio(
                                value: 1,
                                groupValue: _sex.value,
                                onChanged: (value) {
                                  if (value is int) {
                                    _sex.value = value;
                                    mainController.user.setSex(_sex.value);
                                  }
                                },
                              )),
                          const Text('男'),
                        ],
                      ),
                      TextFormField(
                          initialValue: mainController.user.getPhoneNumber(),
                          decoration: const InputDecoration(
                            labelText: '联系电话（手机号）',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(11),
                          ],
                          onChanged: (value) {
                            mainController.user.setPhoneNumber(value);
                            if (value.length == 11) {
                              FocusScope.of(context).unfocus();
                              SystemChannels.textInput
                                  .invokeMethod('TextInput.hide');
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入联系电话';
                            } else if (value.length != 11) {
                              return '联系电话应为11位数字';
                            }
                            return null;
                          }),
                      TextFormField(
                          initialValue: mainController.user.getAddress(),
                          decoration: const InputDecoration(
                            labelText: '所在地址',
                          ),
                          onChanged: (value) {
                            mainController.user.setAddress(value);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入所在地址';
                            } else if (value.length < 2) {
                              return '所在地址应不少于2位字符';
                            }
                            return null;
                          }),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            mainController.user.createCode();
                            await mainController.user.update();
                            if (await mainController.user.validate()) {
                              await mainController.user.register();
                              mainController.agency
                                  .setCode(mainController.user.getCode());
                              int timeStamp =
                                  DateTime.now().millisecondsSinceEpoch;
                              mainController.agency.setRegTime(timeStamp);
                              mainController.agency.setLogTime(timeStamp);
                              mainController.agency.update();
                              mainController.agency.login();
                              mainController.synUserInfo();
                              back();
                              Get.snackbar(
                                '成功！',
                                '注册 & 登录',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor:
                                    ThemeData().colorScheme.primary,
                                colorText:
                                    ThemeData().colorScheme.primaryContainer,
                              );
                            } else {
                              Get.snackbar(
                                '失败！',
                                '可能的输入或网络错误',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor:
                                    ThemeData().colorScheme.secondary,
                                colorText:
                                    ThemeData().colorScheme.secondaryContainer,
                              );
                            }
                          },
                          child: const Text('注册'),
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
