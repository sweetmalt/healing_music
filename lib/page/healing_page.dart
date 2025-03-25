import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healing_music/controller/players_controller.dart';
import 'package:healing_music/controller/healing_controller.dart';
import 'package:healing_music/controller/main_controller.dart';
import 'package:healing_music/data/audios.dart';
import 'package:healing_music/widget/brain_wave_view.dart';
import 'package:healing_music/widget/circular_button.dart';
import 'package:healing_music/widget/page_title.dart';
import 'package:healing_music/widget/single_view.dart';
import 'package:healing_music/widget/volume_view.dart';

class HealingPage extends StatelessWidget {
  HealingPage({super.key});
  final HealingController controller = Get.put(HealingController());
  final MainController mainController = Get.find();

  final HemController hemController = Get.find();
  final EnvController envController = Get.find();
  final BgmController bgmController = Get.put(BgmController());
  final BbmController bbmController = Get.put(BbmController());

  static const Audios _audios = Audios();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 25,
        title: PageTitle('Healing Service'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => CircularIconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.8,
                      ),
                      builder: (context) {
                        return BrainWaveView();
                      },
                    );
                  },
                  icon: controller.isCtrlByDevice.value
                      ? Icons.bluetooth_audio
                      : Icons.bluetooth,
                ),
              ),
              Obx(() => Text(controller.title.value,
                  style: TextStyle(
                      color: ThemeData().colorScheme.primary,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold))),
              IntrinsicWidth(
                child: Container(
                  height: 40,
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: ThemeData().colorScheme.secondaryContainer,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: Obx(() => Text(hemController.timeMinutes.value,
                      style: TextStyle(
                          color: ThemeData().colorScheme.secondary,
                          fontSize: 30,
                          fontWeight: FontWeight.bold))),
                ),
              ),
              Obx(() => Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgress(
                          radius: 120,
                          value:
                              hemController.pos.value / hemController.dur.value,
                          backgroundColor: hemController.backgroundColor.value,
                          valueColor: hemController.valueColor.value),
                      CircularProgress(
                          radius: 100,
                          value:
                              envController.pos.value / envController.dur.value,
                          backgroundColor: envController.backgroundColor.value,
                          valueColor: envController.valueColor.value),
                      CircularProgress(
                          radius: 80,
                          value:
                              bgmController.pos.value / bgmController.dur.value,
                          backgroundColor: bgmController.backgroundColor.value,
                          valueColor: bgmController.valueColor.value),
                      CircularProgress(
                          radius: 60,
                          value:
                              bbmController.pos.value / bbmController.dur.value,
                          backgroundColor: bbmController.backgroundColor.value,
                          valueColor: bbmController.valueColor.value),
                      Obx(
                        () => CircularIconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return VolumeView();
                              },
                            );
                          },
                          icon: controller.isMute.value
                              ? Icons.volume_off_sharp
                              : Icons.volume_up_sharp,
                        ),
                      ),
                    ],
                  )),
              PlayBox(
                title: "脑波音频：",
                controller: hemController,
              ),
              AudiosRow(
                audios: _audios.hem,
                controller: hemController,
              ),
              PlayBox(
                title: "生境录音：",
                controller: envController,
              ),
              AudiosRow(
                audios: _audios.env,
                controller: envController,
              ),
              PlayBox(
                title: "经典器乐：",
                controller: bgmController,
              ),
              AudiosRow(
                audios: _audios.bgm,
                controller: bgmController,
              ),
              PlayBox(
                title: "双耳节拍：",
                controller: bbmController,
              ),
              AudiosRow(
                audios: _audios.bbm,
                controller: bbmController,
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CircularButton(
                      text: '颂钵',
                      icon: Icons.rice_bowl,
                      onPressed: () async {
                        await controller.singlePlayer
                            .setAsset("assets/audio/10s Singging Bowl.MP3");
                        //await controller.singlePlayer.setLoopMode(LoopMode.off);
                        await controller.singlePlayer.play();
                      },
                    ),
                    CircularButton(
                      text: '雨棍',
                      icon: Icons.line_style,
                      onPressed: () async {
                        await controller.singlePlayer
                            .setAsset("assets/audio/10s Rain Stick.MP3");
                        //await controller.singlePlayer.setLoopMode(LoopMode.off);
                        await controller.singlePlayer.play();
                      },
                    ),
                    CircularButton(
                      text: '丁夏',
                      icon: Icons.ring_volume,
                      onPressed: () async {
                        await controller.singlePlayer
                            .setAsset("assets/audio/10s Bell.MP3");
                        //await controller.singlePlayer.setLoopMode(LoopMode.off);
                        await controller.singlePlayer.play();
                      },
                    ),
                    CircularButton(
                      text: '更多',
                      icon: Icons.more_horiz,
                      onPressed: () async {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return SingleView();
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}

class CircularProgress extends StatelessWidget {
  final double radius;
  final double value;
  final Color backgroundColor;
  final Color valueColor;

  const CircularProgress({
    super.key,
    required this.radius,
    required this.value,
    required this.backgroundColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius / 2),
      ),
      child: CircularProgressIndicator(
        backgroundColor: backgroundColor,
        valueColor: AlwaysStoppedAnimation<Color>(valueColor),
        value: value,
        strokeWidth: 4,
      ),
    );
  }
}

class AudioItem extends StatelessWidget {
  final String title;
  final String url;
  final MyAudioCtrl controller;

  const AudioItem({
    super.key,
    required this.title,
    required this.url,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => TextButton(
          style: ButtonStyle(
            backgroundColor: controller.audioTitle.value == title
                ? WidgetStateProperty.all(ThemeData().colorScheme.secondary)
                : WidgetStateProperty.all(ThemeData().colorScheme.surface),
          ),
          onPressed: () {
            controller.setTitle(title);
            controller.changeAudio(audio: url);
          },
          child: Obx(() => Text(title,
              style: TextStyle(
                  color: controller.audioTitle.value == title
                      ? ThemeData().colorScheme.surface
                      : ThemeData().colorScheme.secondary,
                  fontSize: 12,
                  fontWeight: FontWeight.bold))),
        ));
  }
}

class AudiosRow extends StatelessWidget {
  final MyAudioCtrl controller;
  final Map<String, String> audios;
  const AudiosRow({
    super.key,
    required this.controller,
    required this.audios,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      margin: const EdgeInsets.only(left: 10, right: 10, top: 1, bottom: 10),
      decoration: BoxDecoration(
          color: ThemeData().colorScheme.secondaryContainer,
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: audios.entries.map<Widget>((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: AudioItem(
                title: entry.value,
                url: "assets/audio/${entry.key}.MP3",
                controller: controller,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class PlayBox extends StatelessWidget {
  final MyAudioCtrl controller;
  final String title;
  const PlayBox({
    super.key,
    required this.controller,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      decoration: BoxDecoration(
          color: ThemeData().colorScheme.secondaryContainer,
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: Row(
        children: [
          IconButton(
            color: ThemeData().colorScheme.secondary,
            onPressed: () {},
            icon: const Icon(Icons.headphones),
          ),
          Text(title),
          Expanded(
              child: Obx(() => SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 1.0,
                      activeTrackColor:
                          ThemeData().colorScheme.secondaryContainer,
                      inactiveTrackColor: ThemeData().colorScheme.surface,
                      thumbColor: ThemeData().colorScheme.secondaryContainer,
                    ),
                    child: Slider(
                      padding: EdgeInsets.zero,
                      min: 0.0,
                      max: controller.dur.value.toDouble(),
                      value: controller.pos.value.toDouble(),
                      onChanged: (value) {
                        controller.player
                            .seek(Duration(milliseconds: value.toInt()));
                      },
                    ),
                  ))),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(), 
            onPressed: () {
              controller.isPlaying.value
                  ? controller.pause()
                  : controller.play();
            },
            icon: Obx(() => controller.isPlaying.value
                ? const Icon(Icons.pause)
                : const Icon(Icons.play_arrow)),
          ),
        ],
      ),
    );
  }
}
