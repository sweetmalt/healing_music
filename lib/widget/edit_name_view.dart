import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healing_music/controller/main_controller.dart';
import 'package:healing_music/style/style.dart';

class EditNameView extends StatelessWidget {
  EditNameView({super.key});
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
              title: Text('修改能量驿站所属机构名称', style: MyStyle.paragraphTitleTextStyle),
              subtitle: const Text('请输入新的机构名称'),
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
                              return '机构名称不能少于2个字符';
                            }
                            return null;
                          }),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (mainController.user.getName().length >= 2) {
                              if (await mainController.user.update()) {
                                mainController.userName.value =
                                    mainController.user.getName();
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
                                '机构名称不能少于2个字符',
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
