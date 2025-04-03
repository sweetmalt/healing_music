import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healing_music/controller/ctrl.dart';

class ReportList extends GetView<ReportListController> {
  ReportList({super.key});
  @override
  final ReportListController controller = Get.put(ReportListController());
  final ReporPageController reportPageController =
      Get.put(ReporPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(controller.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.select_all),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            for (int i = 0; i < controller.items.length; i++)
              ListTile(
                title: Text(controller.items[i]),
                subtitle: Text(controller.datas[controller.items[i]]!),
                leading: Checkbox(
                  value: false,
                  onChanged: (bool? value) {},
                ),
                onTap: () {
                  reportPageController.title = controller.items[i];
                  reportPageController.data =
                      controller.datas[controller.items[i]]!;
                  Get.to(() => ReportPage());
                },
                trailing: const Icon(Icons.menu_book_rounded),
              ),
          ],
        )));
  }
}

class ReportListController extends Ctrl {
  final String title = 'Report List';
  final List<String> items = [
    "Report 1",
    "Report 2",
    "Report 3",
  ];
  final Map<String, String> datas = {
    "Report 1": "Report 1 doc",
    "Report 2": "Report 2 doc",
    "Report 3": "Report 3 doc",
  };
}

///

class ReportPage extends GetView<ReporPageController> {
  ReportPage({super.key});
  @override
  final ReporPageController controller = Get.put(ReporPageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(controller.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            ListTile(
              title: Text(controller.data),
              onTap: () {},
            ),
          ],
        )));
  }
}

class ReporPageController extends Ctrl {
  String title = 'Report';
  String data = 'Report doc';
}
