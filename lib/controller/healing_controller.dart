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
  final RxBool isCtrlByDevice = true.obs;
  final RxBool isDeviceLinking = false.obs;
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

  //实时脑波数据
  final RxDouble bciAtt = 0.0.obs; //专注度
  final RxDouble bciMed = 0.0.obs; //安全感
  final RxDouble bciAp = 0.0.obs; //愉悦度，全息能量
  //
  final RxDouble bciDelta = 0.0.obs;
  final RxDouble bciTheta = 0.0.obs;
  final RxDouble bciLowAlpha = 0.0.obs;
  final RxDouble bciHighAlpha = 0.0.obs;
  final RxDouble bciLowBeta = 0.0.obs;
  final RxDouble bciHighBeta = 0.0.obs;
  final RxDouble bciLowGamma = 0.0.obs;
  final RxDouble bciMiddleGamma = 0.0.obs;
  //
  final RxDouble bciTemperature = 0.0.obs;
  final RxDouble bciHeartRate = 0.0.obs; //心率
  final RxDouble bciGrind = 0.0.obs;
  final RxInt bciCurrentTimeMillis = 0.obs; //时间戳

  //实时hrv数据
  final RxList<double> hrvRR = <double>[].obs;
  final RxDouble hrvLFHF = 0.0.obs; //LFHF,动力能力
  final RxDouble hrvNN = 0.0.obs; //NN50,幸福能量
  //缓存hrv数据
  final List<double> _hrvData = [];

  /// 基于实时脑波数据的简单实时情绪数据（非统计）
  final RxDouble curRelax = 0.0.obs; //松弛感
  final RxDouble curFlow = 0.0.obs; //心流指数

  final HemController hemController = Get.put(HemController());
  final EnvController envController = Get.put(EnvController());
  final BgmController bgmController = Get.put(BgmController());
  final BbmController bbmController = Get.put(BbmController());

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
    const seconds = Duration(seconds: 1);
    _whileTrue = Timer.periodic(seconds, (Timer timer) {
      // if (bciCurrentTwoTimeMillis[1] != bciCurrentTwoTimeMillis[0]) {
      //   isDeviceLinking.value = true;
      //   bciCurrentTwoTimeMillis[0] = bciCurrentTwoTimeMillis[1];
      // } else {
      //   isDeviceLinking.value = false;
      // }
      // if (isRecordData.value && customerCheckSeconds.value > 0) {
      //   customerCheckSeconds.value = customerCheckSeconds.value - 1;
      // }
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
    maxY: 100,
  );
  final hrvLFHFWaveController = WaveChartController(
    minY: 0,
    maxY: 100,
  );
  final hrvNNWaveController = WaveChartController(
    minY: 0,
    maxY: 100,
  );
  final energyWaveController = WaveChart7Controller(
    minY: 0,
    maxY: 1,
  );

  ///
  final bci8WaveController = WaveChart8Controller(
    minY: 0,
    maxY: 1,
  );
  final bciDeltaWaveController = WaveChartController(
    minY: 0,
    maxY: 1,
  );
  final bciThetaWaveController = WaveChartController(
    minY: 0,
    maxY: 1,
  );
  final bciLowAlphaWaveController = WaveChartController(
    minY: 0,
    maxY: 1,
  );
  final bciHighAlphaWaveController = WaveChartController(
    minY: 0,
    maxY: 1,
  );
  final bciLowBetaWaveController = WaveChartController(
    minY: 0,
    maxY: 1,
  );
  final bciHighBetaWaveController = WaveChartController(
    minY: 0,
    maxY: 1,
  );
  final bciLowGammaWaveController = WaveChartController(
    minY: 0,
    maxY: 1,
  );
  final bciMiddleGammaWaveController = WaveChartController(
    minY: 0,
    maxY: 1,
  );

  ///
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

  Future<void> _showRealData() async {
    ///用于动态显示的心流指数、松弛感
    await curRelaxWaveController.addDataPoint(curRelax.value);
    await curFlowWaveController.addDataPoint(curFlow.value);

    ///专注度、安全感、愉悦度
    await bciAttWaveController.addDataPoint(bciAtt.value);
    await bciMedWaveController.addDataPoint(bciMed.value);
    await bciApWaveController.addDataPoint(bciAp.value);

    ///用于动态显示的实时脑波数据
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
    double x = 0.0;
    x = bciDelta.value;
    await bci8WaveController.addDataPoint(bci8WaveController.dataFlSpot7, x);
    x = bciTheta.value;
    await bci8WaveController.addDataPoint(bci8WaveController.dataFlSpot6, x);
    x = bciLowAlpha.value;
    await bci8WaveController.addDataPoint(bci8WaveController.dataFlSpot5, x);
    x += bciHighAlpha.value;
    await bci8WaveController.addDataPoint(bci8WaveController.dataFlSpot4, x);
    x += bciLowBeta.value;
    await bci8WaveController.addDataPoint(bci8WaveController.dataFlSpot3, x);
    x += bciHighBeta.value;
    await bci8WaveController.addDataPoint(bci8WaveController.dataFlSpot2, x);
    x += bciLowGamma.value;
    await bci8WaveController.addDataPoint(bci8WaveController.dataFlSpot1, x);
    x += bciMiddleGamma.value;
    await bci8WaveController.addDataPoint(bci8WaveController.dataFlSpot0, x);
    if (bci8WaveController.dataFlSpot0.length > 600) {
      await bci8WaveController.clearData();
    }

    ///用于动态显示的实时hrv数据
    for (double item in hrvRR) {
      await hrvRRWaveController.addDataPoint(item);
    }
    //NN50,LFHF
    await hrvLFHFWaveController.addDataPoint(hrvLFHF.value);
    await hrvNNWaveController.addDataPoint(hrvNN.value);
    //
    double et = 0.0;
    et = bciAp.value +
        curRelax.value +
        curFlow.value +
        bciAtt.value +
        bciMed.value +
        hrvNN.value +
        hrvLFHF.value;
    if (et > 0) {
      double e = 0.0;
      e += hrvLFHF.value;
      await energyWaveController.addDataPoint(
          energyWaveController.dataFlSpot6, e / et);
      e += hrvNN.value;
      await energyWaveController.addDataPoint(
          energyWaveController.dataFlSpot5, e / et);
      e += bciMed.value;
      await energyWaveController.addDataPoint(
          energyWaveController.dataFlSpot4, e / et);
      e += bciAtt.value;
      await energyWaveController.addDataPoint(
          energyWaveController.dataFlSpot3, e / et);
      e += curFlow.value;
      await energyWaveController.addDataPoint(
          energyWaveController.dataFlSpot2, e / et);
      e += curRelax.value;
      await energyWaveController.addDataPoint(
          energyWaveController.dataFlSpot1, e / et);
      e += bciAp.value;
      await energyWaveController.addDataPoint(
          energyWaveController.dataFlSpot0, e / et);
    }
    if (energyWaveController.dataFlSpot0.length > 600) {
      await energyWaveController.clearData();
    }
  }

  Future<void> clearData() async {
    ///清空用于动态显示的实时脑波数据缓存
    await curRelaxWaveController.clearData();
    await curFlowWaveController.clearData();
    await bciAttWaveController.clearData();
    await bciMedWaveController.clearData();
    await bciApWaveController.clearData();
    //
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
//
    await bci8WaveController.clearData();

    ///清空用于动态显示的实时hrv数据缓存
    await hrvRRWaveController.clearData();
    //
    await hrvLFHFWaveController.clearData();
    await hrvNNWaveController.clearData();
    //
    await energyWaveController.clearData();
  }

  @override
  void onInit() {
    super.onInit();
    _initWhileTrue();
    _bciAndHrvBroadcastListener =
        eventChannel.receiveBroadcastStream().listen((data) async {
      isDeviceLinking.value = !isDeviceLinking.value;
      List<String> temp = data.toString().split('_');
      if (temp.length == 2) {
        if (temp[0] == "bci") {
          temp = temp[1].split(',');
          if (temp.length == 15) {
            bciAtt.value = double.parse(temp[0]);
            bciMed.value = double.parse(temp[1]);
            bciAp.value = double.parse(temp[2]);
            // bciDelta.value = double.parse(temp[3]);
            // bciTheta.value = double.parse(temp[4]);
            // bciLowAlpha.value = double.parse(temp[5]);
            // bciHighAlpha.value = double.parse(temp[6]);
            // bciLowBeta.value = double.parse(temp[7]);
            // bciHighBeta.value = double.parse(temp[8]);
            // bciLowGamma.value = double.parse(temp[9]);
            // bciMiddleGamma.value = double.parse(temp[10]);
            bciTemperature.value = double.parse(temp[11]);
            bciHeartRate.value = double.parse(temp[12]);
            bciGrind.value = double.parse(temp[13]);
            bciCurrentTimeMillis.value = int.parse(temp[14]);
//
            double bs = double.parse(temp[3]) +
                double.parse(temp[4]) +
                double.parse(temp[5]) +
                double.parse(temp[6]) +
                double.parse(temp[7]) +
                double.parse(temp[8]) +
                double.parse(temp[9]) +
                double.parse(temp[10]);
            if (bs > 0) {
              bciDelta.value = double.parse(temp[3]) / bs;
              bciTheta.value = double.parse(temp[4]) / bs;
              bciLowAlpha.value = double.parse(temp[5]) / bs;
              bciHighAlpha.value = double.parse(temp[6]) / bs;
              bciLowBeta.value = double.parse(temp[7]) / bs;
              bciHighBeta.value = double.parse(temp[8]) / bs;
              bciLowGamma.value = double.parse(temp[9]) / bs;
              bciMiddleGamma.value = double.parse(temp[10]) / bs;
            }
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
            if (_hrvData.length > 600) {
              _hrvData.removeRange(0, 300);
            }
          }
        }
        if (_hrvData.length > 10) {
          List<double> p = Data.calculateLFHF(_hrvData);
          double p3 = p[3] > 5 ? 5 : p[3];
          hrvLFHF.value = (5 - p3) * 20;
        }
        if (_hrvData.length > 2) {
          double nn =
              (_hrvData[_hrvData.length - 1] - _hrvData[_hrvData.length - 2])
                  .abs();
          nn = nn > 50 ? 50 : nn;
          hrvNN.value = (nn / 50) * 100;
        }

        ///
        curRelax.value = 0.5 * (100 - bciAtt.value) + 0.5 * bciMed.value;
        curFlow.value = 0.5 * bciAtt.value + 0.5 * bciMed.value;
        double bt = bciLowBeta.value + bciHighBeta.value;
        if (bt > 0) {
          double ap = bciTheta.value / bt;
          ap = ap > 5 ? 5 : ap;
          bciAp.value = ap * 20;
        }

        ///
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
}
