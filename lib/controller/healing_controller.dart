import 'dart:async';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:healing_music/widget/wave_chart.dart';
import 'package:just_audio/just_audio.dart';

class HealingController extends GetxController {
  AudioPlayer singlePlayer = AudioPlayer();
  final RxString title = '能量驿站'.obs;
  final RxBool isMute = false.obs;
  final RxBool isCtrlByDevice = false.obs;
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
  final RxString bciHrv = "0".obs;//hrv数组字符串
  final RxDouble bciGrind = 0.0.obs;
  final RxDouble bciCurrentTimeMillis = 0.0.obs;

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
    _streamSubscription = eventChannel.receiveBroadcastStream().listen((data) {
      receivedData.value = data.toString();
      List<String> temp = data.toString().split(',');
      if (temp.length == 16) {
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
        bciGrind.value = double.parse(temp[14]);
        bciCurrentTimeMillis.value = double.parse(temp[15]);

        _showRealData();
      }
    }, onError: (error) {});
  }

  @override
  void onClose() {
    _streamSubscription?.cancel();
    super.onClose();
  }
}
