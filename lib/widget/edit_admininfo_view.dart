import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:healing_music/controller/depot_controller.dart';
import 'package:healing_music/style/style.dart';

class EditAdminInfoView extends StatelessWidget {
  EditAdminInfoView({super.key});
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
                          initialValue:
                              depotController.user.adminNickname.value,
                          decoration: const InputDecoration(
                            labelText: '常用昵称',
                          ),
                          onChanged: (value) {
                            depotController.user.adminNickname.value = value;
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
                          initialValue: depotController.user.adminAddress.value,
                          decoration: const InputDecoration(
                            labelText: '联系地址',
                          ),
                          onChanged: (value) {
                            depotController.user.adminAddress.value = value;
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
                          onPressed: () {
                            Get.back();
                            if (depotController.user.updateAdminInfo()) {
                              Get.snackbar(
                                '成功！',
                                '修改成功',
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
                                '内容有误',
                                duration: const Duration(seconds: 1),
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
