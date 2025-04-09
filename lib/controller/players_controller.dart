import 'package:healing_music/controller/ctrl.dart';

class MyAudioCtrl extends Ctrl {}

class HemController extends MyAudioCtrl {
  @override
  void onInit() {
    super.onInit();
    setAudio("assets/audio/90s 963HZ.MP3");
    audioName.value = "全息963HZ";
  }
}

class EnvController extends MyAudioCtrl {
  @override
  void onInit() {
    super.onInit();
    setAudio("assets/audio/40s Birds Songs.MP3");
    audioName.value = "鸟鸣";
  }
}

class BgmController extends MyAudioCtrl {
  @override
  void onInit() {
    super.onInit();
    setAudio("assets/audio/BGM Flute.MP3");
    audioName.value = "长笛";
  }
}

class BbmController extends MyAudioCtrl {
  @override
  void onInit() {
    super.onInit();
    setAudio("assets/audio/60s 10HZ.MP3");
    audioName.value = "阿尔法波10HZ放松";
  }
}
