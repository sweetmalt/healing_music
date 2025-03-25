import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healing_music/controller/players_controller.dart';
import 'package:healing_music/controller/healing_controller.dart';
import 'package:healing_music/controller/main_controller.dart';
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
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: CircularProgressIndicator(
                          backgroundColor:
                              ThemeData().colorScheme.primaryContainer,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              ThemeData().colorScheme.primary),
                          value:
                              hemController.pos.value / hemController.dur.value,
                          strokeWidth: 4,
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: CircularProgressIndicator(
                          backgroundColor:
                              ThemeData().colorScheme.primaryContainer,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              ThemeData().colorScheme.primary),
                          value:
                              envController.pos.value / envController.dur.value,
                          strokeWidth: 4,
                        ),
                      ),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: CircularProgressIndicator(
                          backgroundColor:
                              ThemeData().colorScheme.primaryContainer,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              ThemeData().colorScheme.primary),
                          value:
                              bgmController.pos.value / bgmController.dur.value,
                          strokeWidth: 4,
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: CircularProgressIndicator(
                          backgroundColor:
                              ThemeData().colorScheme.primaryContainer,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              ThemeData().colorScheme.primary),
                          value:
                              bbmController.pos.value / bbmController.dur.value,
                          strokeWidth: 4,
                        ),
                      ),
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
              const SizedBox(height: 20.0),
              Container(
                height: 40,
                margin: const EdgeInsets.only(left: 40, right: 40),
                decoration: BoxDecoration(
                    color: ThemeData().colorScheme.secondaryContainer,
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: Row(
                  children: [
                    IconButton(
                      color: ThemeData().colorScheme.secondary,
                      onPressed: () {},
                      icon: const Icon(Icons.music_video),
                    ),
                    const Text("BGM"),
                    Expanded(
                        child: Obx(() => SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 1.0,
                              ),
                              child: Slider(
                                min: 0.0,
                                max: hemController.dur.value.toDouble(),
                                activeColor: ThemeData().colorScheme.primary,
                                inactiveColor: ThemeData().colorScheme.surface,
                                thumbColor:
                                    ThemeData().colorScheme.primaryContainer,
                                value: hemController.pos.value.toDouble(),
                                onChanged: (value) {
                                  hemController.player.seek(
                                      Duration(milliseconds: value.toInt()));
                                },
                              ),
                            ))),
                    IconButton(
                      color: ThemeData().colorScheme.secondary,
                      onPressed: () {
                        hemController.isPlaying.value
                            ? hemController.pause()
                            : hemController.play();
                      },
                      icon: Obx(() => hemController.isPlaying.value
                          ? const Icon(Icons.pause)
                          : const Icon(Icons.play_arrow)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Wrap(
                  children: [
                    TextButton(
                      onPressed: () {
                        hemController.setTitle("全息963HZ");
                        hemController.changeAudio(
                            audio: "assets/audio/90s 963HZ.MP3");
                      },
                      child: Obx(() => Text("@全息963HZ",
                          style: TextStyle(
                              color: hemController.audioTitle.value == "全息963HZ"
                                  ? Colors.blue
                                  : ThemeData().colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold))),
                    ),
                    TextButton(
                        onPressed: () {
                          hemController.setTitle("睡眠852HZ");
                          hemController.changeAudio(
                              audio: "assets/audio/90s 852HZ.MP3");
                        },
                        child: Obx(() => Text("@睡眠852HZ",
                            style: TextStyle(
                                color:
                                    hemController.audioTitle.value == "睡眠852HZ"
                                        ? Colors.blue
                                        : ThemeData().colorScheme.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)))),
                    TextButton(
                      onPressed: () {
                        hemController.setTitle("代谢714HZ");
                        hemController.changeAudio(
                            audio: "assets/audio/90s 714HZ.MP3");
                      },
                      child: Obx(() => Text("@代谢714HZ",
                          style: TextStyle(
                              color: hemController.audioTitle.value == "代谢714HZ"
                                  ? Colors.blue
                                  : ThemeData().colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold))),
                    ),
                    TextButton(
                      onPressed: () {
                        hemController.setTitle("免疫639HZ");
                        hemController.changeAudio(
                            audio: "assets/audio/90s 639HZ.MP3");
                      },
                      child: Obx(() => Text("@免疫639HZ",
                          style: TextStyle(
                              color: hemController.audioTitle.value == "免疫639HZ"
                                  ? Colors.blue
                                  : ThemeData().colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold))),
                    ),
                    TextButton(
                      onPressed: () {
                        hemController.setTitle("消化528HZ");
                        hemController.changeAudio(
                            audio: "assets/audio/90s 528HZ.MP3");
                      },
                      child: Obx(() => Text("@消化528HZ",
                          style: TextStyle(
                              color: hemController.audioTitle.value == "消化528HZ"
                                  ? Colors.blue
                                  : ThemeData().colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold))),
                    ),
                    TextButton(
                      onPressed: () {
                        hemController.setTitle("幸福417HZ");
                        hemController.changeAudio(
                            audio: "assets/audio/90s 417HZ.MP3");
                      },
                      child: Obx(() => Text("@幸福417HZ",
                          style: TextStyle(
                              color: hemController.audioTitle.value == "幸福417HZ"
                                  ? Colors.blue
                                  : ThemeData().colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold))),
                    ),
                    TextButton(
                      onPressed: () {
                        hemController.setTitle("动力396HZ");
                        hemController.changeAudio(
                            audio: "assets/audio/90s 396HZ.MP3");
                      },
                      child: Obx(() => Text("@动力396HZ",
                          style: TextStyle(
                              color: hemController.audioTitle.value == "动力396HZ"
                                  ? Colors.blue
                                  : ThemeData().colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold))),
                    ),
                    TextButton(
                      onPressed: () {
                        //bgmController.setTimer(300);
                      },
                      child: Obx(() => Text(
                          "VOL ${(hemController.maxVol.value * 100).toInt()}%",
                          style: TextStyle(
                            color: ThemeData().colorScheme.secondaryContainer,
                            fontSize: 12,
                          ))),
                    )
                  ],
                ),
              ),
              Container(
                height: 40,
                margin: const EdgeInsets.only(left: 40, right: 40),
                decoration: BoxDecoration(
                    color: ThemeData().colorScheme.secondaryContainer,
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: Row(
                  children: [
                    IconButton(
                      color: ThemeData().colorScheme.secondary,
                      onPressed: () {},
                      icon: const Icon(Icons.music_note_outlined),
                    ),
                    const Text("生境"),
                    Expanded(
                        child: Obx(() => SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 1.0,
                              ),
                              child: Slider(
                                min: 0.0,
                                max: envController.dur.value.toDouble(),
                                activeColor: ThemeData().colorScheme.primary,
                                inactiveColor: ThemeData().colorScheme.surface,
                                thumbColor:
                                    ThemeData().colorScheme.primaryContainer,
                                value: envController.pos.value.toDouble(),
                                onChanged: (value) {
                                  envController.player.seek(
                                      Duration(milliseconds: value.toInt()));
                                },
                              ),
                            ))),
                    IconButton(
                      color: ThemeData().colorScheme.secondary,
                      onPressed: () {
                        envController.isPlaying.value
                            ? envController.pause()
                            : envController.play();
                      },
                      icon: Obx(() => envController.isPlaying.value
                          ? const Icon(Icons.pause)
                          : const Icon(Icons.play_arrow)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Wrap(
                  children: [
                    TextButton(
                      onPressed: () {
                        envController.setTitle("鸟鸣");
                        envController.changeAudio(
                            audio: "assets/audio/40s Birds Songs.MP3");
                      },
                      child: Obx(() => Text("@鸟鸣",
                          style: TextStyle(
                              color: envController.audioTitle.value == "鸟鸣"
                                  ? Colors.blue
                                  : ThemeData().colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold))),
                    ),
                    TextButton(
                        onPressed: () {
                          envController.setTitle("篝火");
                          envController.changeAudio(
                              audio: "assets/audio/40s Fire.MP3");
                        },
                        child: Obx(() => Text("@篝火",
                            style: TextStyle(
                                color: envController.audioTitle.value == "篝火"
                                    ? Colors.blue
                                    : ThemeData().colorScheme.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)))),
                    TextButton(
                      onPressed: () {
                        envController.setTitle("虫鸣");
                        envController.changeAudio(
                            audio: "assets/audio/40s Night.MP3");
                      },
                      child: Obx(() => Text("@虫鸣",
                          style: TextStyle(
                              color: envController.audioTitle.value == "虫鸣"
                                  ? Colors.blue
                                  : ThemeData().colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold))),
                    ),
                    TextButton(
                      onPressed: () {
                        envController.setTitle("细雨");
                        envController.changeAudio(
                            audio: "assets/audio/40s Rain Drop Lotus.MP3");
                      },
                      child: Obx(() => Text("@细雨",
                          style: TextStyle(
                              color: envController.audioTitle.value == "细雨"
                                  ? Colors.blue
                                  : ThemeData().colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold))),
                    ),
                    TextButton(
                      onPressed: () {
                        envController.setTitle("小溪");
                        envController.changeAudio(
                            audio: "assets/audio/40s Rivulet.MP3");
                      },
                      child: Obx(() => Text("@小溪",
                          style: TextStyle(
                              color: envController.audioTitle.value == "小溪"
                                  ? Colors.blue
                                  : ThemeData().colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold))),
                    ),
                    TextButton(
                      onPressed: () {
                        envController.setTitle("颂钵");
                        envController.changeAudio(
                            audio: "assets/audio/40s Singing Bowl.MP3");
                      },
                      child: Obx(() => Text("@颂钵",
                          style: TextStyle(
                              color: envController.audioTitle.value == "颂钵"
                                  ? Colors.blue
                                  : ThemeData().colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold))),
                    ),
                    TextButton(
                      onPressed: () {
                        envController.setTitle("水滴");
                        envController.changeAudio(
                            audio: "assets/audio/40s Water Drops.MP3");
                      },
                      child: Obx(() => Text("@水滴",
                          style: TextStyle(
                              color: envController.audioTitle.value == "水滴"
                                  ? Colors.blue
                                  : ThemeData().colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold))),
                    ),
                    TextButton(
                      onPressed: () {
                        //envController.setTimer(300);
                      },
                      child: Obx(() => Text(
                          "VOL ${(envController.maxVol.value * 100).toInt()}%",
                          style: TextStyle(
                            color: ThemeData().colorScheme.secondaryContainer,
                            fontSize: 12,
                          ))),
                    )
                  ],
                ),
              ),
              Container(
                height: 40,
                margin: const EdgeInsets.only(left: 40, right: 40),
                decoration: BoxDecoration(
                    color: ThemeData().colorScheme.secondaryContainer,
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: Row(
                  children: [
                    IconButton(
                      color: ThemeData().colorScheme.secondary,
                      onPressed: () {},
                      icon: const Icon(Icons.music_note),
                    ),
                    const Text("器乐"),
                    Expanded(
                        child: Obx(() => SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 1.0,
                              ),
                              child: Slider(
                                min: 0.0,
                                max: bgmController.dur.value.toDouble(),
                                activeColor: ThemeData().colorScheme.primary,
                                inactiveColor: ThemeData().colorScheme.surface,
                                thumbColor:
                                    ThemeData().colorScheme.primaryContainer,
                                value: bgmController.pos.value.toDouble(),
                                onChanged: (value) {
                                  bgmController.player.seek(
                                      Duration(milliseconds: value.toInt()));
                                },
                              ),
                            ))),
                    IconButton(
                      color: ThemeData().colorScheme.secondary,
                      onPressed: () {
                        bgmController.isPlaying.value
                            ? bgmController.pause()
                            : bgmController.play();
                      },
                      icon: Obx(() => bgmController.isPlaying.value
                          ? const Icon(Icons.pause)
                          : const Icon(Icons.play_arrow)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Wrap(
                  children: [
                    TextButton(
                      onPressed: () {
                        bgmController.setTitle("手碟");
                        bgmController.changeAudio(
                            audio: "assets/audio/BGM Hang.MP3");
                      },
                      child: Obx(() => Text("@手碟",
                          style: TextStyle(
                              color: bgmController.audioTitle.value == "手碟"
                                  ? Colors.blue
                                  : ThemeData().colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold))),
                    ),
                    TextButton(
                        onPressed: () {
                          bgmController.setTitle("钢琴");
                          bgmController.changeAudio(
                              audio: "assets/audio/BGM Piano.MP3");
                        },
                        child: Obx(() => Text("@钢琴",
                            style: TextStyle(
                                color: bgmController.audioTitle.value == "钢琴"
                                    ? Colors.blue
                                    : ThemeData().colorScheme.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)))),
                    TextButton(
                      onPressed: () {
                        bgmController.setTitle("吉他");
                        bgmController.changeAudio(
                            audio: "assets/audio/BGM Guitar.MP3");
                      },
                      child: Obx(() => Text("@吉他",
                          style: TextStyle(
                              color: bgmController.audioTitle.value == "吉他"
                                  ? Colors.blue
                                  : ThemeData().colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold))),
                    ),
                    TextButton(
                      onPressed: () {
                        bgmController.setTitle("长笛");
                        bgmController.changeAudio(
                            audio: "assets/audio/BGM Flute.MP3");
                      },
                      child: Obx(() => Text("@长笛",
                          style: TextStyle(
                              color: bgmController.audioTitle.value == "长笛"
                                  ? Colors.blue
                                  : ThemeData().colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold))),
                    ),
                    TextButton(
                      onPressed: () {
                        bgmController.setTitle("小提琴");
                        bgmController.changeAudio(
                            audio: "assets/audio/BGM Violin.MP3");
                      },
                      child: Obx(() => Text("@小提琴",
                          style: TextStyle(
                              color: bgmController.audioTitle.value == "小提琴"
                                  ? Colors.blue
                                  : ThemeData().colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold))),
                    ),
                    TextButton(
                      onPressed: () {
                        bgmController.setTitle("大提琴");
                        bgmController.changeAudio(
                            audio: "assets/audio/BGM Cello.MP3");
                      },
                      child: Obx(() => Text("@大提琴",
                          style: TextStyle(
                              color: bgmController.audioTitle.value == "大提琴"
                                  ? Colors.blue
                                  : ThemeData().colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold))),
                    ),
                    TextButton(
                      onPressed: () {
                        bgmController.setTitle("古筝");
                        bgmController.changeAudio(
                            audio: "assets/audio/BGM Guzheng.MP3");
                      },
                      child: Obx(() => Text("@古筝",
                          style: TextStyle(
                              color: bgmController.audioTitle.value == "古筝"
                                  ? Colors.blue
                                  : ThemeData().colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold))),
                    ),
                    TextButton(
                      onPressed: () {
                        //bgmController.setTimer(300);
                      },
                      child: Obx(() => Text(
                          "VOL ${(bgmController.maxVol.value * 100).toInt()}%",
                          style: TextStyle(
                            color: ThemeData().colorScheme.secondaryContainer,
                            fontSize: 12,
                          ))),
                    )
                  ],
                ),
              ),
              Container(
                height: 40,
                margin: const EdgeInsets.only(left: 40, right: 40),
                decoration: BoxDecoration(
                    color: ThemeData().colorScheme.secondaryContainer,
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: Row(
                  children: [
                    IconButton(
                      color: ThemeData().colorScheme.secondary,
                      onPressed: () {},
                      icon: const Icon(Icons.headphones),
                    ),
                    const Text("双耳节拍"),
                    //Expanded(child: BbtView()),
                    Expanded(
                        child: Obx(() => SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 1.0,
                              ),
                              child: Slider(
                                min: 0.0,
                                max: bbmController.dur.value.toDouble(),
                                activeColor: ThemeData().colorScheme.primary,
                                inactiveColor: ThemeData().colorScheme.surface,
                                thumbColor:
                                    ThemeData().colorScheme.primaryContainer,
                                value: bbmController.pos.value.toDouble(),
                                onChanged: (value) {
                                  bbmController.player.seek(
                                      Duration(milliseconds: value.toInt()));
                                },
                              ),
                            ))),
                    IconButton(
                      color: ThemeData().colorScheme.secondary,
                      onPressed: () {
                        if (bbmController.isPlaying.value) {
                          bbmController.isPlaying.value = false;
                          bbmController.pause();
                        } else {
                          bbmController.isPlaying.value = true;
                          bbmController.play();
                        }
                      },
                      icon: Obx(() => bbmController.isPlaying.value
                          ? const Icon(Icons.pause)
                          : const Icon(Icons.play_arrow)),
                    ),
                  ],
                ),
              ),
              Container(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Wrap(children: [
                    TextButton(
                      onPressed: () {
                        //bbtController.hz.value = 100;
                        bbmController.isPlaying.value = true;
                        bbmController.setTitle("德尔塔波1Hz助眠");
                        bbmController.changeAudio(
                            audio: "assets/audio/60s 1HZ.MP3");
                      },
                      child: Obx(() => Text("@德尔塔波1Hz助眠",
                          style: TextStyle(
                              color:
                                  bbmController.audioTitle.value == "德尔塔波1Hz助眠"
                                      ? Colors.blue
                                      : ThemeData().colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold))),
                    ),
                    TextButton(
                      onPressed: () {
                        //bbtController.hz.value = 40;
                        bbmController.isPlaying.value = true;
                        bbmController.setTitle("阿尔法波10Hz放松");
                        bbmController.changeAudio(
                            audio: "assets/audio/60s 10HZ.MP3");
                      },
                      child: Obx(() => Text("@阿尔法波10Hz放松",
                          style: TextStyle(
                              color:
                                  bbmController.audioTitle.value == "阿尔法波10Hz放松"
                                      ? Colors.blue
                                      : ThemeData().colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold))),
                    ),
                    TextButton(
                      onPressed: () {
                        //bbtController.hz.value = 10;
                        bbmController.isPlaying.value = true;
                        bbmController.setTitle("伽马波40Hz专注");
                        bbmController.changeAudio(
                            audio: "assets/audio/60s 40HZ.MP3");
                      },
                      child: Obx(() => Text("@伽马波40Hz专注",
                          style: TextStyle(
                              color:
                                  bbmController.audioTitle.value == "伽马波40Hz专注"
                                      ? Colors.blue
                                      : ThemeData().colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold))),
                    ),
                  ])),
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
