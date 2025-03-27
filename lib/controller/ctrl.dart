import 'dart:async';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class Ctrl extends GetxController {
  late final VoidCallback onTimeSeconds;
  final AudioPlayer player = AudioPlayer();
  final RxString _audio = 'assets/audio/40s Birds Songs.MP3'.obs;
  final RxBool isPlaying = false.obs;
  final RxInt timeSeconds = 0.obs; //单位：秒
  final RxInt usedTimeSeconds = 0.obs; //单位：秒
  final RxInt restTimeSeconds = 0.obs; //单位：秒
  late Timer _timer;
  bool _isTimerRunning = false;
  void setTimer(int secs) {
    clearTimer();
    if (secs <= 0) {
      return;
    } else {
      timeSeconds.value = secs;
      usedTimeSeconds.value = 0;
      restTimeSeconds.value = secs;
    }
    _isTimerRunning = true;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (restTimeSeconds.value > 0) {
        usedTimeSeconds.value++;
        restTimeSeconds.value--;
        onTimeSeconds();
      } else {
        stop();
      }
    });
  }

  void clearTimer() {
    if (_isTimerRunning) {
      _isTimerRunning = false;
      _timer.cancel();
      timeSeconds.value = 0;
      usedTimeSeconds.value = 0;
      restTimeSeconds.value = 0;
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
