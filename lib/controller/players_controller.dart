import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class MyAudioCtrl extends GetxController {
  final AudioPlayer player = AudioPlayer();
  final RxString audioTitle = ''.obs;
  final RxString audioName = 'assets/audio/40s Birds Songs.MP3'.obs;
  final RxBool isPlaying = false.obs;
  final RxDouble pos = 0.0.obs;
  final RxDouble dur = 1.0.obs;
  final Rx<Color> backgroundColor =
      ThemeData().colorScheme.primaryContainer.obs;
  final Rx<Color> valueColor = ThemeData().colorScheme.primary.obs;
  bool permitSwitchColor = false;
  final RxDouble maxVol = 0.5.obs;
  double _vol = 0.5;
  double _volTemp = 0.5;
  late final StreamSubscription<Duration> _listenerPos;

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
          player.setVolume(p * _vol);
          if (permitSwitchColor) {
            permitSwitchColor = false;
            switchColor();
          }
        } else if (pos.value > dur.value - 5000) {
          double p = (dur.value - pos.value) / 5000;
          if (p < 0.1) {
            p = 0.1;
          }
          player.setVolume(p * _vol);
          permitSwitchColor = true;
        } else {
          player.setVolume(_vol);
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
    if (player.duration != null) {
      int durTemp = player.duration!.inMilliseconds;
      if (durTemp > 0) {
        dur.value = durTemp.toDouble();
      }
    }
    if (autoPlay) {
      player.setVolume(_vol);
      play();
    }
  }

  void setVol(double mv) {
    if (mv < 0 || mv > 1.0) {
      return;
    }
    _vol = mv > maxVol.value ? maxVol.value : mv;
    player.setVolume(_vol);
  }

  void setVolMute(bool isMute) {
    if (isMute) {
      _volTemp = _vol;
      setVol(0.01);
    } else {
      setVol(_volTemp);
    }
  }

  void setMaxVol(double mv) {
    if (mv < 0 || mv > 1.0) {
      return;
    }
    maxVol.value = mv;
    setVol(maxVol.value);
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

  @override
  void onClose() {
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
