import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healing_music/controller/ctrl.dart';
import 'package:healing_music/data/data.dart';

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
          title: Text(
            controller.title,
            style: TextStyle(
              fontSize: 20,
              color: ThemeData().colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            // IconButton(
            //   icon: const Icon(
            //     Icons.delete,
            //     size: 30,
            //   ),
            //   onPressed: () {},
            // ),
            // IconButton(
            //   icon: const Icon(
            //     Icons.select_all,
            //     size: 30,
            //   ),
            //   onPressed: () {},
            // ),
            IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                size: 30,
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Obx(() => Column(
                  children: [
                    for (int i = 0; i < controller.reportFileList.length; i++)
                      ListTile(
                        title: Text(
                          controller.reportFileList[i].split('_')[1],
                          style: TextStyle(
                            fontSize: 20,
                            color: ThemeData().colorScheme.primary,
                          ),
                        ),
                        subtitle: Text(controller.reportFileList[i]
                            .split('_')[2]
                            .split('.')[0]),
                        leading: Icon(
                          Icons.receipt_long_rounded,
                          color: ThemeData().colorScheme.primary,
                          size: 30,
                        ),
                        onTap: () {
                          reportPageController
                              .getReport(controller.reportFileList[i])
                              .then((_) => Get.to(() => ReportPage()));
                        },
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            color: ThemeData().colorScheme.primary,
                            size: 30,
                          ),
                          onPressed: () async {
                            if (await Data.delete(
                                '${controller.reportFileList[i]}')) {
                              await controller.getReportFileList();
                            }
                          },
                        ),
                      ),
                  ],
                ))));
  }
}

class ReportListController extends Ctrl {
  final String title = '能量报告 文件夹';
  final RxList reportFileList = [].obs;

  @override
  void onInit() async {
    super.onInit();
    await getReportFileList();
  }

  Future<void> getReportFileList() async {
    reportFileList.clear();
    reportFileList.value = await Data.readFileList('report');
  }
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
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            ListTile(
              title: const Text("顾客昵称"),
              subtitle: Text(controller._report['nickname']),
            ),
            ListTile(
              title: const Text("时间"),
              subtitle: Text(_formatTimestamp(controller._report['timestamp'])),
            ),
            ListTile(
              title: const Text("心理能量"),
              subtitle: Text("数据集(${controller._report['data'].length})"),
            ),
            Column(
              children: [
                for (int i = 1; i < controller._report['data'].length; i++)
                  ListTile(
                    title: Text(
                      "$i: ${controller._report['data'][i]}",
                      style: TextStyle(
                        fontSize: 12,
                        color: ThemeData().colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            ),
            const ListTile(
              title: Text("生理能量"),
              subtitle: Text("hrv数据集(0)"),
            ),
            ListTile(
              title: Text(controller._report['fileName']),
            ),
          ],
        )));
  }

  String _formatTimestamp(String timestamp) {
    if (timestamp.isEmpty) return '';

    int milliseconds = int.tryParse(timestamp) ?? 0;
    if (milliseconds == 0) return timestamp; // 如果解析失败，返回原始字符串

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return '${dateTime.year}年${dateTime.month.toString().padLeft(2, '0')}月${dateTime.day.toString().padLeft(2, '0')}日 '
        '${dateTime.hour.toString().padLeft(2, '0')}点${dateTime.minute.toString().padLeft(2, '0')}分${dateTime.second.toString().padLeft(2, '0')}秒${dateTime.millisecond.toString().padLeft(3, '0')}毫秒';
  }
}

class ReporPageController extends Ctrl {
  final String title = '能量报告 详情';
  String _fileName = '';
  final Map<String, dynamic> _report = {
    "nickname": "顾客昵称",
    "timestamp": "时间",
    "data": [],
    "hrvData": [],
    "fileName": "文件名",
  };
  String get fileName => _fileName;

  Future<void> getReport(String fileName) async {
    _fileName = fileName;
    _report['fileName'] = fileName;
    Data data = Data(jsonFileName: fileName);
    Map<String, dynamic> report = await data.read();
    _report['nickname'] = report['nickname'];
    _report['timestamp'] = report['timestamp'];
    _report['data'] = report['data'];
    _report['hrvData'] = report['hrvData'];
  }
}
