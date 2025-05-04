import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healing_music/data/data.dart';
import 'package:healing_music/widget/ai_view.dart';
import 'package:healing_music/widget/brain_wave_view.dart';
import 'package:healing_music/widget/wave_chart.dart';
import 'package:screenshot/screenshot.dart';
//import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

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

class ReportListController extends GetxController {
  final String title = 'AI脑机检测报告 文件夹';
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

  final ScreenshotController screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(controller.title),
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: () async {
                await _shareReport();
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        ),
        body: Screenshot(
            controller: screenshotController,
            child: SingleChildScrollView(
                child: Column(
              children: [
                ListTile(
                  title: Text(
                    "报告时间",
                    style: TextStyle(
                      fontSize: 16,
                      color: ThemeData().colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(controller
                      .formatTimestamp(controller._report['timestamp'])),
                ),
                ListTile(
                  title: Text(
                    "监测时长：${controller.bciAp["count"]}秒",
                    style: TextStyle(
                      fontSize: 16,
                      color: ThemeData().colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text("count"),
                ),
                ListTile(
                  title: Text(
                    "顾客昵称：${controller.report['nickname']}",
                    style: TextStyle(
                      fontSize: 16,
                      color: ThemeData().colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text("nickname"),
                ),
                ListTile(
                  title: Text(
                    "顾客年龄：${controller._report['age']}岁",
                    style: TextStyle(
                      fontSize: 16,
                      color: ThemeData().colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text("age"),
                ),
                ListTile(
                  title: Text(
                    controller._report['sex'] == 0 ? "顾客性别：男" : "顾客性别：女",
                    style: TextStyle(
                      fontSize: 16,
                      color: ThemeData().colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text("sex"),
                ),
                const ListTile(
                  title: Text(
                      "感谢您选择先进的AI脑机-能量检测服务！\n以下是您本次的能量检测报告，我们将通过您的脑电和HRV等生理指标评估您当前的“心理能量“和“生理能量“的表现，帮助您更好地了解自己的身心状态。\n专业人员可藉由AI大模型的分析和建议为您制定个性化的服务方案，祝您健康幸福。"),
                ),
                ListTile(
                  title: Text(
                    "总能量得分：",
                    style: TextStyle(
                      fontSize: 16,
                      color: ThemeData().colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text("其中，\n心理能量得分：\n生理能量得分："),
                ),
                const ListTile(
                  title:
                      Text("能量积分：__相比上次测试，您本次总得分增加__分，奖励积分__，请再接再厉，保持健康好心情！"),
                ),

                ///AI内容区
                AiTextView(
                  controller,
                ),

                ///数据统计
                StatisticsContainerCircleMini(
                  "愉悦感",
                  controller.bciAp["mv"] / 5,
                  true,
                ),
                ListTile(
                  title: Text(
                    "bciAp 愉悦感",
                    style: TextStyle(
                      fontSize: 16,
                      color: ThemeData().colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(Data.dataDoc["bciAp"]!["long"]!),
                ),
                BciSlider(
                  title:
                      "愉悦感（${controller.getAttr(controller.bciAp["mv"], 100)}）",
                  color: ThemeData().colorScheme.primary,
                  maxValue: 5,
                  value: controller.bciAp["mv"],
                ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(children: [
                //     Text("平均值(${controller.bciAp["mv"]}) "),
                //     Text("标准差(${controller.bciAp["sdnn"]}) "),
                //     Text("均方根(${controller.bciAp["rmssd"]}) "),
                //   ]),
                // ),
                // Container(
                //   alignment: Alignment.center,
                //   transformAlignment: Alignment.center,
                //   margin: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
                //   padding: const EdgeInsets.all(10),
                //   decoration: BoxDecoration(
                //       color: ThemeData().colorScheme.surface,
                //       borderRadius: BorderRadius.circular(10),
                //       border: Border.all(
                //         color: ThemeData().colorScheme.primaryContainer,
                //         width: 3,
                //       )),
                //   child: const Text(
                //     "SPA可用于提升愉悦感",
                //     style: TextStyle(
                //         color: Colors.purple, fontWeight: FontWeight.bold),
                //   ),
                // ),

                ///
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      StatisticsContainerCircleMini(
                        "松弛感",
                        controller.curRelax["mv"] / 100,
                        true,
                      ),
                      StatisticsContainerCircleMini(
                        "心流指数",
                        controller.curFlow["mv"] / 100,
                        true,
                      ),
                    ]),
                ListTile(
                  title: Text(
                    "curRelax 松弛感",
                    style: TextStyle(
                      fontSize: 16,
                      color: ThemeData().colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(Data.dataDoc["curRelax"]!["long"]!),
                ),
                BciSlider(
                  title:
                      "松弛感（${controller.getAttr(controller.curRelax["mv"], 100)}）",
                  color: ThemeData().colorScheme.primary,
                  maxValue: 100,
                  value: controller.curRelax["mv"],
                ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(children: [
                //     Text("平均值(${controller.curRelax["mv"]}) "),
                //     Text("标准差(${controller.curRelax["sdnn"]}) "),
                //     Text("均方根(${controller.curRelax["rmssd"]}) "),
                //   ]),
                // ),
                // Container(
                //   alignment: Alignment.center,
                //   transformAlignment: Alignment.center,
                //   margin: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
                //   padding: const EdgeInsets.all(10),
                //   decoration: BoxDecoration(
                //       color: ThemeData().colorScheme.surface,
                //       borderRadius: BorderRadius.circular(10),
                //       border: Border.all(
                //         color: ThemeData().colorScheme.primaryContainer,
                //         width: 3,
                //       )),
                //   child: const Text(
                //     "香疗可用于提升松弛感",
                //     style: TextStyle(
                //         color: Colors.purple, fontWeight: FontWeight.bold),
                //   ),
                // ),

                ///
                ListTile(
                  title: Text(
                    "curFlow 心流指数",
                    style: TextStyle(
                      fontSize: 16,
                      color: ThemeData().colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(Data.dataDoc["curFlow"]!["long"]!),
                ),
                BciSlider(
                  title:
                      "心流指数（${controller.getAttr(controller.curFlow["mv"], 100)}）",
                  color: ThemeData().colorScheme.primary,
                  maxValue: 100,
                  value: controller.curFlow["mv"],
                ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(children: [
                //     Text("平均值(${controller.curFlow["mv"]}) "),
                //     Text("标准差(${controller.curFlow["sdnn"]}) "),
                //     Text("均方根(${controller.curFlow["rmssd"]}) "),
                //   ]),
                // ),
                // Container(
                //   alignment: Alignment.center,
                //   transformAlignment: Alignment.center,
                //   margin: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
                //   padding: const EdgeInsets.all(10),
                //   height: 80,
                //   decoration: BoxDecoration(
                //       color: ThemeData().colorScheme.surface,
                //       borderRadius: BorderRadius.circular(10),
                //       border: Border.all(
                //         color: ThemeData().colorScheme.primaryContainer,
                //         width: 3,
                //       )),
                //   child: const Text(
                //     "茶疗+脑波音频可用于提升心流指数",
                //     style: TextStyle(
                //         color: Colors.purple, fontWeight: FontWeight.bold),
                //   ),
                // ),

                ///
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      StatisticsContainerCircleMini(
                        "专注度",
                        controller.bciAtt["mv"] / 100,
                        true,
                      ),
                      StatisticsContainerCircleMini(
                        "安全感",
                        controller.bciMed["mv"] / 100,
                        true,
                      ),
                    ]),
                ListTile(
                  title: Text(
                    "bciAtt 专注度",
                    style: TextStyle(
                      fontSize: 16,
                      color: ThemeData().colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(Data.dataDoc["bciAtt"]!["long"]!),
                ),
                BciSlider(
                  title:
                      "专注度（${controller.getAttr(controller.bciAtt["mv"], 100)}）",
                  color: ThemeData().colorScheme.primary,
                  maxValue: 100,
                  value: controller.bciAtt["mv"],
                ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(children: [
                //     Text("平均值(${controller.bciAtt["mv"]}) "),
                //     Text("标准差(${controller.bciAtt["sdnn"]}) "),
                //     Text("均方根(${controller.bciAtt["rmssd"]}) "),
                //   ]),
                // ),
                // Container(
                //   alignment: Alignment.center,
                //   transformAlignment: Alignment.center,
                //   margin: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
                //   padding: const EdgeInsets.all(10),
                //   decoration: BoxDecoration(
                //       color: ThemeData().colorScheme.surface,
                //       borderRadius: BorderRadius.circular(10),
                //       border: Border.all(
                //         color: ThemeData().colorScheme.primaryContainer,
                //         width: 3,
                //       )),
                //   child: const Text(
                //     "音疗中的双耳节拍音频可用于训练专注度",
                //     style: TextStyle(
                //         color: Colors.purple, fontWeight: FontWeight.bold),
                //   ),
                // ),

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
                  subtitle: Text(Data.dataDoc["bciMed"]!["long"]!),
                ),
                BciSlider(
                  title:
                      "安全感（${controller.getAttr(controller.bciMed["mv"], 100)}）",
                  color: ThemeData().colorScheme.primary,
                  maxValue: 100,
                  value: controller.bciMed["mv"],
                ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(children: [
                //     Text("平均值(${controller.bciMed["mv"]}) "),
                //     Text("标准差(${controller.bciMed["sdnn"]}) "),
                //     Text("均方根(${controller.bciMed["rmssd"]}) "),
                //   ]),
                // ),
                // Container(
                //   alignment: Alignment.center,
                //   transformAlignment: Alignment.center,
                //   margin: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
                //   padding: const EdgeInsets.all(10),
                //   decoration: BoxDecoration(
                //       color: ThemeData().colorScheme.surface,
                //       borderRadius: BorderRadius.circular(10),
                //       border: Border.all(
                //         color: ThemeData().colorScheme.primaryContainer,
                //         width: 3,
                //       )),
                //   child: const Text(
                //     "光疗+自然生境音频（如鸟鸣）可用于提升安全感",
                //     style: TextStyle(
                //         color: Colors.purple, fontWeight: FontWeight.bold),
                //   ),
                // ),
                ListTile(
                  title: Text(
                    "hrvRR心率变异性 (${controller.hrvRR["count"]}条数据)",
                    style: TextStyle(
                      fontSize: 16,
                      color: ThemeData().colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(Data.dataDoc["bciHrv"]!["long"]!),
                ),
                BciSlider(
                  title:
                      "心率变异性NN50（${controller.getAttr(controller.hrvRR["nn50"], 1)}）",
                  color: Colors.purple,
                  maxValue: 1,
                  value: controller.hrvRR["nn50"],
                ),
                BciSlider(
                  title:
                      "交感副交感平衡LF/HF（${controller.getAttr(controller.hrvRR["lfhf"] / 5, 1)}）",
                  color: Colors.purple,
                  maxValue: 1,
                  value: controller.hrvRR["lfhf"] / 5,
                ),

                ///
                ListTile(
                  title: Text(
                    "AI脑机检测基础指标",
                    style: TextStyle(
                      fontSize: 16,
                      color: ThemeData().colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text("脑波、心率、额温等"),
                ),
                ListTile(
                  title: Text(
                    "bciDelta",
                    style: TextStyle(
                      fontSize: 16,
                      color: ThemeData().colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: BciSlider(
                    title: "δ波",
                    color: ThemeData().colorScheme.secondary,
                    maxValue: 100000,
                    value: controller.bciDelta["mv"],
                  ),
                ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(children: [
                //     Text("平均值(${controller.bciDelta["mv"]}) "),
                //     Text("标准差(${controller.bciDelta["sdnn"]}) "),
                //     Text("均方根(${controller.bciDelta["rmssd"]}) "),
                //   ]),
                // ),

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
                  subtitle: BciSlider(
                    title: "θ波",
                    color: ThemeData().colorScheme.secondary,
                    maxValue: 100000,
                    value: controller.bciTheta["mv"],
                  ),
                ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(children: [
                //     Text("平均值(${controller.bciTheta["mv"]}) "),
                //     Text("标准差(${controller.bciTheta["sdnn"]}) "),
                //     Text("均方根(${controller.bciTheta["rmssd"]}) "),
                //   ]),
                // ),

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
                  subtitle: BciSlider(
                    title: "低α",
                    color: ThemeData().colorScheme.secondary,
                    maxValue: 100000,
                    value: controller.bciLowAlpha["mv"],
                  ),
                ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(children: [
                //     Text("平均值(${controller.bciLowAlpha["mv"]}) "),
                //     Text("标准差(${controller.bciLowAlpha["sdnn"]}) "),
                //     Text("均方根(${controller.bciLowAlpha["rmssd"]}) "),
                //   ]),
                // ),

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
                  subtitle: BciSlider(
                    title: "高α",
                    color: ThemeData().colorScheme.secondary,
                    maxValue: 100000,
                    value: controller.bciHighAlpha["mv"],
                  ),
                ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(children: [
                //     Text("平均值(${controller.bciHighAlpha["mv"]}) "),
                //     Text("标准差(${controller.bciHighAlpha["sdnn"]}) "),
                //     Text("均方根(${controller.bciHighAlpha["rmssd"]}) "),
                //   ]),
                // ),

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
                  subtitle: BciSlider(
                    title: "低β",
                    color: ThemeData().colorScheme.secondary,
                    maxValue: 100000,
                    value: controller.bciLowBeta["mv"],
                  ),
                ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(children: [
                //     Text("平均值(${controller.bciLowBeta["mv"]}) "),
                //     Text("标准差(${controller.bciLowBeta["sdnn"]}) "),
                //     Text("均方根(${controller.bciLowBeta["rmssd"]}) "),
                //   ]),
                // ),

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
                  subtitle: BciSlider(
                    title: "高β",
                    color: ThemeData().colorScheme.secondary,
                    maxValue: 100000,
                    value: controller.bciHighBeta["mv"],
                  ),
                ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(children: [
                //     Text("平均值(${controller.bciHighBeta["mv"]}) "),
                //     Text("标准差(${controller.bciHighBeta["sdnn"]}) "),
                //     Text("均方根(${controller.bciHighBeta["rmssd"]}) "),
                //   ]),
                // ),

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
                  subtitle: BciSlider(
                    title: "低γ",
                    color: ThemeData().colorScheme.secondary,
                    maxValue: 100000,
                    value: controller.bciLowGamma["mv"],
                  ),
                ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(children: [
                //     Text("平均值(${controller.bciLowGamma["mv"]}) "),
                //     Text("标准差(${controller.bciLowGamma["sdnn"]}) "),
                //     Text("均方根(${controller.bciLowGamma["rmssd"]}) "),
                //   ]),
                // ),

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
                  subtitle: BciSlider(
                    title: "中γ",
                    color: ThemeData().colorScheme.secondary,
                    maxValue: 100000,
                    value: controller.bciMiddleGamma["mv"],
                  ),
                ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(children: [
                //     Text("平均值(${controller.bciMiddleGamma["mv"]}) "),
                //     Text("标准差(${controller.bciMiddleGamma["sdnn"]}) "),
                //     Text("均方根(${controller.bciMiddleGamma["rmssd"]}) "),
                //   ]),
                // ),

                ///
                ListTile(
                  title: Text(
                    "bciTemperature",
                    style: TextStyle(
                      fontSize: 16,
                      color: ThemeData().colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text("额温(${controller.bciTemperature["mv"]}摄氏度)"),
                ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(children: [
                //     Text("平均值(${controller.bciTemperature["mv"]}) "),
                //     Text("标准差(${controller.bciTemperature["sdnn"]}) "),
                //     Text("均方根(${controller.bciTemperature["rmssd"]}) "),
                //   ]),
                // ),

                ///
                ListTile(
                  title: Text(
                    "bciHeartRate",
                    style: TextStyle(
                      fontSize: 16,
                      color: ThemeData().colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: BciSlider(
                    title:
                        "心率（${controller.getAttr(controller.bciHeartRate["mv"], 140)}）",
                    color: Colors.purple,
                    maxValue: 140,
                    value: controller.bciHeartRate["mv"],
                  ),
                ),
                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(children: [
                //     Text("平均值(${controller.bciHeartRate["mv"]}) "),
                //     Text("标准差(${controller.bciHeartRate["sdnn"]}) "),
                //     Text("均方根(${controller.bciHeartRate["rmssd"]}) "),
                //   ]),
                // ),

                ///

                // SingleChildScrollView(
                //   scrollDirection: Axis.horizontal,
                //   child: Row(children: [
                //     Text("平均值(${controller.hrvRR["mv"]}) "),
                //     Text("标准差(${controller.hrvRR["sdnn"]}) "),
                //     Text("均方根(${controller.hrvRR["rmssd"]}) "),
                //     Text("邻差50(${controller.hrvRR["nn50"]}) "),
                //     Text("LF/HF(${controller.hrvRR["lfhf"]}) "),
                //   ]),
                // ),
                // Container(
                //   alignment: Alignment.center,
                //   transformAlignment: Alignment.center,
                //   margin: const EdgeInsets.only(left: 20, right: 20, bottom: 40),
                //   padding: const EdgeInsets.all(10),
                //   decoration: BoxDecoration(
                //       color: ThemeData().colorScheme.surface,
                //       borderRadius: BorderRadius.circular(10),
                //       border: Border.all(
                //         color: ThemeData().colorScheme.primaryContainer,
                //         width: 3,
                //       )),
                //   child: const Column(
                //     children: [
                //       Text(
                //         "nn50值越大，副交感神经的弹性越好",
                //         style: TextStyle(
                //             color: Colors.purple, fontWeight: FontWeight.bold),
                //       ),
                //     ],
                //   ),
                // ),

                ///脑机作画
                AiImageView(
                  controller,
                ),

                ///
                SuggestView(
                  controller,
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
            ))));
  }

  Future<void> _shareReport() async {
    final image = await screenshotController.capture();
    if (image != null) {
      // final pdf = pw.Document();
      // pdf.addPage(pw.Page(build: (pw.Context context) {
      //   return pw.Center(
      //     child: pw.Image(pw.MemoryImage(image)),
      //   );
      // }));

      final directory = await getApplicationDocumentsDirectory();
      final imagePath = '${directory.path}/share.png';
      //final pdfPath = '${directory.path}/share.pdf';

      final imageFile = File(imagePath);
      await imageFile.writeAsBytes(image);

      //final pdfFile = File(pdfPath);
      //await pdfFile.writeAsBytes(await pdf.save());

      await SharePlus.instance.share(ShareParams(
        files: [XFile(imagePath)],
        text: '分享给好友',
      ));
    }
  }
}

class ReporPageController extends GetxController {
  final String title = 'AI脑机检测报告（详情）';
  String _fileName = '';
  String get fileName => _fileName;
  String _aiPrompt = '';
  String get aiPrompt => _aiPrompt;
  RxString aiText = ''.obs;
  RxBool isAiLoading = false.obs;
  RxString aiImageUrl = ''.obs;
  RxBool isAiImageLoading = false.obs;
  RxString aiImageFilePath = ''.obs;
  RxBool isAiImageExists = false.obs;
  RxString aiTextFileName = ''.obs;
  RxBool isAiTextExists = false.obs;
  RxBool isShowSuggest = false.obs;

  Map<String, dynamic> get report => _report;
  final Map<String, dynamic> _report = {
    "nickname": "", //顾客昵称
    "age": 18, // "顾客年龄",
    "sex": 1, //"顾客性别",
    "timestamp": "", //时间戳

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
    "fileName": "", //文件名
  };

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
  Map<String, dynamic> curRelax = {};
  Map<String, dynamic> bciAp = {};
  Map<String, dynamic> curFlow = {};

  Future<void> getReport(String fileName) async {
    _fileName = fileName;
    _report['fileName'] = fileName;
    List<String> lf = fileName.split("_");
    if (lf.length == 3) {
      aiImageUrl.value = "";
      String png = "image_${lf[1]}_${lf[2].split(".")[0]}.png";
      aiImageFilePath.value = await Data.path(png);
      isAiImageExists.value = false;
      if (await Data.exists(png)) {
        isAiImageExists.value = true;
      }
      String txt = "text_${lf[1]}_${lf[2].split(".")[0]}.json";
      aiTextFileName.value = txt;
      isAiTextExists.value = false;
      aiText.value = "";
      if (await Data.exists(txt)) {
        isAiTextExists.value = true;
        Map<String, dynamic> jsonObj = await Data.read(txt);
        aiText.value = jsonObj['aiText'];
      }
    }

    Map<String, dynamic> report = await Data.read(fileName);
    _report['nickname'] = report['nickname'];
    _report['age'] = report['age'];
    _report['sex'] = report['sex'];
    _report['timestamp'] = report['timestamp'];
    _report['uuid'] = report['uuid'];

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
      hrvRR["lfhf"] = p[3] > 5 ? 5 : p[3];
    }

    ///
    curFlow["count"] =
        bciAtt["count"] > bciMed["count"] ? bciMed["count"] : bciAtt["count"];
    curFlow["mv"] = 0.5 * bciAtt["mv"] + 0.5 * bciMed["mv"];
    curFlow["sdnn"] = 0.5 * bciAtt["sdnn"] + 0.5 * bciMed["sdnn"];
    curFlow["rmssd"] = 0.5 * bciAtt["rmssd"] + 0.5 * bciMed["rmssd"];
    curFlow["mv"] = (curFlow["mv"] * 100).toInt() / 100;
    curFlow["sdnn"] = (curFlow["sdnn"] * 100).toInt() / 100;
    curFlow["rmssd"] = (curFlow["rmssd"] * 100).toInt() / 100;

    ///
    curRelax["count"] =
        bciAtt["count"] > bciMed["count"] ? bciMed["count"] : bciAtt["count"];
    curRelax["mv"] = 0.5 * (100 - bciAtt["mv"]) + 0.5 * bciMed["mv"];
    curRelax["sdnn"] = 0.5 * bciAtt["sdnn"] + 0.5 * bciMed["sdnn"];
    curRelax["rmssd"] = 0.5 * bciAtt["rmssd"] + 0.5 * bciMed["rmssd"];
    curRelax["mv"] = (curRelax["mv"] * 100).toInt() / 100;
    curRelax["sdnn"] = (curRelax["sdnn"] * 100).toInt() / 100;
    curRelax["rmssd"] = (curRelax["rmssd"] * 100).toInt() / 100;

    ///
    bciAp["count"] = bciTheta["count"] > bciHighBeta["count"]
        ? bciHighBeta["count"]
        : bciTheta["count"];
    bciAp["mv"] = bciTheta["mv"] / (bciLowBeta["mv"] + bciHighBeta["mv"]);
    bciAp["sdnn"] =
        bciTheta["sdnn"] / (bciLowBeta["sdnn"] + bciHighBeta["sdnn"]);
    bciAp["rmssd"] =
        bciTheta["rmssd"] / (bciLowBeta["rmssd"] + bciHighBeta["rmssd"]);
    bciAp["mv"] = (bciAp["mv"] * 100).toInt() / 100;
    bciAp["sdnn"] = (bciAp["sdnn"] * 100).toInt() / 100;
    bciAp["rmssd"] = (bciAp["rmssd"] * 100).toInt() / 100;

    ///AI
    _aiPrompt =
        "安全感${bciMed["mv"]}%、专注度${bciAtt["mv"]}%、心流指数${curFlow["mv"]}%、松弛度${curRelax["mv"]}%、愉悦感${bciAp["mv"] * 20}%、心率变异性NN50值${hrvRR["nn50"] * 100}%、心率变异性LF/HF比值${hrvRR["lfhf"] * 20}%";
  }

  String getAttr(double value, double maxValue) {
    if (value > maxValue * 0.9) {
      return "极高";
    }
    if (value > maxValue * 0.8) {
      return "高";
    }
    if (value > maxValue * 0.6) {
      return "较高";
    }
    if (value > maxValue * 0.4) {
      return "中";
    }
    if (value > maxValue * 0.2) {
      return "较低";
    }
    if (value > maxValue * 0.1) {
      return "低";
    }
    return "极低";
  }

  String formatTimestamp(String timestamp) {
    if (timestamp.isEmpty) return '';

    int milliseconds = int.tryParse(timestamp) ?? 0;
    if (milliseconds == 0) return timestamp; // 如果解析失败，返回原始字符串

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);
    return '${dateTime.year}年${dateTime.month.toString().padLeft(2, '0')}月${dateTime.day.toString().padLeft(2, '0')}日 '
        '${dateTime.hour.toString().padLeft(2, '0')}点${dateTime.minute.toString().padLeft(2, '0')}分${dateTime.second.toString().padLeft(2, '0')}秒${dateTime.millisecond.toString().padLeft(3, '0')}毫秒';
  }
}
