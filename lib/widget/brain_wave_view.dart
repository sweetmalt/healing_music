import 'package:flutter/material.dart';
import 'package:healing_music/controller/healing_controller.dart';
import 'package:healing_music/style/style.dart';
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
      padding: const EdgeInsets.all(20),
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
                        Icons.sensors_rounded,
                        color: healingController.isDeviceLinking.value
                            ? Colors.green
                            : ThemeData().colorScheme.primary,
                      )
                    : Icon(Icons.sensors_off_rounded,
                        color: healingController.isDeviceLinking.value
                            ? Colors.green
                            : ThemeData().colorScheme.primary))),
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
            child: const Text("温馨提示：开启愉悦度后，额温、心率等数据将不可同时获取。"),
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
  static final Map<String, Map<String, String>> _dataDoc = {
    'curRelax': {
      "title": '松弛度 RELAX',
      "short": "RELAX = 0.5 ✖ (100 - ATT) + 0.5 ✖ MED",
      "long": "宽宥，从容"
    },
    'curSharp': {
      "title": '敏锐度 SHARP',
      "short": "SHARP = 0.5 ✖ ATT + 0.5 ✖ (100 - MED)",
      "long": "感受，觉醒"
    },
    'curFlow': {
      "title": '心流指数 FLOW',
      "short": "FLOW = 0.5 ✖ ATT + 0.5 ✖ MED",
      "long": "思维，艺术"
    },
    'bciAtt': {
      "title": '专注度 ATT',
      "short": "注意力越集中，精神内耗越低，越能把更多能量用于身心修复。",
      "long":
          "在快节奏的生活里，人们常陷入精神内耗的漩涡。其实，注意力的集中程度与精神内耗有着紧密联系。当我们全身心地投入到一件事情中，注意力高度集中，大脑便不会被纷杂的杂念所占据。此时，内心如同澄澈的湖面，毫无波澜。这种状态下，我们用于对抗内耗的能量大幅减少，从而能将更多的能量用于身心的修复。就像在静谧的深夜，专注于冥想的人，能让疲惫的身心得到深度滋养，重新焕发生机，以更饱满的精神迎接新的挑战 。"
    },
    'bciMed': {
      "title": '安全感 MED',
      "short": "安全感越高，人越松弛，副交感神经承受的压力越低，越能把更多能量用于身心疗愈。",
      "long":
          "安全感，宛如心灵的坚固护盾，深刻影响着我们的身心状态。当安全感充足，我们周身紧绷的神经便会慢慢舒缓，整个人呈现出松弛自在的模样。在这一状态下，主导身体放松与恢复的副交感神经，所承受的压力也随之显著降低。副交感神经压力的减轻，意味着身体不再时刻处于应激防御状态，得以将更多的能量投入到身心疗愈之中。就如同春日暖阳轻柔照耀，滋养着疲惫的心灵，修复着受损的身体机能，让我们由内而外重焕活力，从容面对生活里的种种挑战 。"
    },
    'bciAp': {
      "title": '愉悦感 AP',
      "short": "越愉悦，越接纳，这是吸纳外部能量的关键时刻。",
      "state": "平常,舒心,畅快,欢喜,极乐",
      "long":
          "当内心被愉悦的情绪充盈，我们整个人都会变得柔和且开放。这种状态下，我们对自我与外界的接纳度也会随之达到峰值。此时，恰似为心灵开启了一扇宽广的大门，外界的积极能量得以长驱直入。愉悦的心境就像一块强大的磁石，吸引着美好的人和事向我们靠近。在每一个开怀大笑、满心欢喜的瞬间，我们不再对外部世界心存抵触，而是以一种全然接纳的姿态去拥抱。这正是吸纳外部能量的关键时刻，每一丝积极的气息、每一份温暖的善意，都能毫无阻碍地融入我们的生命，助力我们不断成长与蜕变。"
    },
    'bciDelta': {
      "title": 'δ波 Delta',
      "short": "德尔塔波是一种睡眠状态时占主导的神经活动。",
      "long":
          "德尔塔波是一类极为特殊的神经活动。当我们陷入睡眠状态，大脑不再被清醒时的繁杂思绪充斥，德尔塔波便逐渐占据主导地位。它的频率极为缓慢，却蕴含着巨大的能量。这种波的产生，意味着身体已进入深度的休息阶段。在德尔塔波的作用下，心跳趋于平缓，呼吸变得深沉且均匀，肌肉也彻底放松下来。身体仿佛开启了自我修复的 “夜间工厂”，细胞加速新陈代谢，疲惫的器官得到滋养，免疫系统全力运作。德尔塔波主导的睡眠状态，是身心恢复活力、为新一天积蓄能量的关键时期 。"
    },
    'bciTheta': {
      "title": 'θ波 Theta',
      "short": "θ波是一种趋近睡眠状态时占主导的神经活动。",
      "long":
          "θ 波在趋近睡眠状态时发挥着主导作用。当夜幕降临，白日的喧嚣渐渐远去，我们的意识开始变得模糊，身体也愈发放松，此时 θ 波便悄然登场。它的频率介于 4 至 8 赫兹之间，相比清醒时的高频脑波，θ 波显得缓慢而沉稳。伴随着 θ 波的产生，我们仿佛进入了一个半梦半醒的奇妙地带。在这个状态下，身体各部分机能逐渐放缓节奏，肌肉松弛，呼吸也趋于平稳。大脑不再进行高强度的思考运算，转而开始为即将到来的深度睡眠做准备，让身心在 θ 波的轻抚下，慢慢沉浸到舒缓宁静的氛围之中，为睡眠修复之旅拉开序幕。"
    },
    'bciLowAlpha': {
      "title": '低α波 LowAlpha',
      "short": "低α波是一种处在松弛状态时占主导的神经活动。",
      "long":
          "低 α 波的频率通常在 8 至 10 赫兹之间，节奏舒缓而平稳。它的出现，如同给身心注入了一股宁静的力量。随着低 α 波的活跃，紧绷的肌肉渐渐放松，焦虑与压力悄然消散。我们的思维不再急切地追逐目标，而是变得悠然、闲适。在低 α 波主导下，身心如同进入了一片宁静港湾，享受着惬意与自在，为后续的精力恢复奠定良好基础 。"
    },
    'bciHighAlpha': {
      "title": '高α波 HighAlpha',
      "short": "高α波是一种趋近松弛状态时占主导的神经活动。",
      "long":
          "高 α 波频率大约处于 10 至 12 赫兹之间，其节奏轻快而富有韵律。此时，身体尚未完全松弛下来，但已开始感知到放松的信号。就像在繁忙工作间隙，暂时放下手头事务，靠在椅背上，轻轻闭上双眼的那一刻，高 α 波活跃起来。它促使紧绷的神经纤维逐步舒展，心跳也随之稍缓，呼吸渐趋平和。思维不再被繁杂琐事紧紧束缚，开始拥有一丝自由的灵动，为即将到来的全身心松弛状态铺就道路，引领我们走向宁静舒缓之境 。"
    },
    'bciLowBeta': {
      "title": '低β波 LowBeta',
      "short": "低β波是一种处在思虑状态时占主导的神经活动。",
      "long":
          "低 β 波是思虑状态下的显著标识。当我们陷入对问题的思索、规划未来事务，或是回忆过往经历时，低 β 波便开始在神经元之间踊跃传递。它的频率范围通常在 12 至 15 赫兹，不算太快，但充满活力。此时，大脑的不同区域协同运作，前额叶负责逻辑分析，海马体助力记忆调取。随着低 β 波的主导，我们全身心投入思考，注意力高度聚焦。身体虽保持相对静止，可大脑内部如同忙碌的蜂巢。血液加速流向大脑，为神经细胞输送充足养分，助力思维不断深入拓展，让我们在思虑的海洋中持续探索，直至梳理清思绪，找到问题的解决方向 。"
    },
    'bciHighBeta': {
      "title": '高β波 HighBeta',
      "short": "高β波是一种趋近思虑状态时占主导的神经活动。",
      "long":
          "它的频率范围大致在 15 至 30 赫兹，节奏急促且充满力量。随着高 β 波占据主导，大脑各区域迅速进入 “备战” 状态。前额叶皮质飞速运转，进行逻辑推理与决策判断；颞叶积极参与，唤起相关知识与经验。身体也会不自觉地紧绷，心跳加快，为大脑高强度的工作提供充足能量。在高 β 波的驱动下，我们的思维愈发敏捷，不断在脑海中碰撞出灵感火花，朝着解决问题、达成目标的方向全速迈进 。"
    },
    'bciLowGamma': {
      "title": '低γ波 LowGamma',
      "short": "低γ波是一种处在一般专注状态时占主导的神经活动。",
      "long":
          "低 γ 波在一般专注状态下发挥着关键的主导作用。当我们沉浸于日常事务，像阅读一本引人入胜的书籍、专注地操作电脑处理文档，又或是精心烹制一顿美食时，低 γ 波便悄然 “上岗”。它的频率通常处于 30 至 50 赫兹之间，有着平稳且有序的节奏。一旦低 γ 波占据主导，大脑便开启高效工作模式。神经元之间默契协作，信息传递迅速而精准。我们的注意力高度集中，周围的干扰被自动屏蔽，全身心投入手头之事。此时，身体维持着稳定的状态，呼吸均匀，肌肉保持适度张力，为大脑专注运行提供坚实支撑，助力我们在一般专注状态下，高效完成各项任务，达成预期目标 。"
    },
    'bciMiddleGamma': {
      "title": '中γ波 MiddleGamma',
      "short": "中γ波是一种达到高度专注状态时占主导的神经活动。",
      "long":
          "当中 γ 波在高度专注状态下闪亮登场，整个 “会场” 便会被彻底点燃。在攻克一道棘手的数学难题、精心雕琢一幅艺术画作，或者进行一场紧张激烈的竞技比赛时，中 γ 波开始发挥它的魔力。其频率范围大致在 50 至 80 赫兹，节奏紧凑且充满爆发力。中 γ 波一旦占据主导，大脑的各个区域仿佛训练有素的精锐部队，迅速进入特级战备状态。前额叶皮质全力施展逻辑分析与深度思考的能力，视觉、听觉等感官区域将信息高效传递整合。身体也进入高度协调状态，呼吸不自觉放缓，心跳却沉稳有力，源源不断地为大脑输送能量。在中 γ 波的强力驱动下，我们与专注之事融为一体，外界的一切都被隔绝，全身心沉浸在高度专注的巅峰体验中，不断突破自我，向着目标全力冲刺 。"
    },
    'bciTemperature': {
      "title": '额温 Temperature',
      "short": "反应当前体温，一般比标准体温低1~2度。",
      "long":
          "人体体温是反映健康状况的重要指标，而额温作为常用的体温测量方式之一，有着独特的特性。额头部位暴露在外，其温度受外界环境影响较大。额温所反应的当前体温，一般情况下会比标准体温低 1 至 2 度。这是因为额头皮肤直接与空气接触，热量容易散失。比如在正常的室内环境下，使用额温枪测量，得出的数值通常会低于口腔或腋下测量的标准体温。不过，这一差值并非固定不变，在寒冷的室外，差值可能更大；而在闷热的环境里，差值或许会有所缩小。但总体而言，了解额温与标准体温的这一关系，能帮助我们更准确地解读体温数据，及时察觉身体的异常状况 。"
    },
    'bciHeartRate': {
      "title": '心率 HeartRate',
      "short": "心跳是驱动生命活力的核心机制，60~80bpm的平稳静息心率是释放生命能量的最佳状态。",
      "long":
          "心跳，宛如生命乐章中那激昂而又稳健的鼓点，是驱动生命活力的核心机制。从生命最初的萌芽开始，心脏便不知疲倦地跳动，它如同一位忠诚的卫士，为全身各个器官与组织源源不断地输送着饱含氧气与营养的血液。在众多心率数值中，60 至 80bpm 的平稳静息心率堪称释放生命能量的最佳状态。当心率处于这一区间，心脏无需过度操劳，却能高效地完成血液循环任务。身体的新陈代谢有条不紊地进行，各个细胞如同被精准调校的机器部件，活力满满地运转。在这样的心率下，我们会感到精力充沛，思维清晰，无论是应对日常工作，还是投入休闲活动，都能轻松胜任，尽情释放生命蕴含的无限能量，享受健康活力的生活。"
    },
    'bciHrv': {
      "title": '心率变异性 HRV',
      "short": "HRV（心率变异性）：副交感神经活性指标。",
      "long":
          "HRV，即心率变异性，是一项极具价值的生理指标，它精准反映着副交感神经的活性。我们都知道，人体的神经系统就像一个庞大且精密的网络，而副交感神经在其中扮演着至关重要的角色，主导着身体的放松与恢复。HRV 通过监测逐次心跳间隔时间的微小变化，来衡量副交感神经的活跃程度。当我们处于平静、放松的状态，比如悠然地享受午后时光，或是沉浸在舒缓的冥想中，副交感神经兴奋，HRV 数值较高，这意味着心脏跳动节奏富有弹性，身体正高效地进行自我修复与能量储备。相反，压力大、焦虑时，HRV 降低。因此，HRV 为我们洞察身体内部的自主神经系统平衡，提供了一把关键钥匙。"
    },
    'bciGrind': {"title": '咬牙', "short": "可用于控制音乐。", "long": "可用于控制音乐。"},
  };
}
