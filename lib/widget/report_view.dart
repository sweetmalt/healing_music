import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healing_music/controller/ctrl.dart';
import 'package:healing_music/controller/healing_controller.dart';
import 'package:healing_music/style/style.dart';
import 'package:healing_music/widget/paragraph.dart';
import 'package:healing_music/widget/wave_chart.dart';

class ReportView extends GetView<ReportViewController> {
  ReportView({super.key});
  final HealingController healingController = Get.find();
  final ReportViewController reportViewController = Get.find();
  final RxBool _showShortDoc = true.obs;
  final Map<String, Map<String, String>> _dataDoc = HealingController.dataDoc;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10),
      child: ListView(
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: ThemeData().colorScheme.secondaryContainer,
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Column(
              children: [
                ListTile(
                  title: Text("能量报告", style: MyStyle.paragraphTitleTextStyle),
                  subtitle: const Text("总能效，是指一个服务时段内，顾客对整体能量疗愈服务的有效利用率。"),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.save_rounded), 
                  )
                ),
                const SizedBox(height: 40),
                StatisticsContainerCircle("总能效",
                    controller.energyPsyScaling * controller.energyPhyScaling),
                const SizedBox(height: 20),
                Text(
                  "计时 ${(healingController.receivedDataCount / 60).toInt()}分${healingController.receivedDataCount % 60}秒",
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          ParagraphListTile(
            title:
                "${_dataDoc['energyPsy']?['title'] ?? ''}（能效 ${(controller.energyPsyScaling * 10000).toInt() / 100}%）",
            onTap: () {},
          ),
          ListTile(
            title: Text(_dataDoc['curRelax']?['title'] ?? '',
                style: MyStyle.paragraphTitleTextStyle),
            subtitle: Obx(
              () => _showShortDoc.value
                  ? Text(_dataDoc['curRelax']?['short'] ?? '')
                  : Text(_dataDoc['curRelax']?['long'] ?? ''),
            ),
            trailing: Obx(() => _showShortDocIconButton()),
          ),
          WaveChartStatistics(
            controller: healingController.curRelaxWaveController,
          ),
          const SizedBox(height: 40),
          ListTile(
            title: Text(_dataDoc['curSharp']?['title'] ?? '',
                style: MyStyle.paragraphTitleTextStyle),
            subtitle: Obx(
              () => _showShortDoc.value
                  ? Text(_dataDoc['curSharp']?['short'] ?? '')
                  : Text(_dataDoc['curSharp']?['long'] ?? ''),
            ),
            trailing: Obx(() => _showShortDocIconButton()),
          ),
          WaveChartStatistics(
            controller: healingController.curSharpWaveController,
          ),
          const SizedBox(height: 40),
          ListTile(
            title: Text(_dataDoc['curFlow']?['title'] ?? '',
                style: MyStyle.paragraphTitleTextStyle),
            subtitle: Obx(
              () => _showShortDoc.value
                  ? Text(_dataDoc['curFlow']?['short'] ?? '')
                  : Text(_dataDoc['curFlow']?['long'] ?? ''),
            ),
            trailing: Obx(() => _showShortDocIconButton()),
          ),
          WaveChartStatistics(
            controller: healingController.curFlowWaveController,
          ),
          const SizedBox(height: 40),
          ListTile(
            title: Text(_dataDoc['bciAtt']?['title'] ?? '',
                style: MyStyle.paragraphTitleTextStyle),
            subtitle: Obx(
              () => _showShortDoc.value
                  ? Text(_dataDoc['bciAtt']?['short'] ?? '')
                  : Text(_dataDoc['bciAtt']?['long'] ?? ''),
            ),
            trailing: Obx(() => _showShortDocIconButton()),
          ),
          WaveChartStatistics(
            controller: healingController.bciAttWaveController,
          ),
          const SizedBox(height: 40),
          ListTile(
            title: Text(_dataDoc['bciMed']?['title'] ?? '',
                style: MyStyle.paragraphTitleTextStyle),
            subtitle: Obx(
              () => _showShortDoc.value
                  ? Text(_dataDoc['bciMed']?['short'] ?? '')
                  : Text(_dataDoc['bciMed']?['long'] ?? ''),
            ),
            trailing: Obx(() => _showShortDocIconButton()),
          ),
          WaveChartStatistics(
            controller: healingController.bciMedWaveController,
          ),
          const SizedBox(height: 40),
          ParagraphListTile(
            title:
                "${_dataDoc['energyPhy']?['title'] ?? ''}（能效 ${(controller.energyPhyScaling * 10000).toInt() / 100}%）",
            onTap: () {},
          ),
          ListTile(
            title: Text(_dataDoc['bciHeartRate']?['title'] ?? '',
                style: MyStyle.paragraphTitleTextStyle),
            subtitle: Obx(
              () => _showShortDoc.value
                  ? Text(_dataDoc['bciHeartRate']?['short'] ?? '')
                  : Text(_dataDoc['bciHeartRate']?['long'] ?? ''),
            ),
            trailing: Obx(() => _showShortDocIconButton()),
          ),
          WaveChartStatistics(
            controller: healingController.bciHeartRateWaveController,
          ),
          const SizedBox(height: 40),
          ListTile(
            title: Text(_dataDoc['bciHrv']?['title'] ?? '',
                style: MyStyle.paragraphTitleTextStyle),
            subtitle: Obx(
              () => _showShortDoc.value
                  ? Text(_dataDoc['bciHrv']?['short'] ?? '')
                  : Text(_dataDoc['bciHrv']?['long'] ?? ''),
            ),
            trailing: Obx(() => _showShortDocIconButton()),
          ),
          WaveChartStatistics(
            controller: healingController.bciHrvWaveController,
          ),
          Container(
            alignment: Alignment.center,
            height: 120,
            child: const Text("洞察身心稳态平衡"),
          ),
        ],
      ),
    );
  }

  IconButton _showShortDocIconButton() {
    return IconButton(
        onPressed: () {
          _showShortDoc.value = !_showShortDoc.value;
        },
        icon: _showShortDoc.value
            ? const Icon(Icons.keyboard_double_arrow_down)
            : const Icon(Icons.keyboard_double_arrow_up));
  }
}

class ReportViewController extends Ctrl {
  final HealingController healingController = Get.find();
  double energyPsyScaling = 0; //心理能量占比
  double energyPhyScaling = 0; //生理能量占比
  Future<void> energyScaling() async {
    double temp = 0;
    temp = healingController.curRelaxWaveController.statisticsBestScaling +
        healingController.curSharpWaveController.statisticsBestScaling +
        healingController.curFlowWaveController.statisticsBestScaling;
    temp = temp > 1 ? 1 : temp;
    energyPsyScaling = temp;
    energyPhyScaling =
        healingController.bciHeartRateWaveController.statisticsBestScaling;

    temp = 0;
    temp = healingController
            .bciHrvWaveController.statisticsMeanInterfacingDifference /
        50;
    temp = temp > 1 ? 1 : temp;
    energyPhyScaling *= temp;
  }
}
