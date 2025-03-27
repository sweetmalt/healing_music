import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healing_music/controller/healing_controller.dart';
import 'package:healing_music/controller/main_controller.dart';
import 'package:healing_music/controller/players_controller.dart';
import 'package:healing_music/data/audios.dart';
import 'package:healing_music/page/music_album.dart';
import 'package:healing_music/widget/page_title.dart';
import 'package:healing_music/widget/paragraph.dart';
import 'package:healing_music/widget/item.dart';
import 'package:healing_music/widget/paragraph_bottom.dart';

class MusicPage extends StatelessWidget {
  const MusicPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 25,
        title: PageTitle('Audio & Music'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          for (int i = 0; i < _audios.txt.length; i++)
            MusicBox(
              index: i,
            ),
          Container(
            alignment: Alignment.center,
            height: 120,
            child: const Text("AI文案，仅供参考"),
          ),
        ],
      ),
    );
  }
}

const Audios _audios = Audios();

class MusicBox extends StatelessWidget {
  final int index;
  MusicBox({
    super.key,
    required this.index,
  });
  final MainController mainController = Get.find();
  final HealingController healingController = Get.put(HealingController());
  final HemController hemController = Get.put(HemController());
  final EnvController envController = Get.put(EnvController());
  final BgmController bgmController = Get.put(BgmController());
  final BbmController bbmController = Get.put(BbmController());
  @override
  Widget build(BuildContext context) {
    String title = _audios.txt.keys.toList()[index];
    String subTitle = _audios.txt.values.toList()[index];
    String hemTitle = _audios.hem.values.toList()[index];
    String hemAudio = _audios.hem.keys.toList()[index];
    String envTitle = _audios.env.values.toList()[index];
    String envAudio = _audios.env.keys.toList()[index];
    String bgmTitle = _audios.bgm.values.toList()[3];
    String bgmAudio = _audios.bgm.keys.toList()[3];
    String bbmTitle = _audios.bbm.values.toList()[1];
    String bbmAudio = _audios.bbm.keys.toList()[1];
    return Column(
      children: [
        ParagraphListTile(
          title: _audios.txt.keys.toList()[index],
          onTap: () {},
        ),
        ItemListTile(
          title: '$hemTitle & $envTitle',
          subtitle: '$hemAudio,$envAudio',
          onTap: () async {
            healingController.title.value = title;
            healingController.subTitle.value = subTitle;
            hemController.setTitle(hemTitle);
            await hemController.changeAudio(
                audio: "assets/audio/$hemAudio.MP3", autoPlay: false);
            envController.setTitle(envTitle);
            await envController.changeAudio(
                audio: "assets/audio/$envAudio.MP3", autoPlay: false);
            bgmController.setTitle(bgmTitle);
            await bgmController.changeAudio(
                audio: "assets/audio/$bgmAudio.MP3", autoPlay: false);
            bbmController.setTitle(bbmTitle);
            await bbmController.changeAudio(
                audio: "assets/audio/$bbmAudio.MP3", autoPlay: false);
            Get.to(AlbumPage());
          },
        ),
        ParagraphBottomListTile(
          title: subTitle,
          onTap: () {},
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
