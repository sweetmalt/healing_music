import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healing_music/controller/depot_controller.dart';
import 'package:healing_music/style/style.dart';

class EditAgencyNameView extends StatelessWidget {
  EditAgencyNameView({super.key});
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
              title:
                  Text('修改能量驿站所属机构名称', style: MyStyle.paragraphTitleTextStyle),
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
                              return '机构名称不能少于2个字符';
                            }
                            return null;
                          }),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.back();
                            depotController.user.updateAgencyName();
                            
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
