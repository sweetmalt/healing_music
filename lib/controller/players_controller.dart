import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class MyAudioCtrl extends GetxController {
  final AudioPlayer player = AudioPlayer();
  final RxString audioTitle = ''.obs;
  final RxString audioName = 'assets/audio/BGM Piano.MP3'.obs;
  final RxBool isPlaying = false.obs;
  final RxDouble pos = 0.0.obs;
  final RxDouble dur = 1.0.obs;
  final Rx<Color> backgroundColor =
      ThemeData().colorScheme.primaryContainer.obs;
  final Rx<Color> valueColor = ThemeData().colorScheme.primary.obs;
  bool permitSwitchColor = false;
  final RxDouble maxVol = 0.4.obs;
  double _vol = 1.0;
  final RxInt timeSeconds = 0.obs; //单位：秒
  final RxString timeMinutes = '00:00'.obs; //单位：分钟
  late final StreamSubscription<Duration> _listenerPos;

  // late Timer _timer;
  // bool _isTimerRunning = false;

  setTitle(String title) {
    audioTitle.value = title;
  }

  switchColor() {
    Color temp = backgroundColor.value;
    backgroundColor.value = valueColor.value;
    valueColor.value = temp;
  }

  Future<void> initPlayer({required String audio, bool isLoop = true}) async {
    await player.setLoopMode(isLoop ? LoopMode.all : LoopMode.off);
    await changeAudio(audio: audio, autoPlay: false, isLoop: isLoop);
    await startListen(isLoop: isLoop);
    //_listenerPos.pause();
  }

  Future<void> startListen({bool isLoop = true}) async {
    _listenerPos = player.positionStream.listen((position) {
      pos.value = position.inMilliseconds.toDouble();
      if (isLoop) {
        if (pos.value < 5000) {
          double p = pos.value / 5000;
          if (p < 0.1) {
            p = 0.1;
          }
          _vol = p * maxVol.value;
          player.setVolume(_vol);
          if (permitSwitchColor) {
            permitSwitchColor = false;
            switchColor();
          }
        } else if (pos.value > dur.value - 5000) {
          double p = (dur.value - pos.value) / 5000;
          if (p < 0.1) {
            p = 0.1;
          }
          _vol = p * maxVol.value;
          player.setVolume(_vol);
          permitSwitchColor = true;
        } else {
          if (_vol != maxVol.value) {
            _vol = maxVol.value;
            player.setVolume(_vol);
          }
        }
      }
    });
  }

  Future<void> changeAudio(
      {String audio = "", bool autoPlay = true, bool isLoop = true}) async {
    if (audio == "") {
      return;
    }
    if (isPlaying.value) {
      pause();
    }
    audioName.value = audio;
    await player.setAsset(audioName.value);
    player.setVolume(maxVol.value);
    if (player.duration != null) {
      int durTemp = player.duration!.inMilliseconds;
      if (durTemp > 0) {
        dur.value = durTemp.toDouble();
      }
    }
    if (autoPlay) {
      play();
    }
  }

  void setMaxVol(double mv) {
    maxVol.value = mv;
    _vol = mv;
    if (isPlaying.value) {
      player.setVolume(_vol);
    }
  }

  void play() {
    isPlaying.value = true;
    player.play();
    //_listenerPos.resume();
  }

  void pause() {
    isPlaying.value = false;
    //_listenerPos.pause();
    player.pause();
  }

  void stop() {
    // if (_isTimerRunning) {
    //   _isTimerRunning = false;
    //   _timer.cancel();
    //   timeSeconds.value = 0;
    //   timeMinutes.value = "00:00";
    // }
    isPlaying.value = false;
    //_listenerPos.pause();
    player.stop();
  }

  // void setTimer(int secs) {
  //   if (secs <= 0) {
  //     return;
  //   } else {
  //     timeSeconds.value = secs;
  //   }
  //   if (_isTimerRunning) {
  //     _timer.cancel();
  //   }
  //   _isTimerRunning = true;
  //   int tempSecs = 0;
  //   const oneSec = Duration(seconds: 1);
  //   _timer = Timer.periodic(oneSec, (Timer timer) {
  //     if (timeSeconds.value > 0) {
  //       tempSecs++;
  //       timeSeconds.value--;
  //       timeMinutes.value =
  //           '${(tempSecs / 60).floor()}:${(tempSecs % 60).toString().padLeft(2, '0')} - ${(timeSeconds.value / 60).floor()}:${(timeSeconds.value % 60).toString().padLeft(2, '0')}';
  //     } else {
  //       stop();
  //     }
  //   });
  // }

  @override
  void onClose() {
    //_timer.cancel();
    _listenerPos.cancel();
    player.dispose();
    super.onClose();
  }
}

class BgmController extends MyAudioCtrl {
  @override
  Future<void> onInit() async {
    await initPlayer(audio: "assets/audio/BGM Flute.MP3", isLoop: true);
    super.onInit();
  }
}

class EnvController extends MyAudioCtrl {
  @override
  Future<void> onInit() async {
    await initPlayer(audio: "assets/audio/40s Fire.MP3", isLoop: true);
    super.onInit();
  }
}

class BbmController extends MyAudioCtrl {
  @override
  Future<void> onInit() async {
    await initPlayer(audio: "assets/audio/60s 1HZ.MP3", isLoop: true);
    super.onInit();
  }
}

class HemController extends MyAudioCtrl {
  @override
  Future<void> onInit() async {
    await initPlayer(audio: "assets/audio/90s 963HZ.MP3", isLoop: true);
    super.onInit();
  }
}
