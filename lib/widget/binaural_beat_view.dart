// ignore_for_file: sized_box_for_whitespace

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healing_music/widget/wave_chart.dart';

class BbtController extends GetxController {
  RxBool isPlaying = false.obs;
  RxInt hz = 100.obs;
  void play() {
    isPlaying.value = true;
  }

  void pause() {
    isPlaying.value = false;
  }
}

class BbtView extends StatelessWidget {
  BbtView({super.key});
  final BbtController bbtController = Get.find();

  final WaveChartController waveController = WaveChartController(
    maxDataPoints: 1000,
    minY: -1.2,
    maxY: 1.2,
  );
  void startSinWave() {
    int x = 0;
    Timer.periodic(
        Duration(milliseconds: (1000 / bbtController.hz.value).toInt()),
        (timer) {
      if (bbtController.isPlaying.value) {
        double value = sin((x / bbtController.hz.value) * 2 * pi);
        waveController.addDataPoint(value);
        if (x++ >= bbtController.hz.value) {
          x = 1;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    startSinWave();
    return Container(
      height: 40,
      child: WaveChart(
        controller: waveController,
        lineColor: ThemeData().colorScheme.primary,
      ),
    );
  }
}
