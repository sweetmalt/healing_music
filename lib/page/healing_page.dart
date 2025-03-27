import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healing_music/controller/players_controller.dart';
import 'package:healing_music/controller/healing_controller.dart';
import 'package:healing_music/controller/main_controller.dart';
import 'package:healing_music/data/audios.dart';
import 'package:healing_music/widget/brain_wave_view.dart';
import 'package:healing_music/widget/circular_button.dart';
import 'package:healing_music/widget/item.dart';
import 'package:healing_music/widget/page_title.dart';
import 'package:healing_music/widget/paragraph.dart';
import 'package:healing_music/widget/paragraph_bottom.dart';
import 'package:healing_music/widget/volume_view.dart';

class HealingPage extends StatelessWidget {
  HealingPage({super.key});
  final MainController mainController = Get.find();
  final HealingController healingController = Get.put(HealingController());
  final HemController hemController = Get.put(HemController());
  final EnvController envController = Get.put(EnvController());
  final BgmController bgmController = Get.put(BgmController());
  final BbmController bbmController = Get.put(BbmController());

  static const Audios _audios = Audios();

  void ctrlByPlan() {
    envController.play();
  }

  void quitCtrlByPlan() {
    hemController.stop();
    envController.stop();
    bgmController.stop();
    bbmController.stop();
    healingController.isCtrlByPlan.value = false;
  }

  @override
  Widget build(BuildContext context) {
    if (healingController.isCtrlByPlan.value) {
      ctrlByPlan();
    }
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
                      showDragHandle: true,
                      useRootNavigator: true,
                      isScrollControlled: true,
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.8,
                      ),
                      builder: (context) {
                        return BrainWaveView();
                      },
                    );
                  },
                  icon: healingController.isCtrlByDevice.value
                      ? Icons.bluetooth_audio
                      : Icons.bluetooth,
                ),
              ),
              const SizedBox(
                height: 10,
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
                          icon: healingController.isMute.value
                              ? Icons.volume_off_sharp
                              : Icons.volume_up_sharp,
                        ),
                      ),
                    ],
                  )),
              const SizedBox(
                height: 10,
              ),
              Obx(() => healingController.isCtrlByPlan.value
                  ? IntrinsicWidth(
                      child: Container(
                        height: 40,
                        //margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: ThemeData().colorScheme.secondaryContainer,
                            border: Border.all(
                                color: ThemeData().colorScheme.secondary,
                                width: 1),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        child: Text(hemController.timeMinutes.value,
                            style: TextStyle(
                                color: ThemeData().colorScheme.secondary,
                                fontSize: 30,
                                fontWeight: FontWeight.bold)),
                      ),
                    )
                  : Container()),
              const SizedBox(
                height: 1,
              ),
              Obx(() => healingController.isCtrlByPlan.value
                  ? PlanZone(
                      title: healingController.title.value,
                      subTitle: healingController.subTitle.value,
                      quitCtrlByPlan: quitCtrlByPlan,
                    )
                  : Container()),
              const SizedBox(height: 10),
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
              ToolsRow(
                audios: _audios.too,
                controller: healingController,
              ),
              Container(
                alignment: Alignment.center,
                height: 120,
                child: const Text("快乐疗愈生活"),
              ),
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

class ToolsRow extends StatelessWidget {
  final HealingController controller;
  final Map<String, String> audios;
  const ToolsRow({
    super.key,
    required this.controller,
    required this.audios,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      decoration: BoxDecoration(
          color: ThemeData().colorScheme.secondaryContainer,
          borderRadius: const BorderRadius.all(Radius.circular(5))),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: audios.entries.map<Widget>((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CircularButton(
                text: entry.value,
                icon: Icons.ring_volume,
                onPressed: () async {
                  controller.changeAudio("assets/audio/${entry.key}.MP3",
                      autoPlay: true);
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class PlanZone extends StatelessWidget {
  final VoidCallback quitCtrlByPlan;
  final String title;
  final String subTitle;
  const PlanZone(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.quitCtrlByPlan});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ParagraphListTile(
          title: title,
          icon: Icons.close,
          onTap: () {
            showConfirmationDialog(context);
          },
        ),
        ItemListTile(
          title: "XXX",
          subtitle: "xxx",
          onTap: () async {},
        ),
        ParagraphBottomListTile(
          title: subTitle,
          onTap: () {},
        ),
      ],
    );
  }

  Future<void> showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // 用户必须点击按钮才能关闭对话框
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('关闭当前自动任务'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('您确定要执行此操作吗？'),
                Text('此操作不可撤销。'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
              },
            ),
            TextButton(
              child: const Text('确认'),
              onPressed: () {
                // 在这里执行确认后的操作
                quitCtrlByPlan();
                Navigator.of(context).pop(); // 关闭对话框
              },
            ),
          ],
        );
      },
    );
  }
}
