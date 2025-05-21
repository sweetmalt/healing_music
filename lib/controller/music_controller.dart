import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class MusicController extends GetxController {
  // 在这里定义你的状态和方法
  final count = 0.obs;
  final AudioPlayer _player = AudioPlayer();
  static const String _audioPath = "https://ur.healingai.top/MP3/";
  final RxBool isPlaying = false.obs;
  final RxBool isPlayingAll = false.obs;
  final RxInt isPlayingIndex = 0.obs;
  Future<void> play(int index) async {
    isPlaying.value = true;
    isPlayingAll.value = false;
    isPlayingIndex.value = index;
    await _player.stop();
    await _player.setUrl("$_audioPath$index.MP3");
    await _player.load();
    await _player.setLoopMode(LoopMode.one);
    await _player.setVolume(1.0);
    await _player.seek(Duration.zero);
    await _player.play();
  }

  Future<void> playAll() async {
    isPlaying.value = true;
    isPlayingAll.value = true;
    isPlayingIndex.value = 0;
    await _player.stop();
    await _player.setAudioSource(
        ConcatenatingAudioSource(useLazyPreparation: false, children: [
      for (int i = 1; i <= 10; i++)
        AudioSource.uri(Uri.parse("$_audioPath$i.MP3")),
    ]));
    await _player.load();
    await _player.setLoopMode(LoopMode.all);
    await _player.setVolume(1.0);
    await _player.play();
  }

  Future<void> stop() async {
    isPlaying.value = false;
    isPlayingAll.value = false;
    isPlayingIndex.value = 0;
    _player.stop();
  }
}
