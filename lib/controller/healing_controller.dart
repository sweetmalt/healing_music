import 'dart:async';

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
  final RxBool isMute = false.obs; //是否静音
  final RxBool isCtrlByDevice = true.obs;
  final RxBool isDeviceLinking = true.obs;
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
  StreamSubscription? _streamSubscription;
  final RxString receivedData = "等待设备连接...".obs;
  final RxDouble bciAtt = 0.0.obs;
  final RxDouble bciMed = 0.0.obs;
  final RxDouble bciAp = 0.0.obs;
  final RxDouble bciDelta = 0.0.obs;
  final RxDouble bciTheta = 0.0.obs;
  final RxDouble bciLowAlpha = 0.0.obs;
  final RxDouble bciHighAlpha = 0.0.obs;
  final RxDouble bciLowBeta = 0.0.obs;
  final RxDouble bciHighBeta = 0.0.obs;
  final RxDouble bciLowGamma = 0.0.obs;
  final RxDouble bciMiddleGamma = 0.0.obs;
  final RxDouble bciTemperature = 0.0.obs;
  final RxDouble bciHeartRate = 0.0.obs;
  final RxString bciHrv = "0".obs; //hrv数组字符串
  final RxString bciOygen = "0".obs; //血氧数组字符串
  final RxDouble bciGrind = 0.0.obs;
  final RxInt bciCurrentTimeMillis = 0.obs; //时间戳

  final HemController hemController = Get.put(HemController());
  final EnvController envController = Get.put(EnvController());
  final BgmController bgmController = Get.put(BgmController());
  final BbmController bbmController = Get.put(BbmController());

  Future<void> startTimePlan(String k, int v) async {
    isCtrlByTimePlan.value = true;
    isPauseCtrlByTimePlan.value = false;
    healingTimePlanIndex.value = 0;
    healingTimePlanKey.value = k;
    setTimer(v);
    Data dataObj = Data(jsonFileName: "healing.json");
    dataObj.read().then((healingPlan) {
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

  void _ctrlByDevice() {
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

  final bciAttWaveController = WaveChartController(
    maxDataPoints: 60,
    minY: 0,
    maxY: 100,
  );
  final bciMedWaveController = WaveChartController(
    maxDataPoints: 60,
    minY: 0,
    maxY: 100,
  );
  final bciApWaveController = WaveChartController(
    maxDataPoints: 60,
    minY: 0,
    maxY: 4,
  );
  final bciDeltaWaveController = WaveChartController(
    maxDataPoints: 60,
    minY: 0,
    maxY: 100000,
  );
  final bciThetaWaveController = WaveChartController(
    maxDataPoints: 60,
    minY: 0,
    maxY: 100000,
  );
  final bciLowAlphaWaveController = WaveChartController(
    maxDataPoints: 60,
    minY: 0,
    maxY: 100000,
  );
  final bciHighAlphaWaveController = WaveChartController(
    maxDataPoints: 60,
    minY: 0,
    maxY: 100000,
  );
  final bciLowBetaWaveController = WaveChartController(
    maxDataPoints: 60,
    minY: 0,
    maxY: 100000,
  );
  final bciHighBetaWaveController = WaveChartController(
    maxDataPoints: 60,
    minY: 0,
    maxY: 100000,
  );
  final bciLowGammaWaveController = WaveChartController(
    maxDataPoints: 60,
    minY: 0,
    maxY: 100000,
  );
  final bciMiddleGammaWaveController = WaveChartController(
    maxDataPoints: 60,
    minY: 0,
    maxY: 100000,
  );
  final bciTemperatureWaveController = WaveChartController(
    maxDataPoints: 60,
    minY: 0,
    maxY: 50,
  );
  final bciHeartRateWaveController = WaveChartController(
    maxDataPoints: 60,
    minY: 0,
    maxY: 200,
  );
  final bciGrindWaveController = WaveChartController(
    maxDataPoints: 60,
    minY: 0,
    maxY: 2,
  );

  void _showRealData() {
    bciAttWaveController.addDataPoint(bciAtt.value);
    bciMedWaveController.addDataPoint(bciMed.value);
    bciApWaveController.addDataPoint(bciAp.value);
    bciDeltaWaveController.addDataPoint(bciDelta.value);
    bciThetaWaveController.addDataPoint(bciTheta.value);
    bciLowAlphaWaveController.addDataPoint(bciLowAlpha.value);
    bciHighAlphaWaveController.addDataPoint(bciHighAlpha.value);
    bciLowBetaWaveController.addDataPoint(bciLowBeta.value);
    bciHighBetaWaveController.addDataPoint(bciHighBeta.value);
    bciLowGammaWaveController.addDataPoint(bciLowGamma.value);
    bciMiddleGammaWaveController.addDataPoint(bciMiddleGamma.value);
    bciTemperatureWaveController.addDataPoint(bciTemperature.value);
    bciHeartRateWaveController.addDataPoint(bciHeartRate.value);
    bciGrindWaveController.addDataPoint(bciGrind.value);
  }

  @override
  void onInit() {
    super.onInit();
    _initWhileTrue();
    _streamSubscription = eventChannel.receiveBroadcastStream().listen((data) {
      receivedData.value = data.toString();
      List<String> temp = data.toString().split(',');
      if (temp.length == 17) {
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
        bciHrv.value = temp[13];
        bciOygen.value = temp[14];
        bciGrind.value = double.parse(temp[15]);
        bciCurrentTimeMillis.value = int.parse(temp[16]);
        bciCurrentTwoTimeMillis[1] = bciCurrentTimeMillis.value;
        _showRealData();
        _ctrlByDevice();
      }
    }, onError: (error) {});
  }

  @override
  void onClose() {
    _streamSubscription?.cancel();
    _whileTrue.cancel();
    super.onClose();
  }
}
