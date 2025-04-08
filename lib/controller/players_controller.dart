import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class MyAudioCtrl extends GetxController {
  final AudioPlayer player = AudioPlayer();
  final RxString audioTitle = ''.obs;
  final RxString audioName = 'assets/audio/40s Birds Songs.MP3'.obs;
  final RxBool isPlaying = false.obs;
  final RxDouble pos = 0.0.obs;
  final RxDouble dur = 1.0.obs;
  final RxBool colorSwitch = false.obs;
  List<Color> switchColors = [
    ThemeData().colorScheme.primaryContainer,
    ThemeData().colorScheme.primary
  ];
  bool permitSwitchColor = false;
  final RxDouble maxVol = 0.5.obs;
  double _vol = 0.5;
  double _volTemp = 0.5;
  late final StreamSubscription<Duration> _listenerPos;

  void setTitle(String title) {
    audioTitle.value = title;
  }

  void initPlayer({required String audio, bool isLoop = true}) async {
    await player.setAsset(audioName.value);
    await player.load();
    await player.setVolume(maxVol.value);
    await player.setLoopMode(isLoop ? LoopMode.one : LoopMode.off);
    changeAudio(audio: audio, autoPlay: false, isLoop: isLoop);
    startListen(isLoop: isLoop);
  }

  void startListen({bool isLoop = true}) {
    player.setLoopMode(isLoop ? LoopMode.one : LoopMode.off);
    _listenerPos = Stream.periodic(const Duration(milliseconds: 200))
        .switchMap((_) => player.positionStream)
        .listen((position) {
      double temp = position.inMilliseconds.toDouble();
      if (temp >= 0 && temp <= dur.value) {
        pos.value = temp;
      }
      if (isPlaying.value) {
        if (pos.value < 5000) {
          double p = pos.value / 5000;
          if (p < 0.1) {
            p = 0.1;
          }
          player.setVolume(p * _vol);
          if (permitSwitchColor) {
            permitSwitchColor = false;
            colorSwitch.value = !colorSwitch.value;
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

  void changeAudio(
      {String audio = "", bool autoPlay = true, bool isLoop = true}) async {
    if (audio == "") {
      return;
    }
    if (isPlaying.value) {
      pause();
    }
    audioName.value = audio;
    await player.setAsset(audioName.value);
    await player.load();
    await player.setLoopMode(isLoop ? LoopMode.one : LoopMode.off);
    await player.setVolume(maxVol.value);
    pos.value = 0.0;
    dur.value = player.duration!.inMilliseconds.toDouble();
    if (autoPlay) {
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

  void play() async {
    _listenerPos.resume();
    isPlaying.value = true;
    player.play();
  }

  void pause() {
    _listenerPos.pause();
    isPlaying.value = false;
    player.pause();
  }

  void stop() {
    _listenerPos.pause();
    isPlaying.value = false;
    player.stop();
  }

  @override
  void onClose() {
    super.onClose();
    _listenerPos.cancel();
    player.dispose();
  }
}

class BgmController extends MyAudioCtrl {
  @override
  void onInit() {
    super.onInit();
    initPlayer(audio: "assets/audio/BGM Flute.MP3", isLoop: true);
  }
}

class EnvController extends MyAudioCtrl {
  @override
  void onInit() {
    super.onInit();
    initPlayer(audio: "assets/audio/40s Fire.MP3", isLoop: true);
  }
}

class BbmController extends MyAudioCtrl {
  @override
  void onInit() {
    super.onInit();
    initPlayer(audio: "assets/audio/60s 1HZ.MP3", isLoop: true);
  }
}

class HemController extends MyAudioCtrl {
  @override
  void onInit() {
    super.onInit();
    initPlayer(audio: "assets/audio/90s 963HZ.MP3", isLoop: true);
  }
}
