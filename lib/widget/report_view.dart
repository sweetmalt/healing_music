import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:healing_music/controller/ctrl.dart';
import 'package:healing_music/controller/healing_controller.dart';
import 'package:healing_music/data/data.dart';
import 'package:healing_music/style/style.dart';
import 'package:healing_music/widget/paragraph.dart';
import 'package:healing_music/widget/wave_chart.dart';
import 'package:uuid/uuid.dart';

class ReportView extends GetView<ReportViewController> {
  ReportView({super.key});
  final HealingController healingController = Get.find();
  final ReportViewController reportViewController = Get.find();
  final RxBool _showShortDoc = true.obs;
  final Map<String, Map<String, String>> _dataDoc = HealingController.dataDoc;

  @override
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
            decoration: const BoxDecoration(
                //color: ThemeData().colorScheme.secondaryContainer,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Column(
              children: [
                ListTile(
                    title: Text("能量报告", style: MyStyle.paragraphTitleTextStyle),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("综合得分 = 心理能量 & 生理能量"),
                        Text(
                            "LF/HF ${(healingController.hrvLFHF * 100).toInt() / 100}")
                      ],
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        healingController.customerNickname.value.isEmpty
                            ? showEditCustomerNicknameDialog(context,
                                callBack: () {
                                showSaveConfirmationDialog(context);
                              })
                            : showSaveConfirmationDialog(context);
                      },
                      icon: const Icon(Icons.save_alt_rounded),
                    )),
                ListTile(
                    tileColor: Colors.white,
                    title: Obx(() => Text(
                        "顾客昵称：${healingController.customerNickname.value}",
                        style: MyStyle.paragraphTitleTextStyle)),
                    trailing: IconButton(
                        onPressed: () {
                          showEditCustomerNicknameDialog(context);
                        },
                        icon: const Icon(Icons.edit_rounded))),
                const SizedBox(height: 40),
                StatisticsContainerCircle(
                    "综合得分", controller.energyPsyAndPhyScaling.value),
                const SizedBox(height: 20),
                Text(
                  "计时 ${(healingController.receivedBciDataCount / 60).toInt()}分${healingController.receivedBciDataCount % 60}秒",
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          ParagraphListTile(
            title:
                "${_dataDoc['energyPsy']?['title'] ?? ''}（${(controller.energyPsyScaling.value * 10000).toInt() / 100}分）",
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
                "${_dataDoc['energyPhy']?['title'] ?? ''}（${(controller.energyPhyScaling.value * 10000).toInt() / 100}分）",
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
            controller: healingController.hrvRRWaveController,
          ),
          Container(
            height: 40,
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 20, bottom: 40),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            child: Text(
                "LF/HF ${(healingController.hrvLFHF * 100).toInt() / 100}"),
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

  Future<void> showEditCustomerNicknameDialog(BuildContext context,
      {VoidCallback? callBack}) async {
    final TextEditingController controller = TextEditingController();
    controller.text = healingController.customerNickname.value;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // 用户必须点击按钮才能关闭对话框
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('顾客昵称'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  maxLength: 32,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: '请输入顾客昵称（2-32个字）',
                  ),
                  controller: controller,
                  onChanged: (value) {
                    controller.text = value;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[\u4e00-\u9fa5a-zA-Z0-9]')),
                  ],
                ),
                const Text("仅允许中文英文和数字，最少2个字"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
              },
            ),
            TextButton(
              child: const Text('确认'),
              onPressed: () {
                if (controller.text.length >= 2 &&
                    controller.text.length <= 32) {
                  healingController.customerNickname.value = controller.text;
                  Navigator.of(context).pop();
                  callBack?.call();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('昵称长度必须在4到32个字符之间')),
                  );
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showSaveConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // 用户必须点击按钮才能关闭对话框
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('为顾客保存一份能量报告'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('您确定要执行此操作吗？'),
                Text('此操作不可撤销。'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
              },
            ),
            TextButton(
              child: const Text('确认'),
              onPressed: () {
                // 在这里执行确认后的操作
                String nickname = healingController.customerNickname.value;
                int timestamp = DateTime.now().millisecondsSinceEpoch;
                //生成UUId
                String uuid = const Uuid().v1();

                Data.write({
                  "nickname": healingController.customerNickname.value,
                  "timestamp": timestamp.toString(),
                  "bciData": healingController.bciData,
                  "hrvData": healingController.hrvData,
                }, 'report_${nickname}_$uuid.json');
                Navigator.of(context).pop(); // 关闭对话框
              },
            ),
          ],
        );
      },
    );
  }
}

class ReportViewController extends Ctrl {
  final HealingController healingController = Get.find();
  final RxDouble energyPsyScaling = 1.0.obs; //心理能量占比
  final RxDouble energyPhyScaling = 1.0.obs; //生理能量占比
  final RxDouble energyPsyAndPhyScaling = 1.0.obs; //心理与生理
  Future<void> energyScaling() async {
    await healingController.statisticsHrv();
    await healingController.createReport();
    double temp =
        healingController.curRelaxWaveController.statisticsBestScaling +
            healingController.curSharpWaveController.statisticsBestScaling +
            healingController.curFlowWaveController.statisticsBestScaling;
    temp = temp >= 1 ? 1 : temp;
    energyPsyScaling.value = temp;

    temp = healingController.bciHeartRateWaveController.statisticsBestScaling;
    if (temp <= 0) {
      temp = 0.8 *
          healingController.bciHeartRateWaveController.statisticsBetterScaling;
    }
    double temp2 = healingController.hrvRRWaveController.statisticsBestScaling;
    if (temp2 <= 0) {
      temp2 =
          0.8 * healingController.hrvRRWaveController.statisticsBetterScaling;
    }
    temp = 0.5 * temp +
        0.2 * temp2 +
        0.3 *
            healingController
                .hrvRRWaveController.statisticsMeanInterfacing50Scaling;
    temp = temp >= 1 ? 1 : temp;
    energyPhyScaling.value = temp;

    energyPsyAndPhyScaling.value =
        0.5 * energyPsyScaling.value + 0.5 * energyPhyScaling.value;
  }
}
