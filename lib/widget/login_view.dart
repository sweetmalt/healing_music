import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:healing_music/controller/main_controller.dart';
import 'package:healing_music/style/style.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});
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
              title: Text('登录', style: MyStyle.paragraphTitleTextStyle),
              subtitle: const Text('请输入您的8位登录密码'),
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
                      const Text("机构代码：18位数字"),
                      Text(mainController.agency.getCode()),
                      TextFormField(
                          initialValue: mainController.agency.getPassword(),
                          decoration: const InputDecoration(
                            labelText: '登录密码',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(8),
                          ],
                          onChanged: (value) {
                            mainController.agency.setPassword(value);
                            if (value.length == 8) {
                              FocusScope.of(context).unfocus();
                              SystemChannels.textInput
                                  .invokeMethod('TextInput.hide');
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入登录密码';
                            } else if (value.length != 8) {
                              return '登录密码必须是8位数字';
                            }
                            return null;
                          }),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (await mainController.agency.validate()) {
                              mainController.agency.login();
                              back();
                              Get.snackbar(
                                '成功！',
                                '登录成功',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor:
                                    ThemeData().colorScheme.primary,
                                colorText:
                                    ThemeData().colorScheme.primaryContainer,
                              );
                            } else {
                              Get.snackbar(
                                '失败！',
                                '密码错误',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor:
                                    ThemeData().colorScheme.secondary,
                                colorText:
                                    ThemeData().colorScheme.secondaryContainer,
                              );
                            }
                          },
                          child: const Text('登录'),
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
