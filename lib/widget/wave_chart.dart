import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:healing_music/page/main_page.dart';

class WaveChartController extends GetxController {
  static const int maxDataPoints = 20;
  final double minY;
  final double maxY;
  final RxList<FlSpot> dataFlSpot = <FlSpot>[].obs;
  final RxDouble currentValue = 0.0.obs;
  final List<double> _data = [];
  final List<double> bestLimits = [60, 100]; //最佳值范围
  final List<double> betterLimits = [50, 100]; //次佳值范围
  double statisticsBestScaling = 0; //最佳值占比
  double statisticsBetterScaling = 0; //次佳值占比
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
    statisticsCount = 0;
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

  //统一计算全部数据（统计）
  Future<void> setBetterLimits(double min, double max) async {
    betterLimits[0] = min;
    betterLimits[1] = max;
  }

  Future<void> statistics() async {
    if (_data.length < 10) {
      return;
    }
    statisticsBestScaling =
        _data.where((x) => (x >= bestLimits[0] && x <= bestLimits[1])).length /
            _data.length;
    statisticsBetterScaling = _data
            .where((x) => (x >= betterLimits[0] && x <= betterLimits[1]))
            .length /
        _data.length;
    statisticsMin = _data.reduce((a, b) => a < b ? a : b);
    statisticsMax = _data.reduce((a, b) => a > b ? a : b);
    statisticsRange = statisticsMax - statisticsMin;
    //计算平均值
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
    //众数
    statisticsMode = _data.reduce((a, b) =>
        _data.where((x) => x == a).length > _data.where((x) => x == b).length
            ? a
            : b);
    //中位数
    statisticsMedian = _data[_data.length ~/ 2];
    if (statisticsRange > 0) {
      statisticsMeanPosition =
          (statisticsMean - statisticsMin) / statisticsRange;
    }
    //众数排位
    if (statisticsRange > 0) {
      statisticsModePosition =
          (statisticsMode - statisticsMin) / statisticsRange;
    }
    //众数占比
    statisticsModeScaling =
        _data.where((x) => x == statisticsMode).length / _data.length;
    //中位数排位
    if (statisticsRange > 0) {
      statisticsMedianPosition =
          (statisticsMedian - statisticsMin) / statisticsRange;
    }
    //数据样本点数量，记录时长
    statisticsCount = _data.length.toDouble();
  }

  Future<void> addDataPoint(double value) async {
    double v = value;
    if (v < minY) {
      v = minY;
    }
    if (v > maxY) {
      v = maxY;
    }
    _data.add(v);
    if (_data.length > 600) {
      _data.removeRange(0, 300);
    }
    if (dataFlSpot.isEmpty) {
      dataFlSpot.add(const FlSpot(0, 0));
    }
    maxX = dataFlSpot.length.toDouble();
    dataFlSpot.add(FlSpot(maxX, v));
    if (maxX - minX > maxDataPoints) {
      minX = maxX - maxDataPoints;
    }
    if (dataFlSpot.length > 600) {
      clearData();
    }
    update();
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
        StatisticsContainerCircle("高光时段", controller.statisticsBestScaling),
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
          Text('${(value * 10000).toInt() / 100}分',
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
          value: isShowAsScaling ? value : 1,
          strokeWidth: 4,
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
        height: 100,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: ThemeData().colorScheme.primary),
          color: Colors.black,
        ),
        child: Obx(() => LineChart(
              duration: const Duration(milliseconds: 1000),
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minX: controller.minX,
                maxX: controller.maxX,
                minY: controller.minY,
                maxY: controller.maxY,
                lineBarsData: [
                  LineChartBarData(
                    spots: controller.dataFlSpot,
                    isCurved: true,
                    color: lineColor,
                    barWidth: lineWidth,
                    belowBarData: BarAreaData(
                      show: true,
                      color: lineColor,
                    ),
                    dotData: const FlDotData(show: false),
                    isStepLineChart: false,
                  ),
                ],
              ),
            )));
  }
}

class WaveChart8 extends StatelessWidget {
  final WaveChart8Controller controller;
  final double height;
  final RxBool isFlay;

  const WaveChart8({
    super.key,
    required this.controller,
    required this.height,
    required this.isFlay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width - 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black,
      ),
      clipBehavior: Clip.hardEdge,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: true,
        child: Obx(() {
          return SizedBox(
              width: isFlay.value
                  ? context.width + controller.dataFlSpot0.length * 50.0
                  : context.width,
              height: height,
              child: LineChart(
                duration: const Duration(milliseconds: 1000),
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  minY: controller.minY,
                  maxY: controller.maxY,
                  lineBarsData: [
                    LineChartBarData(
                      barWidth: 1,
                      spots: controller.dataFlSpot0,
                      color: colorList[0],
                      isCurved: true,
                      belowBarData: BarAreaData(
                        show: true,
                        color: colorList[0],
                      ),
                      dotData: const FlDotData(show: false),
                      isStepLineChart: false,
                    ),
                    LineChartBarData(
                      barWidth: 1,
                      spots: controller.dataFlSpot1,
                      color: colorList[1],
                      isCurved: true,
                      belowBarData: BarAreaData(
                        show: true,
                        color: colorList[1],
                      ),
                      dotData: const FlDotData(show: false),
                      isStepLineChart: false,
                    ),
                    LineChartBarData(
                      barWidth: 1,
                      spots: controller.dataFlSpot2,
                      color: colorList[2],
                      isCurved: true,
                      belowBarData: BarAreaData(
                        show: true,
                        color: colorList[2],
                      ),
                      dotData: const FlDotData(show: false),
                      isStepLineChart: false,
                    ),
                    LineChartBarData(
                      barWidth: 1,
                      spots: controller.dataFlSpot3,
                      color: colorList[3],
                      isCurved: true,
                      belowBarData: BarAreaData(
                        show: true,
                        color: colorList[3],
                      ),
                      dotData: const FlDotData(show: false),
                      isStepLineChart: false,
                    ),
                    LineChartBarData(
                      barWidth: 1,
                      spots: controller.dataFlSpot4,
                      color: colorList[4],
                      isCurved: true,
                      belowBarData: BarAreaData(
                        show: true,
                        color: colorList[4],
                      ),
                      dotData: const FlDotData(show: false),
                      isStepLineChart: false,
                    ),
                    LineChartBarData(
                      barWidth: 1,
                      spots: controller.dataFlSpot5,
                      color: colorList[5],
                      isCurved: true,
                      belowBarData: BarAreaData(
                        show: true,
                        color: colorList[5],
                      ),
                      dotData: const FlDotData(show: false),
                      isStepLineChart: false,
                    ),
                    LineChartBarData(
                      barWidth: 1,
                      spots: controller.dataFlSpot6,
                      color: colorList[6],
                      isCurved: true,
                      dotData: const FlDotData(show: false),
                      isStepLineChart: false,
                    ),
                    LineChartBarData(
                      barWidth: 1,
                      spots: controller.dataFlSpot7,
                      color: colorList[7],
                      isCurved: true,
                      dotData: const FlDotData(show: false),
                      isStepLineChart: false,
                    ),
                  ],
                ),
              ));
        }),
      ),
    );
  }
}

class WaveChart8Controller extends GetxController {
  final double minY;
  final double maxY;
  final RxList<FlSpot> dataFlSpot0 = <FlSpot>[].obs;
  final RxList<FlSpot> dataFlSpot1 = <FlSpot>[].obs;
  final RxList<FlSpot> dataFlSpot2 = <FlSpot>[].obs;
  final RxList<FlSpot> dataFlSpot3 = <FlSpot>[].obs;
  final RxList<FlSpot> dataFlSpot4 = <FlSpot>[].obs;
  final RxList<FlSpot> dataFlSpot5 = <FlSpot>[].obs;
  final RxList<FlSpot> dataFlSpot6 = <FlSpot>[].obs;
  final RxList<FlSpot> dataFlSpot7 = <FlSpot>[].obs;

  WaveChart8Controller({
    required this.minY,
    required this.maxY,
  });

  @override
  void onInit() {
    super.onInit();
    dataFlSpot0.add(const FlSpot(0, 0));
    dataFlSpot1.add(const FlSpot(0, 0));
    dataFlSpot2.add(const FlSpot(0, 0));
    dataFlSpot3.add(const FlSpot(0, 0));
    dataFlSpot4.add(const FlSpot(0, 0));
    dataFlSpot5.add(const FlSpot(0, 0));
    dataFlSpot6.add(const FlSpot(0, 0));
    dataFlSpot7.add(const FlSpot(0, 0));
  }

  @override
  void onClose() {
    super.onClose();
    dataFlSpot0.clear();
    dataFlSpot1.clear();
    dataFlSpot2.clear();
    dataFlSpot3.clear();
    dataFlSpot4.clear();
    dataFlSpot5.clear();
    dataFlSpot6.clear();
    dataFlSpot7.clear();
  }

  Future<void> clearData() async {
    dataFlSpot0.clear();
    dataFlSpot0.add(const FlSpot(0, 0));
    dataFlSpot1.clear();
    dataFlSpot1.add(const FlSpot(0, 0));
    dataFlSpot2.clear();
    dataFlSpot2.add(const FlSpot(0, 0));
    dataFlSpot3.clear();
    dataFlSpot3.add(const FlSpot(0, 0));
    dataFlSpot4.clear();
    dataFlSpot4.add(const FlSpot(0, 0));
    dataFlSpot5.clear();
    dataFlSpot5.add(const FlSpot(0, 0));
    dataFlSpot6.clear();
    dataFlSpot6.add(const FlSpot(0, 0));
    dataFlSpot7.clear();
    dataFlSpot7.add(const FlSpot(0, 0));
  }

  Future<void> addDataPoint(RxList<FlSpot> dataFlSpot, double value) async {
    double v = value;
    if (v < minY) {
      v = minY;
    }
    if (v > maxY) {
      v = maxY;
    }
    if (dataFlSpot.isEmpty) {
      dataFlSpot.add(const FlSpot(0, 0));
    }
    double x = dataFlSpot.length.toDouble();
    dataFlSpot.add(FlSpot(x, v));
    update();
  }
}


class WaveChart7 extends StatelessWidget {
  final WaveChart7Controller controller;
  final double height;
  final RxBool isFlay;

  const WaveChart7({
    super.key,
    required this.controller,
    required this.height,
    required this.isFlay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width - 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.black,
      ),
      clipBehavior: Clip.hardEdge,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        reverse: true,
        child: Obx(() {
          return SizedBox(
              width: isFlay.value
                  ? context.width + controller.dataFlSpot0.length * 50.0
                  : context.width,
              height: height,
              child: LineChart(
                duration: const Duration(milliseconds: 1000),
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  minY: controller.minY,
                  maxY: controller.maxY,
                  lineBarsData: [
                    LineChartBarData(
                      barWidth: 1,
                      spots: controller.dataFlSpot0,
                      color: colorList[0],
                      isCurved: true,
                      belowBarData: BarAreaData(
                        show: true,
                        color: colorList[0],
                      ),
                      dotData: const FlDotData(show: false),
                      isStepLineChart: false,
                    ),
                    LineChartBarData(
                      barWidth: 1,
                      spots: controller.dataFlSpot1,
                      color: colorList[1],
                      isCurved: true,
                      belowBarData: BarAreaData(
                        show: true,
                        color: colorList[1],
                      ),
                      dotData: const FlDotData(show: false),
                      isStepLineChart: false,
                    ),
                    LineChartBarData(
                      barWidth: 1,
                      spots: controller.dataFlSpot2,
                      color: colorList[2],
                      isCurved: true,
                      belowBarData: BarAreaData(
                        show: true,
                        color: colorList[2],
                      ),
                      dotData: const FlDotData(show: false),
                      isStepLineChart: false,
                    ),
                    LineChartBarData(
                      barWidth: 1,
                      spots: controller.dataFlSpot3,
                      color: colorList[3],
                      isCurved: true,
                      belowBarData: BarAreaData(
                        show: true,
                        color: colorList[3],
                      ),
                      dotData: const FlDotData(show: false),
                      isStepLineChart: false,
                    ),
                    LineChartBarData(
                      barWidth: 1,
                      spots: controller.dataFlSpot4,
                      color: colorList[4],
                      isCurved: true,
                      belowBarData: BarAreaData(
                        show: true,
                        color: colorList[4],
                      ),
                      dotData: const FlDotData(show: false),
                      isStepLineChart: false,
                    ),
                    LineChartBarData(
                      barWidth: 1,
                      spots: controller.dataFlSpot5,
                      color: colorList[5],
                      isCurved: true,
                      belowBarData: BarAreaData(
                        show: true,
                        color: colorList[5],
                      ),
                      dotData: const FlDotData(show: false),
                      isStepLineChart: false,
                    ),
                    LineChartBarData(
                      barWidth: 1,
                      spots: controller.dataFlSpot6,
                      color: colorList[6],
                      isCurved: true,
                      belowBarData: BarAreaData(
                        show: true,
                        color: colorList[6],
                      ),
                      dotData: const FlDotData(show: false),
                      isStepLineChart: false,
                    )
                  ],
                ),
              ));
        }),
      ),
    );
  }
}

class WaveChart7Controller extends GetxController {
  final double minY;
  final double maxY;
  final RxList<FlSpot> dataFlSpot0 = <FlSpot>[].obs;
  final RxList<FlSpot> dataFlSpot1 = <FlSpot>[].obs;
  final RxList<FlSpot> dataFlSpot2 = <FlSpot>[].obs;
  final RxList<FlSpot> dataFlSpot3 = <FlSpot>[].obs;
  final RxList<FlSpot> dataFlSpot4 = <FlSpot>[].obs;
  final RxList<FlSpot> dataFlSpot5 = <FlSpot>[].obs;
  final RxList<FlSpot> dataFlSpot6 = <FlSpot>[].obs;

  WaveChart7Controller({
    required this.minY,
    required this.maxY,
  });

  @override
  void onInit() {
    super.onInit();
    dataFlSpot0.add(const FlSpot(0, 0));
    dataFlSpot1.add(const FlSpot(0, 0));
    dataFlSpot2.add(const FlSpot(0, 0));
    dataFlSpot3.add(const FlSpot(0, 0));
    dataFlSpot4.add(const FlSpot(0, 0));
    dataFlSpot5.add(const FlSpot(0, 0));
    dataFlSpot6.add(const FlSpot(0, 0));
  }

  @override
  void onClose() {
    super.onClose();
    dataFlSpot0.clear();
    dataFlSpot1.clear();
    dataFlSpot2.clear();
    dataFlSpot3.clear();
    dataFlSpot4.clear();
    dataFlSpot5.clear();
    dataFlSpot6.clear();
  }

  Future<void> clearData() async {
    dataFlSpot0.clear();
    dataFlSpot0.add(const FlSpot(0, 0));
    dataFlSpot1.clear();
    dataFlSpot1.add(const FlSpot(0, 0));
    dataFlSpot2.clear();
    dataFlSpot2.add(const FlSpot(0, 0));
    dataFlSpot3.clear();
    dataFlSpot3.add(const FlSpot(0, 0));
    dataFlSpot4.clear();
    dataFlSpot4.add(const FlSpot(0, 0));
    dataFlSpot5.clear();
    dataFlSpot5.add(const FlSpot(0, 0));
    dataFlSpot6.clear();
    dataFlSpot6.add(const FlSpot(0, 0));
  }

  Future<void> addDataPoint(RxList<FlSpot> dataFlSpot, double value) async {
    double v = value;
    if (v < minY) {
      v = minY;
    }
    if (v > maxY) {
      v = maxY;
    }
    if (dataFlSpot.isEmpty) {
      dataFlSpot.add(const FlSpot(0, 0));
    }
    double x = dataFlSpot.length.toDouble();
    dataFlSpot.add(FlSpot(x, v));
    update();
  }
}
