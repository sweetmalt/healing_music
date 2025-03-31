import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class Ctrl extends GetxController {
  final AudioPlayer player = AudioPlayer();
  final RxString _audio = 'assets/audio/40s Birds Songs.MP3'.obs;
  final RxBool isPlaying = false.obs;
  final RxInt timeSeconds = 0.obs; //单位：秒
  final RxInt usedTimeSeconds = 0.obs; //单位：秒
  final RxString textTimeSeconds = "00:00".obs;
  late Timer _timer;
  final RxBool isTimerRunning = false.obs;
  void setTimer(int sec) {
    clearTimer();
    timeSeconds.value = sec;
  }


  void startTimer(VoidCallback onTimerRunning, VoidCallback onTimerEnd) {
    if (timeSeconds.value <= 0) {
      return;
    }
    isTimerRunning.value = true;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (timeSeconds.value > 0) {
        onTimerRunning();
        usedTimeSeconds.value++;
        timeSeconds.value--;
        textTimeSeconds.value =
            "${usedTimeSeconds.value ~/ 60}:${usedTimeSeconds.value % 60} - ${timeSeconds.value ~/ 60}:${timeSeconds.value % 60}";
      } else {
        onTimerEnd();
      }
    });
  }

  void pauseTimer() {
    if (isTimerRunning.value && timeSeconds.value > 0) {
      isTimerRunning.value = false;
      _timer.cancel();
    }
  }

  void clearTimer() {
    if (timeSeconds.value > 0 || usedTimeSeconds.value > 0) {
      isTimerRunning.value = false;
      _timer.cancel();
      timeSeconds.value = 0;
      usedTimeSeconds.value = 0;
      textTimeSeconds.value = "00:00";
    }
  }

  void play() {
    isPlaying.value = true;
    player.play();
  }

  void pause() {
    isPlaying.value = false;
    player.pause();
  }

  void stop() {
    isPlaying.value = false;
    player.stop();
  }

  void changeAudio(String audio, {bool autoPlay = false, bool isLoop = false}) {
    isPlaying.value = false;
    player.stop();
    _audio.value = audio;
    player.setAsset(_audio.value);
    if (isLoop) {
      player.setLoopMode(LoopMode.all);
    } else {
      player.setLoopMode(LoopMode.off);
    }
    if (autoPlay) {
      player.play();
      isPlaying.value = true;
    }
  }

  @override
  void onInit() {
    super.onInit();
    player.setLoopMode(LoopMode.off);
    player.setAsset(_audio.value);
  }

  @override
  void onClose() {
    clearTimer();
    stop();
    player.dispose();
    super.onClose();
  }
}
