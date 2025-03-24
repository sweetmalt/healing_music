import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';

class WaveChartController extends GetxController {
  final int maxDataPoints;
  final double minY;
  final double maxY;
  final RxList<FlSpot> data = <FlSpot>[].obs;
  double minX = 0;
  double maxX = 0;

  WaveChartController({
    required this.maxDataPoints,
    required this.minY,
    required this.maxY,
  });


  @override
  void onClose() {
    super.onClose();
    data.clear();
  }


  void addDataPoint(double value)  {
    if (value >= minY && value <= maxY) {
      data.add(FlSpot(maxX, value));
      maxX += 1;
      if (data.length > maxDataPoints) {
        minX += 1;
      }
      if (maxX > 3600) {
        data.clear();
        minX = 0;
        maxX = 0;
      }
      update();
    }
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
    this.lineWidth = 2,
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
                    spots: controller.data,
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
