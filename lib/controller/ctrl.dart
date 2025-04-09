import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class Ctrl extends GetxController {
  late Timer? _timer;
  final RxBool isTimerRunning = false.obs;
  final RxInt timeSeconds = 0.obs; //单位：秒
  final RxInt usedTimeSeconds = 0.obs; //单位：秒
  final RxString textTimeSeconds = "00:00".obs;

  Future<void> setTimer(int sec) async {
    _clearTimer();
    timeSeconds.value = sec;
  }

  Future<void> startTimer(
      VoidCallback onTimerRunning, VoidCallback onTimerEnd) async {
    if (timeSeconds.value <= 0) {
      return;
    }
    isTimerRunning.value = true;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) async {
      if (timeSeconds.value > 0) {
        onTimerRunning(); //每秒执行一次
        usedTimeSeconds.value++;
        timeSeconds.value--;
        textTimeSeconds.value =
            "${usedTimeSeconds.value ~/ 60}:${usedTimeSeconds.value % 60} - ${timeSeconds.value ~/ 60}:${timeSeconds.value % 60}";
      } else {
        onTimerEnd(); //执行结束回调
        _clearTimer();
      }
    });
  }

  Future<void> pauseTimer() async {
    isTimerRunning.value = false;
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _clearTimer() async {
    isTimerRunning.value = false;
    timeSeconds.value = 0;
    usedTimeSeconds.value = 0;
    textTimeSeconds.value = "00:00";
    _timer?.cancel();
    _timer = null;
  }

  final AudioPlayer _player = AudioPlayer();
  final RxString audio = 'assets/audio/40s Birds Songs.MP3'.obs;
  final RxString audioName = '鸟鸣'.obs;
  final RxInt durationInMilliseconds = 1.obs;
  final RxInt positionInMilliseconds = 0.obs;
  final RxBool isPlaying = false.obs;
  final RxBool isLoop = false.obs;
  late final StreamSubscription<Duration>? _positionListener;

  Future<void> setAudio(String audio,
      {bool autoPlay = false, bool isLoop = false}) async {
    if (isPlaying.value) {
      isPlaying.value = false;
      _player.stop();
      _positionListener?.pause();
    }
    await _player.setAsset(audio, preload: false);
    this.audio.value = audio;
    await _player.load();
    durationInMilliseconds.value = _player.duration!.inMilliseconds;
    _player.setLoopMode(isLoop ? LoopMode.one : LoopMode.off);
    this.isLoop.value = isLoop;
    if (autoPlay) {
      playAudio(() => {}, () => {});
    }
  }

  Future<void> playAudio(VoidCallback onPlaying, VoidCallback onPlayEnd) async {
    isPlaying.value = true;
    _player.play();
    //侦听播放进度
    _positionListener = Stream.periodic(const Duration(milliseconds: 200))
        .switchMap((_) => _player.positionStream)
        .listen((position) {
      int d = durationInMilliseconds.value;
      int p = position.inMilliseconds;
      if (p <= d) {
        positionInMilliseconds.value = p;
        if (p < 4000) {
          setVolume((p / 4000) * maxVol.value);
        } else if (p > d - 4000) {
          setVolume(((d - p) / 4000) * maxVol.value);
        } else {
          setVolume(maxVol.value);
        }
        onPlaying();
      }
    });
  }

  Future<void> pauseAudio() async {
    isPlaying.value = false;
    _player.pause();
    _clearListener();
  }

  Future<void> seekAudio(Duration position) async {
    positionInMilliseconds.value = position.inMilliseconds;
    _player.seek(position);
  }

  Future<void> setVolume(double vol) async {
    _player.setVolume(vol);
  }

  final RxDouble maxVol = 0.5.obs;

  void setVolMute(bool isMute) {
    setVolume(isMute ? 0.01 : maxVol.value);
  }

  void setMaxVol(double mv) {
    if (mv < 0 || mv > 1.0) {
      return;
    }
    setVolume(mv);
    maxVol.value = mv;
  }

  Future<void> _disposeAudio() async {
    isPlaying.value = false;
    durationInMilliseconds.value = 1;
    positionInMilliseconds.value = 0;
    _player.stop();
    _player.dispose();
  }

  void _clearListener() {
    _positionListener?.cancel();
    _positionListener = null;
  }

  @override
  void onClose() async {
    super.onClose();
    _clearTimer();
    _clearListener();
    _disposeAudio();
  }
}
