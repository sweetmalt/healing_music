import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

class WaveChartController extends GetxController {
  static const int maxDataPoints = 60;
  final double minY;
  final double maxY;
  final RxList<FlSpot> dataFlSpot = <FlSpot>[].obs;
  final List<double> _data = [];
  final List<double> bestLimits = [60, 100]; //最佳值范围
  double statisticsBestScaling = 0; //最佳值占比
  double statisticsMin = 0; //最小值
  double statisticsMax = 0; //最大值
  double statisticsRange = 0; //大小差
  double statisticsMean = 0; //均值
  double statisticsMeanPosition = 0; //均值排位
  double statisticsMeanDifference = 0; //标准差
  double statisticsMeanInterfacingDifference = 0; //邻差均方根
  double statisticsMeanInterfacing50Scaling = 0; //邻差>50的占比
  double statisticsMode = 0; //众数
  double statisticsModePosition = 0; //众数排位
  double statisticsModeScaling = 0; //众数占比
  double statisticsMedian = 0; //中位数
  double statisticsMedianPosition = 0; //中位数排位
  double statisticsCount = 0; //数据样本点数量，记录时长

  double minX = 0;
  double maxX = 1;

  WaveChartController({
    required this.minY,
    required this.maxY,
  });

  @override
  void onInit() {
    super.onInit();
    dataFlSpot.add(const FlSpot(0, 0));
    minX = 0;
    maxX = 1;
  }

  @override
  void onClose() {
    super.onClose();
    dataFlSpot.clear();
    _data.clear();
  }

  Future<void> clearData() async {
    _data.clear();
    statisticsCount = 0;
    dataFlSpot.clear();
    dataFlSpot.add(const FlSpot(0, 0));
    minX = 0;
    maxX = 1;
  }

  List<double> data() {
    return _data;
  }

  Future<void> setBestLimits(double min, double max) async {
    bestLimits[0] = min;
    bestLimits[1] = max;
  }

  /// 基于rr间期值数组的心率变异性hrv数据的频域分析（Frequency-Domain Analysis）
  /// 通过功率谱密度（PSD）计算不同频段的能量分布：
  /// 总功率（TP）
  /// 总频段（通常 ≤0.4 Hz）的功率：
  /// TP=∫00.4P(f)dfTP=∫00.4P(f)df
  /// 低频功率（LF, 0.04–0.15 Hz）
  /// LF=∫0.040.15P(f)dfLF=∫0.040.15P(f)df
  /// 高频功率（HF, 0.15–0.4 Hz）
  /// HF=∫0.150.4P(f)dfHF=∫0.150.4P(f)df
  /// LF/HF 比值
  /// 反映交感与副交感神经平衡：
  /// LFHF=LF功率HF功率HFLF=HF功率LF功率
  Future<void> statisticsHrv() async {}

  Future<void> statistics() async {
    // if (_data.length < 60) {
    //   return;
    // }
    statisticsBestScaling =
        _data.where((x) => (x >= bestLimits[0] && x <= bestLimits[1])).length /
            _data.length;
    statisticsMin = _data.reduce((a, b) => a < b ? a : b);
    statisticsMax = _data.reduce((a, b) => a > b ? a : b);
    statisticsRange = statisticsMax - statisticsMin;
    statisticsMean = _data.reduce((a, b) => a + b) / _data.length;

    double sumOfDifferences = 0.0;
    //计算标准差
    for (int i = 0; i < _data.length; i++) {
      sumOfDifferences += math.pow(_data[i] - statisticsMean, 2);
    }
    statisticsMeanDifference = math.sqrt(sumOfDifferences / _data.length);
    sumOfDifferences = 0.0;
    // 计算均方根
    for (int i = 1; i < _data.length; i++) {
      sumOfDifferences += math.pow((_data[i] - _data[i - 1]), 2);
    }
    statisticsMeanInterfacingDifference =
        math.sqrt(sumOfDifferences / (_data.length - 1));
    //邻差>50的占比
    sumOfDifferences = 0.0;
    for (int i = 1; i < _data.length; i++) {
      if (_data[i] - _data[i - 1] > 50 || _data[i] - _data[i - 1] < -50) {
        sumOfDifferences++;
      }
    }
    statisticsMeanInterfacing50Scaling = sumOfDifferences / (_data.length - 1);
    statisticsMode = _data.reduce((a, b) =>
        _data.where((x) => x == a).length > _data.where((x) => x == b).length
            ? a
            : b);
    statisticsMedian = _data[_data.length ~/ 2];
    if (statisticsRange > 0) {
      statisticsMeanPosition =
          (statisticsMean - statisticsMin) / statisticsRange;
    }
    if (statisticsRange > 0) {
      statisticsModePosition =
          (statisticsMode - statisticsMin) / statisticsRange;
    }
    statisticsModeScaling =
        _data.where((x) => x == statisticsMode).length / _data.length;
    if (statisticsRange > 0) {
      statisticsMedianPosition =
          (statisticsMedian - statisticsMin) / statisticsRange;
    }
    statisticsCount = _data.length.toDouble();
  }

  Future<void> addDataPoint(double value) async {
    if (value >= minY && value <= maxY) {
      _data.add(value);
      dataFlSpot.add(FlSpot(maxX, value));
      maxX = dataFlSpot.length.toDouble();
      if (maxX - minX > maxDataPoints) {
        minX = maxX - maxDataPoints;
      }
      if (dataFlSpot.length >= 900) {
        _data.removeRange(0, 600);
        dataFlSpot.removeRange(0, 600);
        for (int i = 0; i < dataFlSpot.length; i++) {
          dataFlSpot[i] = FlSpot(i.toDouble(), dataFlSpot[i].y);
        }
        maxX = dataFlSpot.length.toDouble();
        minX = maxX - maxDataPoints;
      }
      update();
    }
  }
}

class WaveChartStatistics extends StatelessWidget {
  final WaveChartController controller;

  const WaveChartStatistics({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 3),
        //color: ThemeData().colorScheme.primaryContainer,
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        ListTile(
          title: Text(
              "高光时段占比 ${(controller.statisticsBestScaling * 10000).toInt() / 10000}"),
          subtitle: const Text("bestScaling"),
        ),
        StatisticsContainerCircle("高光时刻", controller.statisticsBestScaling),
        Container(
          height: 40,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 20, bottom: 40),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: const Text("高光时段占比越大，对疗愈的价值贡献越高"),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            StatisticsContainerCircleMini(
              "最小值",
              controller.statisticsMin,
              false,
            ),
            StatisticsContainerCircleMini(
              "最大值",
              controller.statisticsMax,
              false,
            ),
            StatisticsContainerCircleMini(
              "波动范围",
              controller.statisticsRange,
              false,
            )
          ],
        ),
        Container(
          height: 40,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 20, bottom: 40),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: const Text("波动范围越小，表示越稳定"),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Column(
            children: [
              StatisticsContainerCircleMini(
                "均值",
                controller.statisticsMean,
                false,
              ),
              StatisticsContainerCircleMini(
                "均值排位",
                controller.statisticsMeanPosition,
                true,
              ),
            ],
          ),
          Column(children: [
            StatisticsContainerCircleMini(
              "众数",
              controller.statisticsMode,
              false,
            ),
            StatisticsContainerCircleMini(
              "众数排位",
              controller.statisticsModePosition,
              true,
            ),
            StatisticsContainerCircleMini(
              "众数占比",
              controller.statisticsModeScaling,
              true,
            ),
          ]),
          Column(children: [
            StatisticsContainerCircleMini(
              "中位数",
              controller.statisticsMedian,
              false,
            ),
            StatisticsContainerCircleMini(
              "中位数排位",
              controller.statisticsMedianPosition,
              true,
            ),
          ]),
        ]),
        Container(
          height: 40,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 20, bottom: 40),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: const Text("众数占比越大，表示越稳定"),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          StatisticsContainerCircleMini(
            "标准差SDNN",
            controller.statisticsMeanDifference,
            false,
          ),
          controller.statisticsMeanInterfacing50Scaling > 0
              ? StatisticsContainerCircleMini(
                  "NN50",
                  controller.statisticsMeanInterfacing50Scaling,
                  true,
                )
              : Container(),
          StatisticsContainerCircleMini(
            "均方根RMSSD",
            controller.statisticsMeanInterfacingDifference,
            false,
          ),
        ]),
        Container(
          height: 40,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 20, bottom: 40),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: const Text("标准差和均方根越小，表示越稳定"),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          StatisticsContainerCircleMini(
              "数据样本量", controller.statisticsCount, false),
        ]),
      ]),
    );
  }
}

class StatisticsContainerCircle extends Container {
  final String title;
  final double value;
  StatisticsContainerCircle(this.title, this.value, {super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
        width: 160,
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80),
        ),
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
          valueColor:
              AlwaysStoppedAnimation<Color>(ThemeData().colorScheme.primary),
          value: value,
          strokeWidth: 10,
        ),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${(value * 10000).toInt() / 100}%',
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              )),
          Text(
            title,
          ),
        ],
      ),
    ]);
  }
}

class StatisticsContainerCircleMini extends Container {
  final String title;
  final double value;
  final bool isShowAsScaling;
  StatisticsContainerCircleMini(this.title, this.value, this.isShowAsScaling,
      {super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Container(
        width: 100,
        height: 100,
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
        ),
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
          valueColor:
              AlwaysStoppedAnimation<Color>(ThemeData().colorScheme.primary),
          value: 1,
          strokeWidth: 2,
        ),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isShowAsScaling == true)
            Text('${(value * 10000).toInt() / 100}%',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ))
          else
            Text('${(value * 100).toInt() / 100}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
          Text(
            title,
          ),
        ],
      ),
    ]);
  }
}

class WaveChart extends StatelessWidget {
  final WaveChartController controller;
  final Color lineColor;
  final double lineWidth;

  const WaveChart({
    super.key,
    required this.controller,
    this.lineColor = Colors.blue,
    this.lineWidth = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ThemeData().colorScheme.primary),
          color: ThemeData().colorScheme.primaryContainer,
        ),
        child: Obx(() => LineChart(
              LineChartData(
                gridData: const FlGridData(show: true),
                titlesData: const FlTitlesData(show: true),
                borderData: FlBorderData(show: false),
                minX: controller.minX,
                maxX: controller.maxX,
                minY: controller.minY,
                maxY: controller.maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: controller.dataFlSpot,
                    isCurved: true,
                    curveSmoothness: 0.5,
                    color: lineColor,
                    barWidth: lineWidth,
                    preventCurveOverShooting: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: true),
                    isStepLineChart: false,
                    isStrokeCapRound: true,
                  ),
                ],
              ),
            )));
  }
}
