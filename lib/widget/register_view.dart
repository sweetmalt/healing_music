import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:healing_music/controller/depot_controller.dart';
import 'package:healing_music/style/style.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});
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
                          initialValue: depotController.user.agencyName.value,
                          decoration: const InputDecoration(
                            labelText: '机构名称',
                          ),
                          onChanged: (value) {
                            depotController.user.agencyName.value = value;
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
                          initialValue:
                              depotController.user.adminNickname.value,
                          decoration: const InputDecoration(
                            labelText: '联系人昵称',
                          ),
                          onChanged: (value) {
                            depotController.user.adminNickname.value = value;
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '请输入联系人昵称';
                            } else if (value.length < 2) {
                              return '联系人昵称应不少于2位字符';
                            }
                            return null;
                          }),
                      TextFormField(
                          initialValue:
                              depotController.user.adminPhonenumber.value,
                          decoration: const InputDecoration(
                            labelText: '联系电话（手机号）',
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
                              return '请输入手机号';
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
                      TextFormField(
                          initialValue: depotController.user.adminAddress.value,
                          decoration: const InputDecoration(
                            labelText: '所在地址',
                          ),
                          onChanged: (value) {
                            depotController.user.adminAddress.value = value;
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
                          onPressed: () {
                            if (depotController.user.regist()) {
                              Get.back();
                              Get.snackbar(
                                '成功！',
                                '注册 & 登录',
                                duration: const Duration(seconds: 1),
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
                                duration: const Duration(seconds: 1),
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
