import 'package:flutter/material.dart';
import 'package:healing_music/controller/healing_controller.dart';
import 'package:healing_music/style/style.dart';
import 'package:healing_music/widget/paragraph.dart';
import 'package:healing_music/widget/wave_chart.dart';
import 'package:get/get.dart';

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
                        Icons.toggle_on_rounded,
                        size: 40,
                        color: healingController.isDeviceLinking.value
                            ? Colors.green
                            : ThemeData().colorScheme.primary,
                      )
                    : Icon(Icons.toggle_off_rounded,
                    size: 40,
                        color: healingController.isDeviceLinking.value
                            ? Colors.green
                            : ThemeData().colorScheme.primary))),
          ),
          const SizedBox(
            height: 40,
          ),
          ParagraphListTile(
            title: "生命体征数据实时看板",
            onTap: () {},
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
            controller: healingController.bciHrvWaveController,
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
  final Map<String, Map<String, String>> _dataDoc = HealingController.dataDoc;
}
