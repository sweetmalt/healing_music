import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:healing_music/controller/depot_controller.dart';
import 'package:healing_music/style/style.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});
  final DepotController depotController = Get.find();

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
              subtitle: const Text('请输入您的11位手机号和8位登录密码'),
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
                          initialValue:
                              depotController.user.adminPhonenumber.value,
                          decoration: const InputDecoration(
                            labelText: '联系人手机号',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(11),
                          ],
                          onChanged: (value) {
                            depotController.user.adminPhonenumber.value = value;
                            if (value.length == 11) {
                              FocusScope.of(context).unfocus();
                              SystemChannels.textInput
                                  .invokeMethod('TextInput.hide');
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入11位手机号';
                            } else if (value.length != 11) {
                              return '手机号必须是11位数字';
                            }
                            return null;
                          }),
                      TextFormField(
                          initialValue:
                              depotController.user.adminPassword.value,
                          decoration: const InputDecoration(
                            labelText: '登录密码',
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(8),
                          ],
                          onChanged: (value) {
                            depotController.user.adminPassword.value = value;
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
                          onPressed: () {
                            Get.back();
                            depotController.user.login();
                          },
                          child: Obx(() =>
                              switch (depotController.user.loginState.value) {
                                0 => const Text('登录'),
                                1 => const CircularProgressIndicator(),
                                2 => const Text('已登录，可重新登录'),
                                int() => throw UnimplementedError(),
                              }),
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
