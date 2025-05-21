import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healing_music/controller/depot_controller.dart';
import 'package:healing_music/controller/healing_controller.dart';
import 'package:healing_music/controller/main_controller.dart';
import 'package:healing_music/controller/music_controller.dart';
import 'package:healing_music/controller/players_controller.dart';
import 'package:healing_music/data/audios.dart';
import 'package:healing_music/page/main_page.dart';
import 'package:healing_music/page/music_album.dart';
import 'package:healing_music/widget/paragraph.dart';
import 'package:healing_music/widget/item.dart';
import 'package:healing_music/widget/paragraph_bottom.dart';

class MusicPage extends StatelessWidget {
  MusicPage({super.key});
  final MusicController controller = Get.put(MusicController());
  final DepotController depotController = Get.put(DepotController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(40),
            child: Image.asset("assets/images/7e5s.png", width: 320),
          ),
          for (int i = 0; i < _audios.txt.length; i++)
            MusicBox(
              index: i,
            ),
          Container(
            alignment: Alignment.center,
            height: 120,
            child: MyTextP3("以上文案全部由AI生成，仅供参考", colorSecondary),
          ),
          Container(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              spacing: 20,
              children: [
                ListTile(
                  onTap: () {
                    if (depotController.user.loginState.value != 2) {
                      Get.snackbar("提示", "请先登录，且保持联网",
                          snackPosition: SnackPosition.BOTTOM);
                      return;
                    }
                    Get.snackbar("提示", "播放全部",
                        snackPosition: SnackPosition.BOTTOM);
                    if (controller.isPlayingAll.value) {
                      controller.stop();
                    } else {
                      controller.playAll();
                    }
                  },
                  leading: Image.asset("assets/images/2.png"),
                  title: const MyTextH3("在线乐库", Colors.white),
                  subtitle: const MyTextP3(
                      "瑜伽、冥想、疗愈空间 日常BGM，点击播放，循环所有", Colors.white),
                  trailing: Obx(() => Icon(
                        controller.isPlayingAll.value
                            ? Icons.repeat_rounded
                            : Icons.play_arrow_rounded,
                        color: controller.isPlayingAll.value
                            ? Colors.red
                            : Colors.white,
                      )),
                ),
                Container(
                  height: 1,
                  color: Colors.white,
                  margin: const EdgeInsets.only(left: 10, right: 10),
                ),
                for (int i = 1; i <= 10; i++)
                  ListTile(
                      onTap: () {
                        if (depotController.user.loginState.value != 2) {
                          Get.snackbar("提示", "请先登录，且保持联网",
                              snackPosition: SnackPosition.BOTTOM);
                          return;
                        }
                        Get.snackbar("提示", "单曲循环",
                            snackPosition: SnackPosition.BOTTOM);
                        if (controller.isPlayingIndex.value == i) {
                          controller.stop();
                        } else {
                          controller.play(i);
                        }
                      },
                      selectedColor: colorPrimary,
                      leading: Image.asset("assets/images/3.png"),
                      title: MyTextP1("Healing Music $i"),
                      subtitle: MyTextP3(
                          "瑜伽、冥想、疗愈空间 日常BGM，点击播放，单曲循环", colorSecondary),
                      trailing: Obx(() => Icon(
                            controller.isPlayingIndex.value == i
                                ? Icons.repeat_one_rounded
                                : Icons.play_arrow_rounded,
                            color: controller.isPlayingIndex.value == i
                                ? Colors.red
                                : Colors.white,
                          ))),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            transformAlignment: Alignment.center,
            height: 200,
            child: MyTextP3("Copyright 2025 HealingAI", colorPrimary),
          ),
        ],
      ),
    );
  }
}

const Audios _audios = Audios();
final List<List> _pla = _audios.pla;

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
    String audioTitle = "$hemTitle & $envTitle";
    String audioSubTitle = "$hemAudio,$envAudio";
    return Column(
      children: [
        ParagraphListTile(
          title: _audios.txt.keys.toList()[index],
          onTap: () {},
        ),
        ItemListTile(
          title: '$hemTitle & $envTitle',
          subtitle: '$hemAudio,$envAudio',
          icon: Icons.play_arrow,
          onTap: () {
            healingController.title.value = title;
            healingController.subTitle.value = subTitle;
            healingController.audioTitle.value = audioTitle;
            healingController.audioSubTitle.value = audioSubTitle;
            healingController.setTimePlan(
                _pla[healingController.healingTimePlanKeyIndex.value][0],
                _pla[healingController.healingTimePlanKeyIndex.value][1]);

            hemController.audioName.value = hemTitle;
            hemController.setAudio("assets/audio/$hemAudio.MP3",
                autoPlay: false, isLoop: true);
            envController.audioName.value = envTitle;
            envController.setAudio("assets/audio/$envAudio.MP3",
                autoPlay: false, isLoop: true);
            bgmController.audioName.value = bgmTitle;
            bgmController.setAudio("assets/audio/$bgmAudio.MP3",
                autoPlay: false, isLoop: true);
            bbmController.audioName.value = bbmTitle;
            bbmController.setAudio("assets/audio/$bbmAudio.MP3",
                autoPlay: false, isLoop: true);
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
