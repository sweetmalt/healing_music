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
              title: Text(
                "顾客昵称",
                style: TextStyle(
                  fontSize: 20,
                  color: ThemeData().colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(controller._report['nickname']),
            ),
            ListTile(
              title: Text(
                "生成时间",
                style: TextStyle(
                  fontSize: 20,
                  color: ThemeData().colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(_formatTimestamp(controller._report['timestamp'])),
            ),

            ///数据统计
            ListTile(
              title: Text(
                "bciAtt 专注度",
                style: TextStyle(
                  fontSize: 16,
                  color: ThemeData().colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text("样本量(${controller.bciAtt["count"]}) "),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                Text("平均值(${controller.bciAtt["mv"]}) "),
                Text("标准差(${controller.bciAtt["sdnn"]}) "),
                Text("均方根(${controller.bciAtt["rmssd"]}) "),
              ]),
            ),

            ///
            ListTile(
              title: Text(
                "bciMed 安全感",
                style: TextStyle(
                  fontSize: 16,
                  color: ThemeData().colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text("样本量(${controller.bciMed["count"]}) "),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                Text("平均值(${controller.bciMed["mv"]}) "),
                Text("标准差(${controller.bciMed["sdnn"]}) "),
                Text("均方根(${controller.bciMed["rmssd"]}) "),
              ]),
            ),

            ///
            ListTile(
              title: Text(
                "bciDelta",
                style: TextStyle(
                  fontSize: 16,
                  color: ThemeData().colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text("样本量(${controller.bciDelta["count"]}) "),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                Text("平均值(${controller.bciDelta["mv"]}) "),
                Text("标准差(${controller.bciDelta["sdnn"]}) "),
                Text("均方根(${controller.bciDelta["rmssd"]}) "),
              ]),
            ),

            ///
            ListTile(
              title: Text(
                "bciTheta",
                style: TextStyle(
                  fontSize: 16,
                  color: ThemeData().colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text("样本量(${controller.bciTheta["count"]}) "),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                Text("平均值(${controller.bciTheta["mv"]}) "),
                Text("标准差(${controller.bciTheta["sdnn"]}) "),
                Text("均方根(${controller.bciTheta["rmssd"]}) "),
              ]),
            ),

            ///
            ListTile(
              title: Text(
                "bciLowAlpha",
                style: TextStyle(
                  fontSize: 16,
                  color: ThemeData().colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text("样本量(${controller.bciLowAlpha["count"]}) "),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                Text("平均值(${controller.bciLowAlpha["mv"]}) "),
                Text("标准差(${controller.bciLowAlpha["sdnn"]}) "),
                Text("均方根(${controller.bciLowAlpha["rmssd"]}) "),
              ]),
            ),

            ///
            ListTile(
              title: Text(
                "bciHighAlpha",
                style: TextStyle(
                  fontSize: 16,
                  color: ThemeData().colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text("样本量(${controller.bciHighAlpha["count"]}) "),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                Text("平均值(${controller.bciHighAlpha["mv"]}) "),
                Text("标准差(${controller.bciHighAlpha["sdnn"]}) "),
                Text("均方根(${controller.bciHighAlpha["rmssd"]}) "),
              ]),
            ),

            ///
            ListTile(
              title: Text(
                "bciLowBeta",
                style: TextStyle(
                  fontSize: 16,
                  color: ThemeData().colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text("样本量(${controller.bciLowBeta["count"]}) "),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                Text("平均值(${controller.bciLowBeta["mv"]}) "),
                Text("标准差(${controller.bciLowBeta["sdnn"]}) "),
                Text("均方根(${controller.bciLowBeta["rmssd"]}) "),
              ]),
            ),

            ///
            ListTile(
              title: Text(
                "bciHighBeta",
                style: TextStyle(
                  fontSize: 16,
                  color: ThemeData().colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text("样本量(${controller.bciHighBeta["count"]}) "),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                Text("平均值(${controller.bciHighBeta["mv"]}) "),
                Text("标准差(${controller.bciHighBeta["sdnn"]}) "),
                Text("均方根(${controller.bciHighBeta["rmssd"]}) "),
              ]),
            ),

            ///
            ListTile(
              title: Text(
                "bciLowGamma",
                style: TextStyle(
                  fontSize: 16,
                  color: ThemeData().colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text("样本量(${controller.bciLowGamma["count"]}) "),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                Text("平均值(${controller.bciLowGamma["mv"]}) "),
                Text("标准差(${controller.bciLowGamma["sdnn"]}) "),
                Text("均方根(${controller.bciLowGamma["rmssd"]}) "),
              ]),
            ),

            ///
            ListTile(
              title: Text(
                "bciMiddleGamma",
                style: TextStyle(
                  fontSize: 16,
                  color: ThemeData().colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text("样本量(${controller.bciMiddleGamma["count"]}) "),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                Text("平均值(${controller.bciMiddleGamma["mv"]}) "),
                Text("标准差(${controller.bciMiddleGamma["sdnn"]}) "),
                Text("均方根(${controller.bciMiddleGamma["rmssd"]}) "),
              ]),
            ),

            ///
            ListTile(
              title: Text(
                "bciTemperature 额温",
                style: TextStyle(
                  fontSize: 16,
                  color: ThemeData().colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text("样本量(${controller.bciTemperature["count"]}) "),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                Text("平均值(${controller.bciTemperature["mv"]}) "),
                Text("标准差(${controller.bciTemperature["sdnn"]}) "),
                Text("均方根(${controller.bciTemperature["rmssd"]}) "),
              ]),
            ),

            ///
            ListTile(
              title: Text(
                "bciHeartRate 心率",
                style: TextStyle(
                  fontSize: 16,
                  color: ThemeData().colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text("样本量(${controller.bciHeartRate["count"]}) "),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                Text("平均值(${controller.bciHeartRate["mv"]}) "),
                Text("标准差(${controller.bciHeartRate["sdnn"]}) "),
                Text("均方根(${controller.bciHeartRate["rmssd"]}) "),
              ]),
            ),

            ///
            ListTile(
              title: Text(
                "hrvRR 心率变异性",
                style: TextStyle(
                  fontSize: 16,
                  color: ThemeData().colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text("样本量(${controller.hrvRR["count"]}) "),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                Text("平均值(${controller.hrvRR["mv"]}) "),
                Text("标准差(${controller.hrvRR["sdnn"]}) "),
                Text("均方根(${controller.hrvRR["rmssd"]}) "),
                Text("邻差50(${controller.hrvRR["nn50"]}) "),
                Text("LF/HF(${controller.hrvRR["lfhf"]}) "),
              ]),
            ),

/**
            ///原始数据
            ListTile(
              title: Text(
                "心理能量原始数据",
                style: TextStyle(
                  fontSize: 20,
                  color: ThemeData().colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle:
                  Text("脑电波bci数据集(${controller._report['bciData'].length})"),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 1; i < controller._report['bciData'].length; i++)
                  Text(
                    "$i: ${controller._report['bciData'][i]}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: ThemeData().colorScheme.primary,
                    ),
                  ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              alignment: Alignment.center,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, // 每行显示元素
                  childAspectRatio: 3, // 子元素宽高比
                ),
                itemCount: controller._report['bciDataDelta'].length,
                itemBuilder: (context, index) {
                  return Text(
                    textAlign: TextAlign.center,
                    "${controller._report['bciDataDelta'][index]}",
                    style: TextStyle(
                      fontSize: 12,
                      color: ThemeData().colorScheme.primary,
                    ),
                  );
                },
              ),
            ),
            ListTile(
              title: Text(
                "生理能量原始数据",
                style: TextStyle(
                  fontSize: 20,
                  color: ThemeData().colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle:
                  Text("心率变异性hrv数据集(${controller._report['hrvData'].length})"),
            ),
            //网格布局显示数组数据
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              alignment: Alignment.center,
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, // 每行显示元素
                  childAspectRatio: 3, // 子元素宽高比
                ),
                itemCount: controller._report['hrvData'].length,
                itemBuilder: (context, index) {
                  return Text(
                    textAlign: TextAlign.center,
                    "${controller._report['hrvData'][index]}",
                    style: TextStyle(
                      fontSize: 12,
                      color: ThemeData().colorScheme.primary,
                    ),
                  );
                },
              ),
            ),
 */
            ListTile(
              title: Text(
                "数据文件",
                style: TextStyle(
                  fontSize: 20,
                  color: ThemeData().colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(controller._report['fileName']),
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

    ///bci数据
    "bciData": [],
    "bciDataAtt": [],
    "bciDataMed": [],
    "bciDataDelta": [],
    "bciDataTheta": [],
    "bciDataLowAlpha": [],
    "bciDataHighAlpha": [],
    "bciDataLowBeta": [],
    "bciDataHighBeta": [],
    "bciDataLowGamma": [],
    "bciDataMiddleGamma": [],
    "bciDataTemperature": [],
    "bciDataHeartRate": [],
    "bciDataGrind": [],

    ///hrv数据
    "hrvData": [],
    "fileName": "文件名",
  };

  String get fileName => _fileName;
  Map<String, dynamic> bciAtt = {};
  Map<String, dynamic> bciMed = {};
  Map<String, dynamic> bciDelta = {};
  Map<String, dynamic> bciTheta = {};
  Map<String, dynamic> bciLowAlpha = {};
  Map<String, dynamic> bciHighAlpha = {};
  Map<String, dynamic> bciLowBeta = {};
  Map<String, dynamic> bciHighBeta = {};
  Map<String, dynamic> bciLowGamma = {};
  Map<String, dynamic> bciMiddleGamma = {};
  Map<String, dynamic> bciTemperature = {};
  Map<String, dynamic> bciHeartRate = {
    "count": 0, // 样本量
    "mv": 0.0, // 平均值
    "sdnn": 0.0, // 标准差SDNN
    "rmssd": 0.0, // 均方根RMSSD
  };
  Map<String, dynamic> hrvRR = {
    "count": 0, // 心率变异性 hrvRR间期值 样本量
    "mv": 0.0, // 心率变异性 hrvRR间期值 平均值
    "sdnn": 0.0, // 心率变异性 hrvRR间期值 标准差SDNN
    "rmssd": 0.0, // 心率变异性 hrvRR间期值 均方根RMSSD
    "nn50": 0.0, // 心率变异性 hrvRR间期值 邻差数据点百分比PNN50
    "lfhf": 0.0 // 心率变异性 hrvRR间期值 LF/HF 比值
  };

  Future<void> getReport(String fileName) async {
    _fileName = fileName;
    _report['fileName'] = fileName;

    Map<String, dynamic> report = await Data.read(fileName);
    _report['nickname'] = report['nickname'];
    _report['timestamp'] = report['timestamp'];

    ///bci数据（文本）
    _report['bciData'] = report['bciData'];

    ///bci数据（数值）
    _report['bciDataAtt'] = report['bciDataAtt'];
    _report['bciDataMed'] = report['bciDataMed'];
    _report['bciDataDelta'] = report['bciDataDelta'];
    _report['bciDataTheta'] = report['bciDataTheta'];
    _report['bciDataLowAlpha'] = report['bciDataLowAlpha'];
    _report['bciDataHighAlpha'] = report['bciDataHighAlpha'];
    _report['bciDataLowBeta'] = report['bciDataLowBeta'];
    _report['bciDataHighBeta'] = report['bciDataHighBeta'];
    _report['bciDataLowGamma'] = report['bciDataLowGamma'];
    _report['bciDataMiddleGamma'] = report['bciDataMiddleGamma'];
    _report['bciDataTemperature'] = report['bciDataTemperature'];
    _report['bciDataHeartRate'] = report['bciDataHeartRate'];

    ///hrv数据（数值）
    _report['hrvData'] = report['hrvData'];

    ///数据分析
    bciAtt["count"] = _report['bciDataAtt'].length;
    bciAtt["mv"] = Data.calculate(_report['bciDataAtt'])[0];
    bciAtt["sdnn"] = Data.calculate(_report['bciDataAtt'])[1];
    bciAtt["rmssd"] = Data.calculate(_report['bciDataAtt'])[2];

    ///
    bciMed["count"] = _report['bciDataMed'].length;
    bciMed["mv"] = Data.calculate(_report['bciDataMed'])[0];
    bciMed["sdnn"] = Data.calculate(_report['bciDataMed'])[1];
    bciMed["rmssd"] = Data.calculate(_report['bciDataMed'])[2];

    ///
    bciDelta["count"] = _report['bciDataDelta'].length;
    bciDelta["mv"] = Data.calculate(_report['bciDataDelta'])[0];
    bciDelta["sdnn"] = Data.calculate(_report['bciDataDelta'])[1];
    bciDelta["rmssd"] = Data.calculate(_report['bciDataDelta'])[2];

    ///
    bciTheta["count"] = _report['bciDataTheta'].length;
    bciTheta["mv"] = Data.calculate(_report['bciDataTheta'])[0];
    bciTheta["sdnn"] = Data.calculate(_report['bciDataTheta'])[1];
    bciTheta["rmssd"] = Data.calculate(_report['bciDataTheta'])[2];

    ///
    bciLowAlpha["count"] = _report['bciDataLowAlpha'].length;
    bciLowAlpha["mv"] = Data.calculate(_report['bciDataLowAlpha'])[0];
    bciLowAlpha["sdnn"] = Data.calculate(_report['bciDataLowAlpha'])[1];
    bciLowAlpha["rmssd"] = Data.calculate(_report['bciDataLowAlpha'])[2];

    ///
    bciHighAlpha["count"] = _report['bciDataHighAlpha'].length;
    bciHighAlpha["mv"] = Data.calculate(_report['bciDataHighAlpha'])[0];
    bciHighAlpha["sdnn"] = Data.calculate(_report['bciDataHighAlpha'])[1];
    bciHighAlpha["rmssd"] = Data.calculate(_report['bciDataHighAlpha'])[2];

    ///
    bciLowBeta["count"] = _report['bciDataLowBeta'].length;
    bciLowBeta["mv"] = Data.calculate(_report['bciDataLowBeta'])[0];
    bciLowBeta["sdnn"] = Data.calculate(_report['bciDataLowBeta'])[1];
    bciLowBeta["rmssd"] = Data.calculate(_report['bciDataLowBeta'])[2];

    ///
    bciHighBeta["count"] = _report['bciDataHighBeta'].length;
    bciHighBeta["mv"] = Data.calculate(_report['bciDataHighBeta'])[0];
    bciHighBeta["sdnn"] = Data.calculate(_report['bciDataHighBeta'])[1];
    bciHighBeta["rmssd"] = Data.calculate(_report['bciDataHighBeta'])[2];

    ///
    bciLowGamma["count"] = _report['bciDataLowGamma'].length;
    bciLowGamma["mv"] = Data.calculate(_report['bciDataLowGamma'])[0];
    bciLowGamma["sdnn"] = Data.calculate(_report['bciDataLowGamma'])[1];
    bciLowGamma["rmssd"] = Data.calculate(_report['bciDataLowGamma'])[2];

    ///
    bciMiddleGamma["count"] = _report['bciDataMiddleGamma'].length;
    bciMiddleGamma["mv"] = Data.calculate(_report['bciDataMiddleGamma'])[0];
    bciMiddleGamma["sdnn"] = Data.calculate(_report['bciDataMiddleGamma'])[1];
    bciMiddleGamma["rmssd"] = Data.calculate(_report['bciDataMiddleGamma'])[2];

    ///
    bciTemperature["count"] = _report['bciDataTemperature'].length;
    bciTemperature["mv"] = Data.calculate(_report['bciDataTemperature'])[0];
    bciTemperature["sdnn"] = Data.calculate(_report['bciDataTemperature'])[1];
    bciTemperature["rmssd"] = Data.calculate(_report['bciDataTemperature'])[2];

    ///
    bciHeartRate["count"] = _report['bciDataHeartRate'].length;
    bciHeartRate["mv"] = Data.calculate(_report['bciDataHeartRate'])[0];
    bciHeartRate["sdnn"] = Data.calculate(_report['bciDataHeartRate'])[1];
    bciHeartRate["rmssd"] = Data.calculate(_report['bciDataHeartRate'])[2];

    hrvRR["count"] = _report['hrvData'].length;
    if (hrvRR["count"] > 10) {
      hrvRR["mv"] = Data.calculate(_report['hrvData'])[0];
      hrvRR["sdnn"] = Data.calculate(_report['hrvData'])[1];
      hrvRR["rmssd"] = Data.calculate(_report['hrvData'])[2];

      ///邻差>50的数据点占比
      double sum = 0.0;
      for (int i = 1; i < hrvRR["count"]; i++) {
        if (_report['hrvData'][i] - _report['hrvData'][i - 1] > 50 ||
            _report['hrvData'][i] - _report['hrvData'][i - 1] < -50) {
          sum++;
        }
      }
      double nn50 = sum / (hrvRR["count"] - 1);
      nn50 = (nn50 * 100).toInt() / 100;
      hrvRR["nn50"] = nn50;

      ///频域分析 LF/HF 比值
      List<double> p = Data.calculateLFHF(report['hrvData']);
      hrvRR["lfhf"] = p[3];
    }
  }
}
