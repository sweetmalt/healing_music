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
  Future<void> setTimer(int sec) async{
    clearTimer();
    timeSeconds.value = sec;
  }


  Future<void> startTimer(VoidCallback onTimerRunning, VoidCallback onTimerEnd) async{
    if (timeSeconds.value <= 0) {
      return;
    }
    isTimerRunning.value = true;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) async {
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

  Future<void> pauseTimer()async {
    if (isTimerRunning.value && timeSeconds.value > 0) {
      isTimerRunning.value = false;
      _timer.cancel();
    }
  }

  Future<void> clearTimer() async{
    if (timeSeconds.value > 0 || usedTimeSeconds.value > 0) {
      isTimerRunning.value = false;
      _timer.cancel();
      timeSeconds.value = 0;
      usedTimeSeconds.value = 0;
      textTimeSeconds.value = "00:00";
    }
  }

  Future<void> play() async{
    isPlaying.value = true;
    await player.play();
  }

  Future<void> pause() async{
    isPlaying.value = false;
    await player.pause();
  }

  Future<void> stop() async{
    isPlaying.value = false;
    await player.stop();
  }

  Future<void> changeAudio(String audio, {bool autoPlay = false, bool isLoop = false})async {
    isPlaying.value = false;
    await player.stop();
    _audio.value = audio;
    await player.setAsset(_audio.value);
    if (isLoop) {
      await player.setLoopMode(LoopMode.all);
    } else {
      await player.setLoopMode(LoopMode.off);
    }
    if (autoPlay) {
      await player.play();
      isPlaying.value = true;
    }
  }

  @override
  void onInit() async{
    super.onInit();
    await player.setLoopMode(LoopMode.off);
    await player.setAsset(_audio.value);
  }

  @override
  void onClose()async {
    await clearTimer();
    await stop();
    await player.dispose();
    super.onClose();
  }
}
