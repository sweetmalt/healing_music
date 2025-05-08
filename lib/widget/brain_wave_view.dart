import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healing_music/controller/healing_controller.dart';
import 'package:healing_music/data/data.dart';
import 'package:healing_music/page/report_list_page.dart';
import 'package:healing_music/style/style.dart';
import 'package:healing_music/widget/paragraph.dart';
import 'package:healing_music/widget/wave_chart.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class BrainWaveView extends StatelessWidget {
  BrainWaveView({
    super.key,
  });

  final HealingController healingController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: ListView(
        children: [
          ListTile(
            leading: Icon(
              Icons.sensors_rounded,
              color: ThemeData().colorScheme.primary,
            ),
            title: Text(
              "AI脑机能量检测",
              style: TextStyle(
                color: ThemeData().colorScheme.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            title: Text(
              '''
感谢您选择我们的AI脑机能量检测服务。该项检测将帮助为您：
-提供精准的身心能量报告并通过专业顾问和AI模型进行解读
-提供精准的身心平衡干预方案，整合科技与自然手段实现疗愈
我们的检测服务将创新的结合国际标准量表与先进的脑机接口设备，由专业顾问引导，整个过程大约耗时5分钟。
请您舒适就坐，自然放松，开启一场内在旅行。
''',
              style: TextStyle(
                color: ThemeData().colorScheme.secondary,
                fontSize: 16,
              ),
            ),
          ),
          ListTile(
            title: Text(
              "睡眠与身心平衡咨询表",
              style: TextStyle(
                color: ThemeData().colorScheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(children: [
              ListTile(
                title: const Text(
                  "Part1：基础信息",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: ElevatedButton(
                    onPressed: () {
                      showEditCustomerNicknameDialog(context);
                    },
                    child: const Icon(Icons.edit_rounded)),
              ),
              Obx(() => ListTile(
                    title: Text(
                        "顾客昵称：${healingController.customerNickname.value}"),
                  )),
              Obx(() => ListTile(
                    title: Text("顾客年龄：${healingController.customerAge.value}岁"),
                  )),
              Obx(() => ListTile(
                    title: Text(
                        "顾客性别：${healingController.customerSex.value == 0 ? '男' : '女'}"),
                  )),
              const ListTile(
                title: Text(
                  "Part2：睡眠质量评估",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Text("Q1您的平均入睡时间需要多久？",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Obx(() => Text(
                    "【${healingController.customerSleepP2Q1.value}】",
                  )),
              const SizedBox(
                height: 10,
              ),
              for (int i = 0;
                  i < healingController.customerSleepP2Q1_.length;
                  i++)
                ElevatedButton(
                  onPressed: () {
                    healingController.customerSleepP2Q1.value =
                        healingController.customerSleepP2Q1_[i];
                  },
                  child: Text(
                    healingController.customerSleepP2Q1_[i],
                  ),
                ),
              const SizedBox(
                height: 20,
              ),
              const Text("Q2您是否经常有以下情况？（多选）",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Obx(() => Text(
                    "【${healingController.customerSleepP2Q2.value}】",
                  )),
              const SizedBox(
                height: 10,
              ),
              for (int i = 0;
                  i < healingController.customerSleepP2Q2_.keys.length;
                  i++)
                ElevatedButton(
                    onPressed: () {
                      String key = healingController.customerSleepP2Q2_.keys
                          .elementAt(i);
                      bool v = healingController.customerSleepP2Q2_[key]!;
                      healingController.customerSleepP2Q2_[key] = !v;
                      List<String> newList = [];
                      for (String k
                          in healingController.customerSleepP2Q2_.keys) {
                        if (healingController.customerSleepP2Q2_[k]!) {
                          newList.add(k);
                        }
                      }
                      healingController.customerSleepP2Q2.value =
                          newList.join(',');
                    },
                    child: Text(
                      healingController.customerSleepP2Q2_.keys.elementAt(i),
                    )),
              const SizedBox(
                height: 20,
              ),
              const Text("Q3您对当前睡眠质量的满意度如何？",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Obx(() => Text(
                    "【${healingController.customerSleepP2Q3.value}】",
                  )),
              const SizedBox(
                height: 10,
              ),
              for (int i = 0;
                  i < healingController.customerSleepP2Q3_.length;
                  i++)
                ElevatedButton(
                  onPressed: () {
                    healingController.customerSleepP2Q3.value =
                        healingController.customerSleepP2Q3_[i];
                  },
                  child: Text(
                    healingController.customerSleepP2Q3_[i],
                  ),
                ),
              const SizedBox(
                height: 20,
              ),
              const ListTile(
                title: Text(
                  "Part3：日常压力与情绪状态",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Text("Q1近期您感受到的压力主要来自哪些方面？（多选）",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Obx(() => Text(
                    "【${healingController.customerSleepP3Q1.value}】",
                  )),
              const SizedBox(
                height: 10,
              ),
              for (int i = 0;
                  i < healingController.customerSleepP3Q1_.keys.length;
                  i++)
                ElevatedButton(
                    onPressed: () {
                      String key = healingController.customerSleepP3Q1_.keys
                          .elementAt(i);
                      bool v = healingController.customerSleepP3Q1_[key]!;
                      healingController.customerSleepP3Q1_[key] = !v;
                      List<String> newList = [];
                      for (String k
                          in healingController.customerSleepP3Q1_.keys) {
                        if (healingController.customerSleepP3Q1_[k]!) {
                          newList.add(k);
                        }
                      }
                      healingController.customerSleepP3Q1.value =
                          newList.join(',');
                    },
                    child: Text(
                      healingController.customerSleepP3Q1_.keys.elementAt(i),
                    )),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Q2您是否经常出现以下情绪？（多选）",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Obx(() => Text(
                    "【${healingController.customerSleepP3Q2.value}】",
                  )),
              const SizedBox(
                height: 10,
              ),
              for (int i = 0;
                  i < healingController.customerSleepP3Q2_.keys.length;
                  i++)
                ElevatedButton(
                    onPressed: () {
                      String key = healingController.customerSleepP3Q2_.keys
                          .elementAt(i);
                      bool v = healingController.customerSleepP3Q2_[key]!;
                      healingController.customerSleepP3Q2_[key] = !v;
                      List<String> newList = [];
                      for (String k
                          in healingController.customerSleepP3Q2_.keys) {
                        if (healingController.customerSleepP3Q2_[k]!) {
                          newList.add(k);
                        }
                      }
                      healingController.customerSleepP3Q2.value =
                          newList.join(',');
                    },
                    child: Text(
                      healingController.customerSleepP3Q2_.keys.elementAt(i),
                    )),
              const SizedBox(
                height: 20,
              ),
            ]),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.all(ThemeData().colorScheme.primary),
            ),
            onPressed: () {
              healingController.isRecordData.value =
                  !healingController.isRecordData.value;
              if (healingController.isRecordData.value) {
                healingController.clearData();
                healingController.customerCheckSeconds.value = 180;
              }
            },
            child: Obx(() => Text(
                  healingController.isRecordData.value
                      ? healingController.customerCheckSeconds.value > 0
                          ? "检测进行中…稍等${healingController.customerCheckSeconds.value}秒"
                          : "检测完毕"
                      : "启动检测",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ),

          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.blue),
            ),
            onPressed: () {
              healingController.customerNickname.value.isEmpty
                  ? showEditCustomerNicknameDialog(context, callBack: () {
                      showSaveConfirmationDialog(context);
                    })
                  : showSaveConfirmationDialog(context);
            },
            child: const Text(
              "生成报告",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Colors.green),
            ),
            onPressed: () {
              Get.to(() => ReportList());
            },
            child: const Text(
              "查看报告",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 100,
          ),
          ListTile(
            title: Text('是否让设备参与音乐控制？', style: MyStyle.paragraphTitleTextStyle),
            subtitle: const Text(
                '是否将疗愈音乐的播放控制权交给脑波设备？具体来说，软件将根据用户的脑波数据变化，实时调节音乐组内各元素的编排、节奏、音量等，以达到最佳疗愈效果。例如，当用户逐渐进入睡眠状态时，软件将逐步调低音量，反之则调高。'),
            trailing: IconButton(
                onPressed: () {
                  healingController.isCtrlByDevice.value =
                      !healingController.isCtrlByDevice.value;
                },
                icon: Obx(() => healingController.isCtrlByDevice.value
                    ? Icon(
                        Icons.media_bluetooth_on_rounded,
                        size: 30,
                        color: healingController.isDeviceLinking.value
                            ? Colors.green
                            : ThemeData().colorScheme.primary,
                      )
                    : Icon(Icons.media_bluetooth_off_rounded,
                        size: 30,
                        color: healingController.isDeviceLinking.value
                            ? Colors.green
                            : ThemeData().colorScheme.primary))),
          ),
          const SizedBox(
            height: 40,
          ),
          ParagraphListTile(
            title: "实时数据看板（点击刷新：清除历史记录）",
            icon: Icons.refresh_rounded,
            onTap: () async {
              await healingController.clearData();
            },
          ),
          // BciSliderBox(),
          const SizedBox(
            height: 40,
          ),
          Obx(() => Stack(alignment: Alignment.center, children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                        ThemeData().colorScheme.primary),
                    value: healingController.curRelax.value / 100,
                    strokeWidth: 20,
                  ),
                ),
                Text(
                  '${healingController.curRelax.value.toInt()}%',
                  style: const TextStyle(fontSize: 24),
                ),
              ])),
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
          WaveChart(
            controller: healingController.curRelaxWaveController,
            lineColor: ThemeData().colorScheme.primary,
            lineWidth: 3,
          ),
          const SizedBox(
            height: 40,
          ),
          Obx(() => Stack(alignment: Alignment.center, children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                        ThemeData().colorScheme.primary),
                    value: healingController.curSharp.value / 100,
                    strokeWidth: 20,
                  ),
                ),
                Text(
                  '${healingController.curSharp.value.toInt()}%',
                  style: const TextStyle(fontSize: 24),
                ),
              ])),
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
          WaveChart(
            controller: healingController.curSharpWaveController,
            lineColor: ThemeData().colorScheme.primary,
            lineWidth: 3,
          ),
          const SizedBox(
            height: 40,
          ),
          Obx(() => Stack(alignment: Alignment.center, children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                        ThemeData().colorScheme.primary),
                    value: healingController.curFlow.value / 100,
                    strokeWidth: 20,
                  ),
                ),
                Text(
                  '${healingController.curFlow.value.toInt()}%',
                  style: const TextStyle(fontSize: 24),
                ),
              ])),
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
          WaveChart(
            controller: healingController.curFlowWaveController,
            lineColor: ThemeData().colorScheme.primary,
            lineWidth: 3,
          ),
          const SizedBox(
            height: 40,
          ),
          Obx(() => Stack(alignment: Alignment.center, children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                        ThemeData().colorScheme.primary),
                    value: healingController.bciAtt.value / 100,
                    strokeWidth: 20,
                  ),
                ),
                Text(
                  '${healingController.bciAtt.value.toInt()}%',
                  style: const TextStyle(fontSize: 24),
                ),
              ])),
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
          WaveChart(
            controller: healingController.bciAttWaveController,
            lineColor: ThemeData().colorScheme.primary,
            lineWidth: 3,
          ),
          const SizedBox(
            height: 40,
          ),
          Obx(() => Stack(alignment: Alignment.center, children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                        ThemeData().colorScheme.primary),
                    value: healingController.bciMed.value / 100,
                    strokeWidth: 20,
                  ),
                ),
                Text(
                  '${healingController.bciMed.value.toInt()}%',
                  style: const TextStyle(fontSize: 24),
                ),
              ])),
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
          WaveChart(
            controller: healingController.bciMedWaveController,
            lineColor: ThemeData().colorScheme.primary,
            lineWidth: 3,
          ),
          const SizedBox(
            height: 40,
          ),
          Obx(() => Stack(alignment: Alignment.center, children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                        ThemeData().colorScheme.primary),
                    value: healingController.bciAp.value / 4,
                    strokeWidth: 20,
                  ),
                ),
                Text(
                  '${_dataDoc['bciAp']?['state']?.split(",")[healingController.bciAp.value.toInt()]}',
                  style: const TextStyle(fontSize: 24),
                ),
              ])),
          ListTile(
            title: Text(_dataDoc['bciAp']?['title'] ?? '',
                style: MyStyle.paragraphTitleTextStyle),
            subtitle: Obx(
              () => _showShortDoc.value
                  ? Text(_dataDoc['bciAp']?['short'] ?? '')
                  : Text(_dataDoc['bciAp']?['long'] ?? ''),
            ),
            trailing: Obx(() => _showShortDocIconButton()),
          ),
          WaveChart(
            controller: healingController.bciApWaveController,
            lineColor: ThemeData().colorScheme.primary,
            lineWidth: 3,
          ),
          Container(
            alignment: Alignment.center,
            child: const Text("愉悦度与额温心率等数据不可同时获取"),
          ),
          const SizedBox(
            height: 40,
          ),
          ListTile(
            title: Text(_dataDoc['bciDelta']?['title'] ?? '',
                style: MyStyle.paragraphTitleTextStyle),
            subtitle: Obx(
              () => _showShortDoc.value
                  ? Text(_dataDoc['bciDelta']?['short'] ?? '')
                  : Text(_dataDoc['bciDelta']?['long'] ?? ''),
            ),
            trailing: Obx(() => _showShortDocIconButton()),
          ),
          WaveChart(
            controller: healingController.bciDeltaWaveController,
            lineColor: ThemeData().colorScheme.primary,
            lineWidth: 3,
          ),
          const SizedBox(
            height: 40,
          ),
          ListTile(
            title: Text(_dataDoc['bciTheta']?['title'] ?? '',
                style: MyStyle.paragraphTitleTextStyle),
            subtitle: Obx(
              () => _showShortDoc.value
                  ? Text(_dataDoc['bciTheta']?['short'] ?? '')
                  : Text(_dataDoc['bciTheta']?['long'] ?? ''),
            ),
            trailing: Obx(() => _showShortDocIconButton()),
          ),
          WaveChart(
            controller: healingController.bciThetaWaveController,
            lineColor: ThemeData().colorScheme.primary,
            lineWidth: 3,
          ),
          const SizedBox(
            height: 40,
          ),
          ListTile(
            title: Text(_dataDoc['bciLowAlpha']?['title'] ?? '',
                style: MyStyle.paragraphTitleTextStyle),
            subtitle: Obx(
              () => _showShortDoc.value
                  ? Text(_dataDoc['bciLowAlpha']?['short'] ?? '')
                  : Text(_dataDoc['bciLowAlpha']?['long'] ?? ''),
            ),
            trailing: Obx(() => _showShortDocIconButton()),
          ),
          WaveChart(
            controller: healingController.bciLowAlphaWaveController,
            lineColor: ThemeData().colorScheme.primary,
            lineWidth: 3,
          ),
          const SizedBox(
            height: 40,
          ),
          ListTile(
            title: Text(_dataDoc['bciHighAlpha']?['title'] ?? '',
                style: MyStyle.paragraphTitleTextStyle),
            subtitle: Obx(
              () => _showShortDoc.value
                  ? Text(_dataDoc['bciHighAlpha']?['short'] ?? '')
                  : Text(_dataDoc['bciHighAlpha']?['long'] ?? ''),
            ),
            trailing: Obx(() => _showShortDocIconButton()),
          ),
          WaveChart(
            controller: healingController.bciHighAlphaWaveController,
            lineColor: ThemeData().colorScheme.primary,
            lineWidth: 3,
          ),
          const SizedBox(
            height: 40,
          ),
          ListTile(
            title: Text(_dataDoc['bciLowBeta']?['title'] ?? '',
                style: MyStyle.paragraphTitleTextStyle),
            subtitle: Obx(
              () => _showShortDoc.value
                  ? Text(_dataDoc['bciLowBeta']?['short'] ?? '')
                  : Text(_dataDoc['bciLowBeta']?['long'] ?? ''),
            ),
            trailing: Obx(() => _showShortDocIconButton()),
          ),
          WaveChart(
            controller: healingController.bciLowBetaWaveController,
            lineColor: ThemeData().colorScheme.primary,
            lineWidth: 3,
          ),
          const SizedBox(
            height: 40,
          ),
          ListTile(
            title: Text(_dataDoc['bciHighBeta']?['title'] ?? '',
                style: MyStyle.paragraphTitleTextStyle),
            subtitle: Obx(
              () => _showShortDoc.value
                  ? Text(_dataDoc['bciHighBeta']?['short'] ?? '')
                  : Text(_dataDoc['bciHighBeta']?['long'] ?? ''),
            ),
            trailing: Obx(() => _showShortDocIconButton()),
          ),
          WaveChart(
            controller: healingController.bciHighBetaWaveController,
            lineColor: ThemeData().colorScheme.primary,
            lineWidth: 3,
          ),
          const SizedBox(
            height: 40,
          ),
          ListTile(
            title: Text(_dataDoc['bciLowGamma']?['title'] ?? '',
                style: MyStyle.paragraphTitleTextStyle),
            subtitle: Obx(
              () => _showShortDoc.value
                  ? Text(_dataDoc['bciLowGamma']?['short'] ?? '')
                  : Text(_dataDoc['bciLowGamma']?['long'] ?? ''),
            ),
            trailing: Obx(() => _showShortDocIconButton()),
          ),
          WaveChart(
            controller: healingController.bciLowGammaWaveController,
            lineColor: ThemeData().colorScheme.primary,
            lineWidth: 3,
          ),
          const SizedBox(
            height: 40,
          ),
          ListTile(
            title: Text(_dataDoc['bciMiddleGamma']?['title'] ?? '',
                style: MyStyle.paragraphTitleTextStyle),
            subtitle: Obx(
              () => _showShortDoc.value
                  ? Text(_dataDoc['bciMiddleGamma']?['short'] ?? '')
                  : Text(_dataDoc['bciMiddleGamma']?['long'] ?? ''),
            ),
            trailing: Obx(() => _showShortDocIconButton()),
          ),
          WaveChart(
            controller: healingController.bciMiddleGammaWaveController,
            lineColor: ThemeData().colorScheme.primary,
            lineWidth: 3,
          ),
          const SizedBox(
            height: 40,
          ),
          ListTile(
            title: Text(_dataDoc['bciTemperature']?['title'] ?? '',
                style: MyStyle.paragraphTitleTextStyle),
            subtitle: Obx(
              () => _showShortDoc.value
                  ? Text(_dataDoc['bciTemperature']?['short'] ?? '')
                  : Text(_dataDoc['bciTemperature']?['long'] ?? ''),
            ),
            trailing: Obx(() => _showShortDocIconButton()),
          ),
          WaveChart(
            controller: healingController.bciTemperatureWaveController,
            lineColor: ThemeData().colorScheme.primary,
            lineWidth: 3,
          ),
          const SizedBox(
            height: 40,
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
          WaveChart(
            controller: healingController.bciHeartRateWaveController,
            lineColor: ThemeData().colorScheme.primary,
            lineWidth: 3,
          ),
          const SizedBox(
            height: 40,
          ),
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
          WaveChart(
            controller: healingController.hrvRRWaveController,
            lineColor: ThemeData().colorScheme.primary,
            lineWidth: 3,
          ),
          const SizedBox(
            height: 40,
          ),
          ListTile(
            title: Text(_dataDoc['bciGrind']?['title'] ?? '',
                style: MyStyle.paragraphTitleTextStyle),
            subtitle: Obx(
              () => _showShortDoc.value
                  ? Text(_dataDoc['bciGrind']?['short'] ?? '')
                  : Text(_dataDoc['bciGrind']?['long'] ?? ''),
            ),
            trailing: Obx(() => _showShortDocIconButton()),
          ),
          WaveChart(
            controller: healingController.bciGrindWaveController,
            lineColor: ThemeData().colorScheme.primary,
            lineWidth: 3,
          ),
          Container(
            height: 120,
            alignment: Alignment.center,
            child: const Text(
              '__ 什么叫活在当下 __',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showEditCustomerNicknameDialog(BuildContext context,
      {VoidCallback? callBack}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // 用户必须点击按钮才能关闭对话框
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('顾客'),
          contentPadding: const EdgeInsets.all(40),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                    initialValue: healingController.customerNickname.value,
                    decoration: const InputDecoration(
                      labelText: '顾客昵称',
                      hintText: '请输入顾客昵称（2-32个字）',
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[\u4e00-\u9fa5a-zA-Z0-9]')),
                    ],
                    onChanged: (value) {
                      healingController.customerNickname.value = value;
                    }),
                const SizedBox(height: 20),
                TextFormField(
                    initialValue:
                        healingController.customerAge.value.toString(),
                    decoration: const InputDecoration(
                      labelText: '顾客年龄',
                      hintText: '请输入顾客年龄',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    onChanged: (value) {
                      healingController.customerAge.value = int.parse(value);
                    }),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Obx(() => Text(
                        "性别（${healingController.customerSex.value == 0 ? '男' : '女'}）")),
                    const SizedBox(width: 20),
                    IconButton(
                        onPressed: () {
                          healingController.customerSex.value = 0;
                        },
                        icon: Obx(() => Icon(
                              healingController.customerSex.value == 0
                                  ? Icons.check_circle_rounded
                                  : Icons.male_rounded,
                              color: healingController.customerSex.value == 0
                                  ? Colors.blue
                                  : Colors.purple,
                            ))),
                    const SizedBox(width: 10),
                    IconButton(
                        onPressed: () {
                          healingController.customerSex.value = 1;
                        },
                        icon: Obx(() => Icon(
                              healingController.customerSex.value == 1
                                  ? Icons.check_circle_rounded
                                  : Icons.female_rounded,
                              color: healingController.customerSex.value == 1
                                  ? Colors.blue
                                  : Colors.purple,
                            ))),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            // TextButton(
            //   child: const Text('取消'),
            //   onPressed: () {
            //     Navigator.of(context).pop(); // 关闭对话框
            //   },
            // ),
            TextButton(
              child: const Text('确认'),
              onPressed: () {
                int age = healingController.customerAge.value;
                if (age < 1 || age > 100) {
                  healingController.customerAge.value = 18;
                }
                String name = healingController.customerNickname.value;
                if (name.length >= 2 && name.length <= 32) {
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
                ///在这里执行确认后的操作
                String nickname = healingController.customerNickname.value;
                int timestamp = DateTime.now().millisecondsSinceEpoch;

                ///生成UUId
                String uuid = const Uuid().v1();

                ///本机存储
                Map<String, dynamic> report = {
                  "nickname": healingController.customerNickname.value,
                  "age": healingController.customerAge.value,
                  "sex": healingController.customerSex.value,
                  "timestamp": timestamp.toString(),
                  "uuid": uuid,
                  "sleep_p2q1": healingController.customerSleepP2Q1.value,
                  "sleep_p2q2": healingController.customerSleepP2Q2.value,
                  "sleep_p2q3": healingController.customerSleepP2Q3.value,
                  "sleep_p3q1": healingController.customerSleepP3Q1.value,
                  "sleep_p3q2": healingController.customerSleepP3Q2.value,

                  ///脑波数据
                  "bciData": healingController.bciData,
                  "bciDataAtt": healingController.bciDataAtt,
                  "bciDataMed": healingController.bciDataMed,
                  "bciDataDelta": healingController.bciDataDelta,
                  "bciDataTheta": healingController.bciDataTheta,
                  "bciDataLowAlpha": healingController.bciDataLowAlpha,
                  "bciDataHighAlpha": healingController.bciDataHighAlpha,
                  "bciDataLowBeta": healingController.bciDataLowBeta,
                  "bciDataHighBeta": healingController.bciDataHighBeta,
                  "bciDataLowGamma": healingController.bciDataLowGamma,
                  "bciDataMiddleGamma": healingController.bciDataMiddleGamma,
                  "bciDataTemperature": healingController.bciDataTemperature,
                  "bciDataHeartRate": healingController.bciDataHeartRate,
                  "bciDataGrind": healingController.bciDataGrind,

                  ///hrv数据
                  "hrvData": healingController.hrvData,
                };
                Data.write(report, 'report_${nickname}_$uuid.json');
                Navigator.of(context).pop(); // 关闭对话框
              },
            ),
          ],
        );
      },
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

  final RxBool _showShortDoc = true.obs;
  final Map<String, Map<String, String>> _dataDoc = Data.dataDoc;
}

class BciSliderBox extends StatelessWidget {
  BciSliderBox({super.key});
  final HealingController healingController = Get.put(HealingController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      child: Column(
        children: [
          BciSlider(
            title: "全息", //γ 波
            color: Colors.purple,
            maxValue: 1,
            value: healingController.bciGammaHistory60Mean.value,
          ),
          BciSlider(
            title: "睡眠", //δ 波
            color: Colors.deepPurpleAccent,
            maxValue: 1,
            value: healingController.bciDeltaHistory60Mean.value,
          ),
          BciSlider(
            title: "代谢", //θ 波
            color: Colors.blue,
            maxValue: 1,
            value: healingController.bciThetaHistory60Mean.value,
          ),
          BciSlider(
            title: "免疫", //高 α
            color: Colors.green,
            maxValue: 1,
            value: healingController.bciHighAlphaHistory60Mean.value,
          ),
          BciSlider(
            title: "消化", //低 α
            color: Colors.yellow,
            maxValue: 1,
            value: healingController.bciLowAlphaHistory60Mean.value,
          ),
          BciSlider(
            title: "幸福", //高 β
            color: Colors.orange,
            maxValue: 1,
            value: healingController.bciHighBetaHistory60Mean.value,
          ),
          BciSlider(
            title: "动力", //低 β
            color: Colors.red,
            maxValue: 1,
            value: healingController.bciLowBetaHistory60Mean.value,
          ),
        ],
      ),
    );
  }
}

class BciSlider extends StatelessWidget {
  final double value;
  final double maxValue;
  final String title;
  final Color color;

  const BciSlider(
      {super.key,
      required this.title,
      required this.color,
      required this.value,
      required this.maxValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: [
          Text(title),
          Expanded(
              child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3,
                    activeTrackColor: color,
                    thumbColor: ThemeData().colorScheme.surface,
                    inactiveTrackColor:
                        ThemeData().colorScheme.primaryContainer,
                  ),
                  child: Slider(
                    min: 0.0,
                    max: maxValue,
                    value: value > maxValue ? maxValue : value,
                    onChanged: (double value) {},
                  ))),
          Text("${((value / maxValue) * 100).toInt()}%"),
        ],
      ),
    );
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
}
