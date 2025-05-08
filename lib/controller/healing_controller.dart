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
  final RxBool isRecordData = false.obs;
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

  /// 用于缓存历史脑波数据、hrv数据（30~60分钟）
  final List<String> _bciData = <String>[""];
  final List<double> _hrvData = <double>[];

  final List<double> _bciDataAtt = <double>[];
  final List<double> _bciDataMed = <double>[];
  final List<double> _bciDataAp = <double>[];
  final List<double> _bciDataDelta = <double>[];
  final List<double> _bciDataTheta = <double>[];
  final List<double> _bciDataLowAlpha = <double>[];
  final List<double> _bciDataHighAlpha = <double>[];
  final List<double> _bciDataLowBeta = <double>[];
  final List<double> _bciDataHighBeta = <double>[];
  final List<double> _bciDataLowGamma = <double>[];
  final List<double> _bciDataMiddleGamma = <double>[];
  final List<double> _bciDataTemperature = <double>[];
  final List<double> _bciDataHeartRate = <double>[];
  final List<double> _bciDataGrind = <double>[];

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
  final RxInt customerAge = 18.obs;
  final RxInt customerSex = 1.obs;
  final RxString customerSleepP2Q1 = ''.obs;
  List<String> customerSleepP2Q1_ = ["10分钟", "10~30分钟", "30~60分钟", "1小时以上"];
  final RxString customerSleepP2Q2 = ''.obs;
  Map<String, bool> customerSleepP2Q2_ = {
    "夜间易醒且难以再次入睡": false,
    "早醒（比预期早1小时以上）": false,
    "白天疲劳感明显": false,
    "睡眠浅、易受环境影响": false
  };
  final RxString customerSleepP2Q3 = ''.obs;
  List<String> customerSleepP2Q3_ = ["非常满意", "较满意", "一般", "不满意", "非常不满意"];
  final RxString customerSleepP3Q1 = ''.obs;
  Map<String, bool> customerSleepP3Q1_ = {
    "工作/学业": false,
    "家庭关系": false,
    "经济问题": false,
    "健康问题": false,
    "社交或情感关系": false
  };
  final RxString customerSleepP3Q2 = ''.obs;
  Map<String, bool> customerSleepP3Q2_ = {
    "烦躁易怒": false,
    "注意力难以集中": false,
    "对日常活动兴趣下降": false,
    "身体紧绷或肌肉酸痛": false
  };
  final RxInt customerCheckSeconds = 180.obs;

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
      if (bciCurrentTwoTimeMillis[1] != bciCurrentTwoTimeMillis[0]) {
        isDeviceLinking.value = true;
        bciCurrentTwoTimeMillis[0] = bciCurrentTwoTimeMillis[1];
      } else {
        isDeviceLinking.value = false;
      }
      if (isRecordData.value && customerCheckSeconds.value > 0) {
        customerCheckSeconds.value = customerCheckSeconds.value - 1;
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

  ///计算心流指数、敏锐度、松弛感
  Future<void> _dataAnalysis() async {
    curRelax.value = 0.5 * (100 - bciAtt.value) + 0.5 * bciMed.value;
    curSharp.value = 0.5 * bciAtt.value + 0.5 * (100 - bciMed.value);
    curFlow.value = 0.5 * bciAtt.value + 0.5 * bciMed.value;
  }

  Future<void> _showRealData() async {
    ///用于动态显示的心流指数、敏锐度、松弛感
    await curRelaxWaveController.addDataPoint(curRelax.value);
    await curSharpWaveController.addDataPoint(curSharp.value);
    await curFlowWaveController.addDataPoint(curFlow.value);

    ///用于动态显示的实时脑波数据
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

    ///用于动态显示的实时hrv数据
    for (double item in hrvRR) {
      await hrvRRWaveController.addDataPoint(item);
    }
  }

  Future<void> clearData() async {
    ///清空脑波数据缓存
    _bciData.clear();
    _bciDataAtt.clear();
    _bciDataMed.clear();
    _bciDataAp.clear();
    _bciDataDelta.clear();
    _bciDataTheta.clear();
    _bciDataLowAlpha.clear();
    _bciDataHighAlpha.clear();
    _bciDataLowBeta.clear();
    _bciDataHighBeta.clear();
    _bciDataLowGamma.clear();
    _bciDataMiddleGamma.clear();
    _bciDataTemperature.clear();
    _bciDataHeartRate.clear();
    _bciDataGrind.clear();

    ///清空hrv数据缓存
    _hrvData.clear();

    ///清空60秒实时脑波数据缓存
    _bciDeltaHistory60.clear();
    _bciThetaHistory60.clear();
    _bciLowAlphaHistory60.clear();
    _bciHighAlphaHistory60.clear();
    _bciLowBetaHistory60.clear();
    _bciHighBetaHistory60.clear();
    _bciGammaHistory60.clear();

    ///清空用于动态显示的实时脑波数据缓存
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

    ///清空用于动态显示的实时hrv数据缓存
    await hrvRRWaveController.clearData();
  }

  List<String> get bciData {
    return _bciData;
  }

  List<double> get bciDataAtt {
    return _bciDataAtt;
  }

  List<double> get bciDataMed {
    return _bciDataMed;
  }

  List<double> get bciDataAp {
    return _bciDataAp;
  }

  List<double> get bciDataDelta {
    return _bciDataDelta;
  }

  List<double> get bciDataTheta {
    return _bciDataTheta;
  }

  List<double> get bciDataLowAlpha {
    return _bciDataLowAlpha;
  }

  List<double> get bciDataHighAlpha {
    return _bciDataHighAlpha;
  }

  List<double> get bciDataLowBeta {
    return _bciDataLowBeta;
  }

  List<double> get bciDataHighBeta {
    return _bciDataHighBeta;
  }

  List<double> get bciDataLowGamma {
    return _bciDataLowGamma;
  }

  List<double> get bciDataMiddleGamma {
    return _bciDataMiddleGamma;
  }

  List<double> get bciDataTemperature {
    return _bciDataTemperature;
  }

  List<double> get bciDataHeartRate {
    return _bciDataHeartRate;
  }

  List<double> get bciDataGrind {
    return _bciDataGrind;
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
      if (isRecordData.value == false) {
        return;
      }
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
            _bciData.length > 3600 ? _bciData.removeRange(0, 1800) : () {};

            _bciDataAtt.add(bciAtt.value);
            _bciDataAtt.length > 3600
                ? _bciDataAtt.removeRange(0, 1800)
                : () {};

            _bciDataMed.add(bciMed.value);
            _bciDataMed.length > 3600
                ? _bciDataMed.removeRange(0, 1800)
                : () {};

            _bciDataAp.add(bciAp.value);
            _bciDataAp.length > 3600 ? _bciDataAp.removeRange(0, 1800) : () {};

            _bciDataDelta.add(bciDelta.value);
            _bciDataDelta.length > 3600
                ? _bciDataDelta.removeRange(0, 1800)
                : () {};

            _bciDataTheta.add(bciTheta.value);
            _bciDataTheta.length > 3600
                ? _bciDataTheta.removeRange(0, 1800)
                : () {};

            _bciDataLowAlpha.add(bciLowAlpha.value);
            _bciDataLowAlpha.length > 3600
                ? _bciDataLowAlpha.removeRange(0, 1800)
                : () {};

            _bciDataHighAlpha.add(bciHighAlpha.value);
            _bciDataHighAlpha.length > 3600
                ? _bciDataHighAlpha.removeRange(0, 1800)
                : () {};

            _bciDataLowBeta.add(bciLowBeta.value);
            _bciDataLowBeta.length > 3600
                ? _bciDataLowBeta.removeRange(0, 1800)
                : () {};

            _bciDataHighBeta.add(bciHighBeta.value);
            _bciDataHighBeta.length > 3600
                ? _bciDataHighBeta.removeRange(0, 1800)
                : () {};

            _bciDataLowGamma.add(bciLowGamma.value);
            _bciDataLowGamma.length > 3600
                ? _bciDataLowGamma.removeRange(0, 1800)
                : () {};

            _bciDataMiddleGamma.add(bciMiddleGamma.value);
            _bciDataMiddleGamma.length > 3600
                ? _bciDataMiddleGamma.removeRange(0, 1800)
                : () {};

            _bciDataTemperature.add(bciTemperature.value);
            _bciDataTemperature.length > 3600
                ? _bciDataTemperature.removeRange(0, 1800)
                : () {};

            _bciDataHeartRate.add(bciHeartRate.value);
            _bciDataHeartRate.length > 3600
                ? _bciDataHeartRate.removeRange(0, 1800)
                : () {};

            _bciDataGrind.add(bciGrind.value);
            _bciDataGrind.length > 3600
                ? _bciDataGrind.removeRange(0, 1800)
                : () {};

            //最近60条数据的平均值
            //1 bciDelta
            double sx = 100000;
            _bciDeltaHistory60.add(bciDelta.value > sx ? sx : bciDelta.value);
            _bciDeltaHistory60.length > 60
                ? _bciDeltaHistory60.removeAt(0)
                : () {};
            double xBcidelta = _bciDeltaHistory60.reduce((a, b) => a + b);
            //2 bciTheta
            _bciThetaHistory60
                .add((bciTheta.value > sx ? sx : bciTheta.value) * 2);
            _bciThetaHistory60.length > 60
                ? _bciThetaHistory60.removeAt(0)
                : () {};
            double xBcitheta = _bciThetaHistory60.reduce((a, b) => a + b);
            //3 bciLowAlpha
            _bciLowAlphaHistory60
                .add((bciLowAlpha.value > sx ? sx : bciLowAlpha.value) * 3);
            _bciLowAlphaHistory60.length > 60
                ? _bciLowAlphaHistory60.removeAt(0)
                : () {};
            double xBcilowalpha = _bciLowAlphaHistory60.reduce((a, b) => a + b);
            //4 bciHighAlpha
            _bciHighAlphaHistory60
                .add((bciHighAlpha.value > sx ? sx : bciHighAlpha.value) * 4);
            _bciHighAlphaHistory60.length > 60
                ? _bciHighAlphaHistory60.removeAt(0)
                : () {};
            double xBcihighalpha =
                _bciHighAlphaHistory60.reduce((a, b) => a + b);
            //5 bciLowBeta
            _bciLowBetaHistory60
                .add((bciLowBeta.value > sx ? sx : bciLowBeta.value) * 7);
            _bciLowBetaHistory60.length > 60
                ? _bciLowBetaHistory60.removeAt(0)
                : () {};
            double xBcilowbeta = _bciLowBetaHistory60.reduce((a, b) => a + b);
            //6 bciHighBeta
            _bciHighBetaHistory60
                .add((bciHighBeta.value > sx ? sx : bciHighBeta.value) * 6);
            _bciHighBetaHistory60.length > 60
                ? _bciHighBetaHistory60.removeAt(0)
                : () {};
            double xBcihighbeta = _bciHighBetaHistory60.reduce((a, b) => a + b);
            //7 bciLowGamma
            _bciGammaHistory60
                .add((bciLowGamma.value > sx ? sx : bciLowGamma.value) * 13);
            _bciGammaHistory60.length > 60
                ? _bciGammaHistory60.removeAt(0)
                : () {};
            double xBcigamma = _bciGammaHistory60.reduce((a, b) => a + b);

            ///计算60秒的平均脑波数据
            double xAll = xBcidelta +
                xBcitheta +
                xBcilowalpha +
                xBcihighalpha +
                xBcilowbeta +
                xBcihighbeta +
                xBcigamma;
            if (xAll > 0) {
              bciDeltaHistory60Mean.value = xBcidelta / xAll;
              bciThetaHistory60Mean.value = xBcitheta / xAll;
              bciLowAlphaHistory60Mean.value = xBcilowalpha / xAll;
              bciHighAlphaHistory60Mean.value = xBcihighalpha / xAll;
              bciLowBetaHistory60Mean.value = xBcilowbeta / xAll;
              bciHighBetaHistory60Mean.value = xBcihighbeta / xAll;
              bciGammaHistory60Mean.value = xBcigamma / xAll;
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
            _hrvData.length > 3600 ? _hrvData.removeRange(0, 1800) : () {};
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

  Future<void> statisticsHrv() async {
    if (_hrvData.length < 10) {
      return;
    }
    List<double> p = Data.calculateLFHF(_hrvData);
    hrvTP.value = p[0];
    hrvLF.value = p[1];
    hrvHF.value = p[2];
    hrvLFHF.value = p[3];
  }
}
