import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:scidart/numdart.dart';
import 'package:scidart/scidart.dart';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:healing_music/controller/ctrl.dart';
import 'package:healing_music/controller/players_controller.dart';
import 'package:healing_music/data/data.dart';
import 'package:healing_music/widget/wave_chart.dart';

class HealingController extends Ctrl {
  final RxString title = ''.obs;
  final RxString subTitle = ''.obs;
  final RxString audioTitle = ''.obs;
  final RxString audioSubTitle = ''.obs;
  final RxBool isCtrlByDevice = true.obs;
  final RxBool isDeviceLinking = false.obs;
  final List<int> bciCurrentTwoTimeMillis = [0, 0]; //用于判断连接状态
  late Timer _whileTrue;
  final RxString healingTimePlanKey = ''.obs;
  final RxInt healingTimePlanKeyIndex = 2.obs; //默认选择第三项，45分钟
  List<Map<String, dynamic>> healingTimePlanData = [];
  final RxInt healingTimePlanIndex = 0.obs;
  final RxList healingTimePlanTexts = [].obs;
  final RxBool isCtrlByTimePlan = false.obs;
  final RxBool isPauseCtrlByTimePlan = false.obs;
  final RxBool isShowDetails = true.obs;
  static const eventChannel = EventChannel('top.healingAI.brainlink/receiver');
  StreamSubscription? _bciAndHrvBroadcastListener;
  final List<String> _bciData = <String>[""];
  final List<double> _hrvData = <double>[];
  //实时脑波数据
  final RxDouble bciAtt = 0.0.obs; //专注度
  final RxDouble bciMed = 0.0.obs; //安全感
  final RxDouble bciAp = 0.0.obs; //愉悦度
  final RxDouble bciDelta = 0.0.obs;
  final RxDouble bciTheta = 0.0.obs;
  final RxDouble bciLowAlpha = 0.0.obs;
  final RxDouble bciHighAlpha = 0.0.obs;
  final RxDouble bciLowBeta = 0.0.obs;
  final RxDouble bciHighBeta = 0.0.obs;
  final RxDouble bciLowGamma = 0.0.obs;
  final RxDouble bciMiddleGamma = 0.0.obs;
  final RxDouble bciTemperature = 0.0.obs;
  final RxDouble bciHeartRate = 0.0.obs; //心率
  final RxDouble bciGrind = 0.0.obs;
  final RxInt bciCurrentTimeMillis = 0.obs; //时间戳
  //最近60条脑波数据
  final List<double> _bciDeltaHistory60 = <double>[];
  final RxDouble bciDeltaHistory60Mean = 0.0.obs; //1
  final List<double> _bciThetaHistory60 = <double>[];
  final RxDouble bciThetaHistory60Mean = 0.0.obs; //2
  final List<double> _bciLowAlphaHistory60 = <double>[];
  final RxDouble bciLowAlphaHistory60Mean = 0.0.obs; //3
  final List<double> _bciHighAlphaHistory60 = <double>[];
  final RxDouble bciHighAlphaHistory60Mean = 0.0.obs; //4
  final List<double> _bciLowBetaHistory60 = <double>[];
  final RxDouble bciLowBetaHistory60Mean = 0.0.obs; //5
  final List<double> _bciHighBetaHistory60 = <double>[];
  final RxDouble bciHighBetaHistory60Mean = 0.0.obs; //6
  final List<double> _bciGammaHistory60 = <double>[];
  final RxDouble bciGammaHistory60Mean = 0.0.obs; //7

  //实时hrv数据
  final RxList<double> hrvRR = <double>[].obs;
  //统计的hrv数据，基于_hrvData
  final RxDouble hrvTP = 0.0.obs;
  final RxDouble hrvLF = 0.0.obs;
  final RxDouble hrvHF = 0.0.obs;
  final RxDouble hrvLFHF = 0.0.obs;

  /// 基于实时脑波数据的简单实时情绪数据（非统计）
  final RxDouble curRelax = 0.0.obs; //松弛感
  final RxDouble curSharp = 0.0.obs; //敏锐度
  final RxDouble curFlow = 0.0.obs; //心流指数

  final HemController hemController = Get.put(HemController());
  final EnvController envController = Get.put(EnvController());
  final BgmController bgmController = Get.put(BgmController());
  final BbmController bbmController = Get.put(BbmController());

  final RxString customerNickname = ''.obs;

  void setTimePlan(String k, int v) {
    isCtrlByTimePlan.value = true;
    isPauseCtrlByTimePlan.value = false;
    healingTimePlanIndex.value = 0;
    healingTimePlanKey.value = k;
    setTimer(v);
    Data.read("healing.json").then((healingPlan) {
      if (k != "") {
        var pplData = healingPlan[k];
        if (pplData is List) {
          List<Map<String, dynamic>> htd =
              pplData.map((item) => Map<String, dynamic>.from(item)).toList();
          List temp = [];
          for (var i = 0; i < htd.length; i++) {
            //int start = htd[i]["start"] as int;
            //int end = htd[i]["end"] as int;
            String interval = htd[i]["interval"] as String;
            Map<String, String> task = Map<String, String>.from(htd[i]["task"]);
            String player = task["player"] ?? "";
            //String audio = task["audio"] ?? "";
            String healing = task["healing"] ?? "";
            temp.add("${i + 1}:$interval:$player:$healing");
          }
          healingTimePlanTexts.value = temp;
          healingTimePlanData = htd;
        }
      }
    });
  }

  void _initWhileTrue() {
    const seconds = Duration(seconds: 3);
    _whileTrue = Timer.periodic(seconds, (Timer timer) {
      if (bciCurrentTwoTimeMillis[1] != bciCurrentTwoTimeMillis[0]) {
        isDeviceLinking.value = true;
        bciCurrentTwoTimeMillis[0] = bciCurrentTwoTimeMillis[1];
      } else {
        isDeviceLinking.value = false;
      }
    });
  }

  Future<void> _ctrlByDevice() async {
    if (isCtrlByDevice.value) {
      /**
       * 当用户出现瞬时心流状态时（松弛度>80+专注度>80），以20%的音量插播一次10秒颂钵音频，一分钟内不再插播
       * 当用户出现瞬时满分松弛度时（100），以20%的音量插播一次10秒雨棍音频，一分钟内不再插播
       * 当用户出现瞬时满分专注度时（100），以20%的音量插播一次10秒丁夏音频，一分钟内不再插播
       * 当连续五分钟的连续五个平均心率的持续走低时，音量直降至20%，如果已经低于20%，则直降至10%
       * 当连续五分钟的连续五个平均心率的持续升高时，音量跃升至30%，如果已经高于30%，则直升至40%
       * 专注度>80,会提高音量，每次1%，上限40%
       * 放松度>80,会降低音量，每次1%，下限10%
       */
    }
  }

  final curRelaxWaveController = WaveChartController(
    minY: 0,
    maxY: 100,
  );
  final curSharpWaveController = WaveChartController(
    minY: 0,
    maxY: 100,
  );
  final curFlowWaveController = WaveChartController(
    minY: 0,
    maxY: 100,
  );
  final bciAttWaveController = WaveChartController(
    minY: 0,
    maxY: 100,
  );
  final bciMedWaveController = WaveChartController(
    minY: 0,
    maxY: 100,
  );
  final bciApWaveController = WaveChartController(
    minY: 0,
    maxY: 4,
  );
  final bciDeltaWaveController = WaveChartController(
    minY: 0,
    maxY: 100000,
  );
  final bciThetaWaveController = WaveChartController(
    minY: 0,
    maxY: 100000,
  );
  final bciLowAlphaWaveController = WaveChartController(
    minY: 0,
    maxY: 100000,
  );
  final bciHighAlphaWaveController = WaveChartController(
    minY: 0,
    maxY: 100000,
  );
  final bciLowBetaWaveController = WaveChartController(
    minY: 0,
    maxY: 100000,
  );
  final bciHighBetaWaveController = WaveChartController(
    minY: 0,
    maxY: 100000,
  );
  final bciLowGammaWaveController = WaveChartController(
    minY: 0,
    maxY: 100000,
  );
  final bciMiddleGammaWaveController = WaveChartController(
    minY: 0,
    maxY: 100000,
  );
  final bciTemperatureWaveController = WaveChartController(
    minY: 0,
    maxY: 50,
  );
  final bciHeartRateWaveController = WaveChartController(
    minY: 0,
    maxY: 200,
  );
  final bciGrindWaveController = WaveChartController(
    minY: 0,
    maxY: 2,
  );
  final hrvRRWaveController = WaveChartController(
    minY: 0,
    maxY: 1500,
  );

  Future<void> _dataAnalysis() async {
    curRelax.value = 0.5 * (100 - bciAtt.value) + 0.5 * bciMed.value;
    curSharp.value = 0.5 * bciAtt.value + 0.5 * (100 - bciMed.value);
    curFlow.value = 0.5 * bciAtt.value + 0.5 * bciMed.value;
  }

  Future<void> _showRealData() async {
    ///
    await curRelaxWaveController.addDataPoint(curRelax.value);
    await curSharpWaveController.addDataPoint(curSharp.value);
    await curFlowWaveController.addDataPoint(curFlow.value);

    ///
    await bciAttWaveController.addDataPoint(bciAtt.value);
    await bciMedWaveController.addDataPoint(bciMed.value);
    await bciApWaveController.addDataPoint(bciAp.value);
    await bciDeltaWaveController.addDataPoint(bciDelta.value);
    await bciThetaWaveController.addDataPoint(bciTheta.value);
    await bciLowAlphaWaveController.addDataPoint(bciLowAlpha.value);
    await bciHighAlphaWaveController.addDataPoint(bciHighAlpha.value);
    await bciLowBetaWaveController.addDataPoint(bciLowBeta.value);
    await bciHighBetaWaveController.addDataPoint(bciHighBeta.value);
    await bciLowGammaWaveController.addDataPoint(bciLowGamma.value);
    await bciMiddleGammaWaveController.addDataPoint(bciMiddleGamma.value);
    await bciTemperatureWaveController.addDataPoint(bciTemperature.value);
    await bciHeartRateWaveController.addDataPoint(bciHeartRate.value);
    await bciGrindWaveController.addDataPoint(bciGrind.value);
    for (double item in hrvRR) {
      await hrvRRWaveController.addDataPoint(item);
    }
  }

  Future<void> clearData() async {
    _bciData.clear();
    _hrvData.clear();
    await curRelaxWaveController.clearData();
    await curSharpWaveController.clearData();
    await curFlowWaveController.clearData();
    await bciAttWaveController.clearData();
    await bciMedWaveController.clearData();
    await bciApWaveController.clearData();
    await bciDeltaWaveController.clearData();
    await bciThetaWaveController.clearData();
    await bciLowAlphaWaveController.clearData();
    await bciHighAlphaWaveController.clearData();
    await bciLowBetaWaveController.clearData();
    await bciHighBetaWaveController.clearData();
    await bciLowGammaWaveController.clearData();
    await bciMiddleGammaWaveController.clearData();
    await bciTemperatureWaveController.clearData();
    await bciHeartRateWaveController.clearData();
    await bciGrindWaveController.clearData();

    await hrvRRWaveController.clearData();
  }

  List<String> get bciData {
    return _bciData;
  }

  List<double> get hrvData {
    return _hrvData;
  }

  get receivedBciDataCount => _bciData.length;
  get receivedHrvDataCount => _hrvData.length;

  Future<void> createReport() async {
    await curRelaxWaveController.statistics();
    await curSharpWaveController.statistics();
    await curFlowWaveController.statistics();
    await bciAttWaveController.statistics();
    await bciMedWaveController.statistics();
    await bciHeartRateWaveController.setBestLimits(60, 80);
    await bciHeartRateWaveController.setBetterLimits(50, 90);
    await bciHeartRateWaveController.statistics();
    await hrvRRWaveController.setBestLimits(750, 1000);
    await hrvRRWaveController.setBetterLimits(666, 1200);
    await hrvRRWaveController.statistics();
  }

  @override
  void onInit() {
    super.onInit();
    _initWhileTrue();
    _bciAndHrvBroadcastListener =
        eventChannel.receiveBroadcastStream().listen((data) async {
      List<String> temp = data.toString().split('_');
      if (temp.length == 2) {
        if (temp[0] == "bci") {
          temp = temp[1].split(',');
          if (temp.length == 15) {
            bciAtt.value = double.parse(temp[0]);
            bciMed.value = double.parse(temp[1]);
            bciAp.value = double.parse(temp[2]);
            bciDelta.value = double.parse(temp[3]);
            bciTheta.value = double.parse(temp[4]);
            bciLowAlpha.value = double.parse(temp[5]);
            bciHighAlpha.value = double.parse(temp[6]);
            bciLowBeta.value = double.parse(temp[7]);
            bciHighBeta.value = double.parse(temp[8]);
            bciLowGamma.value = double.parse(temp[9]);
            bciMiddleGamma.value = double.parse(temp[10]);
            bciTemperature.value = double.parse(temp[11]);
            bciHeartRate.value = double.parse(temp[12]);
            bciGrind.value = double.parse(temp[13]);
            bciCurrentTimeMillis.value = int.parse(temp[14]);
            bciCurrentTwoTimeMillis[1] = bciCurrentTimeMillis.value;

            _bciData.add(data.toString());
            if (_bciData.length > 3600) {
              _bciData.removeRange(0, 1800);
            }
            //最近60条数据的平均值
            //1 bciDelta
            double x = bciDelta.value;
            x = x > 50000 ? 50000 : x;
            _bciDeltaHistory60.add(x);
            if (_bciDeltaHistory60.length > 60) {
              _bciDeltaHistory60.removeAt(0);
            }
            bciDeltaHistory60Mean.value =
                _bciDeltaHistory60.reduce((a, b) => a + b) /
                    _bciDeltaHistory60.length;
            //2 bciTheta
            x = bciTheta.value;
            x = x > 50000 ? 50000 : x;
            _bciThetaHistory60.add(x);
            if (_bciThetaHistory60.length > 60) {
              _bciThetaHistory60.removeAt(0);
            }
            bciThetaHistory60Mean.value =
                _bciThetaHistory60.reduce((a, b) => a + b) /
                    _bciThetaHistory60.length;
            //3 bciLowAlpha
            x = bciLowAlpha.value;
            x = x > 50000 ? 50000 : x;
            _bciLowAlphaHistory60.add(x);
            if (_bciLowAlphaHistory60.length > 60) {
              _bciLowAlphaHistory60.removeAt(0);
            }
            bciLowAlphaHistory60Mean.value =
                _bciLowAlphaHistory60.reduce((a, b) => a + b) /
                    _bciLowAlphaHistory60.length;
            //4 bciHighAlpha
            x = bciHighAlpha.value;
            x = x > 50000 ? 50000 : x;
            _bciHighAlphaHistory60.add(x);
            if (_bciHighAlphaHistory60.length > 60) {
              _bciHighAlphaHistory60.removeAt(0);
            }
            bciHighAlphaHistory60Mean.value =
                _bciHighAlphaHistory60.reduce((a, b) => a + b) /
                    _bciHighAlphaHistory60.length;
            //5 bciLowBeta
            x = bciLowBeta.value;
            x = x > 50000 ? 50000 : x;
            _bciLowBetaHistory60.add(x);
            if (_bciLowBetaHistory60.length > 60) {
              _bciLowBetaHistory60.removeAt(0);
            }
            bciLowBetaHistory60Mean.value =
                _bciLowBetaHistory60.reduce((a, b) => a + b) /
                    _bciLowBetaHistory60.length;
            //6 bciHighBeta
            x = bciHighBeta.value;
            x = x > 50000 ? 50000 : x;
            _bciHighBetaHistory60.add(x);
            if (_bciHighBetaHistory60.length > 60) {
              _bciHighBetaHistory60.removeAt(0);
            }
            bciHighBetaHistory60Mean.value =
                _bciHighBetaHistory60.reduce((a, b) => a + b) /
                    _bciHighBetaHistory60.length;
            //7 bciLowGamma
            x = bciLowGamma.value + bciMiddleGamma.value;
            x = x > 50000 ? 50000 : x;
            _bciGammaHistory60.add(x);
            if (_bciGammaHistory60.length > 60) {
              _bciGammaHistory60.removeAt(0);
            }
            bciGammaHistory60Mean.value =
                _bciGammaHistory60.reduce((a, b) => a + b) /
                    _bciGammaHistory60.length;
          }
        }
        if (temp[0] == "hrv") {
          temp = temp[1].split(',');
          if (temp.isNotEmpty) {
            List<double> x = [];
            for (String item in temp) {
              x.add(double.parse(item));
            }
            hrvRR.value = x;
            _hrvData.addAll(x);
            if (_hrvData.length > 3600) {
              _hrvData.removeRange(0, 1800);
            }
          }
        }
        await _dataAnalysis();
        await _showRealData();
        await _ctrlByDevice();
      }
    }, onError: (error) {});

    _loadVolumes();
  }

  void _loadVolumes() {
    Data.read("volume.json").then((volumesData) {
      hemController.setMaxVol(volumesData['hem']!);
      envController.setMaxVol(volumesData['env']!);
      bgmController.setMaxVol(volumesData['bgm']!);
      bbmController.setMaxVol(volumesData['bbm']!);
    });
  }

  @override
  void onClose() {
    _bciAndHrvBroadcastListener?.cancel();
    _whileTrue.cancel();
    super.onClose();
  }

  static final Map<String, Map<String, String>> dataDoc = {
    'energyPsy': {"title": '心理能量 EPS', "short": "心理能量 EPS", "long": "心理能量 EPS"},
    'energyPhy': {"title": '生理能量 EPH', "short": "生理能量 EPH", "long": "生理能量 EPH"},
    'curRelax': {
      "title": '松弛感 RELAX',
      "short": "松弛感，是一场灵魂的深海潜游",
      "long":
          "在能量驿站，我们相信真正的疗愈始于对紧绷感的松绑。当城市喧嚣成为刺耳的噪音，请将自己浸入这片被光晕包裹的静谧场域。专业疗愈师以呼吸频率为锚点，引导你卸下防御铠甲，让每寸肌肤重新感知温度，让每根神经学会在安全结界里舒展。在这里，允许思绪像水母般自由游弋，允许情绪如退潮后的沙滩自然裸露。当肌肉记忆开始遗忘「紧绷」的姿势，你会听见细胞重启时发出的簌簌声——那是生命回归出厂设置的诚实回响。"
    },
    'curSharp': {
      "title": '敏锐度 SHARP',
      "short": "唤醒清醒力，掌控动态平衡",
      "long":
          "当感官褪去麻木，当直觉穿透表象，真正的敏锐力便成为连接世界的天线——它不意味着焦虑，而是让阳光下的尘埃与暗夜里的萤火都清晰可辨。在动态呼吸冥想中，您将训练大脑捕捉细微的情绪波动；通过环境音波解析课程，唤醒听觉对频率的精准解码；触觉感知矩阵则让指尖读懂温度变化的密语。这些并非超能力，而是人类与生俱来的觉察本能。"
    },
    'curFlow': {
      "title": '心流指数 FLOW',
      "short": "沉浸心流之境，唤醒内在能量",
      "long":
          "我们深谙现代人的困境：思绪如星火跳跃却难以凝聚，身体时刻紧绷难觅安宁。通过定制化疗愈方案，能量驿站助您开启专注力的潜能开关：在音波疗愈中感受意识的聚焦，在呼吸冥想里培育当下的觉察力。同时，我们以安全感为疗愈基石，通过零压漂浮舱消解肌肉记忆的紧张，用芳疗SPA唤醒肌肤的松弛本能，让您如回归母体般卸下防御。当专注力化为穿透迷雾的灯塔，安全感成为滋养心灵的温床，您将体验真正的「心流感」：时间流速仿佛改变，创造力自然流淌，每个细胞都浸润在平和愉悦中。"
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
      "title": '愉悦度 AP',
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
      "short": "心跳是驱动生命活力的核心机制，55~75bpm的平稳静息心率是释放生命能量的最佳状态。",
      "long":
          "心跳，宛如生命乐章中那激昂而又稳健的鼓点，是驱动生命活力的核心机制。从生命最初的萌芽开始，心脏便不知疲倦地跳动，它如同一位忠诚的卫士，为全身各个器官与组织源源不断地输送着饱含氧气与营养的血液。在众多心率数值中，55 至 75bpm 的平稳静息心率堪称释放生命能量的最佳状态。当心率处于这一区间，心脏无需过度操劳，却能高效地完成血液循环任务。身体的新陈代谢有条不紊地进行，各个细胞如同被精准调校的机器部件，活力满满地运转。在这样的心率下，我们会感到精力充沛，思维清晰，无论是应对日常工作，还是投入休闲活动，都能轻松胜任，尽情释放生命蕴含的无限能量，享受健康活力的生活。"
    },
    'bciHrv': {
      "title": '心率变异性 HRV',
      "short": "HRV（心率变异性）：副交感神经活性指标。",
      "long":
          "HRV，即心率变异性，是一项极具价值的生理指标，它精准反映着副交感神经的活性。我们都知道，人体的神经系统就像一个庞大且精密的网络，而副交感神经在其中扮演着至关重要的角色，主导着身体的放松与恢复。HRV 通过监测逐次心跳间隔时间的微小变化，来衡量副交感神经的活跃程度。当我们处于平静、放松的状态，比如悠然地享受午后时光，或是沉浸在舒缓的冥想中，副交感神经兴奋，HRV 数值较高，这意味着心脏跳动节奏富有弹性，身体正高效地进行自我修复与能量储备。相反，压力大、焦虑时，HRV 降低。因此，HRV 为我们洞察身体内部的自主神经系统平衡，提供了一把关键钥匙。"
    },
    'bciGrind': {"title": '咬牙', "short": "可用于控制音乐。", "long": "可用于控制音乐。"},
  };

  /// 基于rr间期值数组的心率变异性hrv数据的频域分析（Frequency-Domain Analysis）
  /// 通过功率谱密度（PSD）计算不同频段的能量分布：
  /// 总功率（TP）
  /// 总频段（通常 ≤0.4 Hz）的功率：
  /// TP = ∫0~0.4 P(f) df
  /// 低频功率（LF, 0.04–0.15 Hz）
  /// LF=∫0.040.15P(f)df
  /// 高频功率（HF, 0.15–0.4 Hz）
  /// HF=∫0.15~0.4P(f)df
  /// LF/HF 比值
  /// 反映交感与副交感神经平衡：
  /// LFHF=LF功率/HF功率
  Future<void> statisticsHrv() async {
    if (_hrvData.length < 10) {
      return;
    }
    List p = calculateLFHF(_hrvData);
    hrvTP.value = p[0];
    hrvLF.value = p[1];
    hrvHF.value = p[2];
    hrvLFHF.value = p[3];
    if (kDebugMode) {
      print(' [tp, lf, hf, lfhf]: $p');
    }
  }

  List<double> calculateLFHF(List<double> hrvData) {
    // 将HRV数据转换为数组
    ArrayComplex arrayComplex = ArrayComplex.empty();
    for (int i = 0; i < hrvData.length; i++) {
      Complex c = Complex(real: hrvData[i]);
      arrayComplex.add(c);
    }
    // 进行傅里叶变换
    ArrayComplex fftResult = fft(arrayComplex);
    // 计算频率分辨率
    double freqResolution = 1.0 / hrvData.length;
    // 计算总功率（TP）
    double tp = 0.0;
    for (int i = 0; i < fftResult.length; i++) {
      double freq = i * freqResolution;
      if (freq <= 0.4) {
        double abs = fftResult[i].real * fftResult[i].real +
            fftResult[i].imaginary * fftResult[i].imaginary;
        tp += abs;
      }
    }
    //计算低频功率（LF）
    double lf = 0.0;
    for (int i = 0; i < fftResult.length; i++) {
      double freq = i * freqResolution;
      if (freq >= 0.04 && freq <= 0.15) {
        double abs = fftResult[i].real * fftResult[i].real +
            fftResult[i].imaginary * fftResult[i].imaginary;
        lf += abs;
      }
    }
    //计算高频功率（HF）
    double hf = 0.0;
    for (int i = 0; i < fftResult.length; i++) {
      double freq = i * freqResolution;
      if (freq >= 0.15 && freq <= 0.4) {
        double abs = fftResult[i].real * fftResult[i].real +
            fftResult[i].imaginary * fftResult[i].imaginary;
        hf += abs;
      }
    }
    //计算 LF/HF 比值
    double lfhf = 0.0;
    if (hf > 0) {
      lfhf = lf / hf;
    }
    return [tp, lf, hf, lfhf];
  }
}
