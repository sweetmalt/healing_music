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
import 'package:healing_music/widget/report_view.dart';
import 'package:healing_music/widget/volume_view.dart';

class HealingPage extends GetView<HealingController> {
  HealingPage({super.key});
  final MainController mainController = Get.find();
  final HealingController healingController = Get.put(HealingController());
  final ReportViewController reportViewController =
      Get.put(ReportViewController());
  final HemController hemController = Get.put(HemController());
  final EnvController envController = Get.put(EnvController());
  final BgmController bgmController = Get.put(BgmController());
  final BbmController bbmController = Get.put(BbmController());

  static const Audios _audios = Audios();
  final List<String> currentPlayers = [
    "",
  ];
  Future<void> onTimePlanRun() async {
    int usedTimeSeconds = healingController.usedTimeSeconds.value;
    List<Map<String, dynamic>> htd = healingController.healingTimePlanData;
    for (var i = 0; i < htd.length; i++) {
      int start = htd[i]["start"] as int;
      int end = htd[i]["end"] as int;
      String interval = htd[i]["interval"] as String;
      Map<String, String> task = Map<String, String>.from(htd[i]["task"]);
      String player = task["player"] ?? "";

      //String audio = task["audio"] ?? "";
      String healing = task["healing"] ?? "";
      MyAudioCtrl audioCtrl = envController;
      switch (player) {
        case "脑波音频":
          audioCtrl = hemController;
          break;
        case "生境纯音":
          audioCtrl = envController;
          break;
        case "经典器乐":
          audioCtrl = bgmController;
          break;
        case "双耳节拍":
          audioCtrl = bbmController;
          break;
      }
      if (usedTimeSeconds == start) {
        healingController.healingTimePlanIndex.value = i;
        audioCtrl.play();
        currentPlayers[0] = player;
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text('$interval : $player : $healing'),
            duration: const Duration(seconds: 3),
            backgroundColor: Colors.deepPurple,
          ),
        );
      }
      if (usedTimeSeconds == end - 1) {
        audioCtrl.pause();
      }
    }
  }

  Future<void> onTimePlanEnd() async {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(
        content: Text('结束预编排音疗服务'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.deepPurple,
      ),
    );
    healingController.clearTimer();
    hemController.stop();
    envController.stop();
    bgmController.stop();
    bbmController.stop();
    //healingController.isCtrlByPlan.value = false;
  }

  Future<void> ctrlByTimePlan() async {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(
        content: Text('启动预编排音疗服务'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.deepPurple,
      ),
    );
    healingController.startTimer(onTimePlanRun, onTimePlanEnd);
    if (currentPlayers[0].isNotEmpty) {
      switch (currentPlayers[0]) {
        case "脑波音频":
          hemController.play();
          break;
        case "生境纯音":
          envController.play();
          break;
        case "经典器乐":
          bgmController.play();
          break;
        case "双耳节拍":
          bbmController.play();
          break;
      }
    }
  }

  Future<void> pauseCtrlByTimePlan() async {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(
        content: Text('暂停预编排音疗服务'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.deepPurple,
      ),
    );
    healingController.pauseTimer();
    hemController.pause();
    envController.pause();
    bgmController.pause();
    bbmController.pause();
  }

  Future<void> quitCtrlByTimePlan() async {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(
        content: Text('退出预编排音疗服务'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.deepPurple,
      ),
    );
    healingController.clearTimer();
    currentPlayers[0] = "";
    hemController.stop();
    envController.stop();
    bgmController.stop();
    bbmController.stop();
    healingController.isCtrlByTimePlan.value = false;
  }

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
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Obx(
                  () => CircularIconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        showDragHandle: true,
                        useRootNavigator: true,
                        isScrollControlled: true,
                        useSafeArea: true,
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.8,
                        ),
                        builder: (context) {
                          return BrainWaveView();
                        },
                      );
                    },
                    icon: healingController.isCtrlByDevice.value
                        ? Icons.media_bluetooth_on_rounded
                        : Icons.media_bluetooth_off_rounded,
                    backgroundColor: healingController.isDeviceLinking.value
                        ? Colors.green
                        : ThemeData().colorScheme.primaryContainer,
                    foregroundColor: healingController.isDeviceLinking.value
                        ? Colors.white
                        : ThemeData().colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 40),
                CircularIconButton(
                  onPressed: () {
                    if (healingController.receivedDataCount < 10) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('数据量太少，请确保设备连接正常后，过一分钟再试'),
                          duration: Duration(seconds: 3),
                          backgroundColor: Colors.deepPurple,
                        ),
                      );
                      return;
                    }

                    reportViewController.energyScaling();

                    showModalBottomSheet(
                      context: context,
                      showDragHandle: true,
                      useRootNavigator: true,
                      isScrollControlled: true,
                      useSafeArea: true,
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.8,
                      ),
                      builder: (context) {
                        return ReportView();
                      },
                    );
                  },
                  icon: Icons.menu_book_rounded,
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ]),
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
                          backgroundColor: hemController.colorSwitch.value
                              ? hemController.switchColors[0]
                              : hemController.switchColors[1],
                          valueColor: hemController.colorSwitch.value
                              ? hemController.switchColors[1]
                              : hemController.switchColors[0]),
                      CircularProgress(
                          radius: 100,
                          value:
                              envController.pos.value / envController.dur.value,
                          backgroundColor: envController.colorSwitch.value
                              ? envController.switchColors[0]
                              : envController.switchColors[1],
                          valueColor: envController.colorSwitch.value
                              ? envController.switchColors[1]
                              : envController.switchColors[0]),
                      CircularProgress(
                          radius: 80,
                          value:
                              bgmController.pos.value / bgmController.dur.value,
                          backgroundColor: bgmController.colorSwitch.value
                              ? bgmController.switchColors[0]
                              : bgmController.switchColors[1],
                          valueColor: bgmController.colorSwitch.value
                              ? bgmController.switchColors[1]
                              : bgmController.switchColors[0]),
                      CircularProgress(
                          radius: 60,
                          value:
                              bbmController.pos.value / bbmController.dur.value,
                          backgroundColor: bbmController.colorSwitch.value
                              ? bbmController.switchColors[0]
                              : bbmController.switchColors[1],
                          valueColor: bbmController.colorSwitch.value
                              ? bbmController.switchColors[1]
                              : bbmController.switchColors[0]),
                      Obx(
                        () => CircularIconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              showDragHandle: true,
                              useRootNavigator: true,
                              isScrollControlled: true,
                              useSafeArea: true,
                              constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.6,
                              ),
                              builder: (context) {
                                return const VolumeView();
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
              Obx(() => healingController.isCtrlByTimePlan.value
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
                                const BorderRadius.all(Radius.circular(5))),
                        child: Text(
                            "${healingController.healingTimePlanKey} - ${healingController.textTimeSeconds.value}",
                            style: TextStyle(
                                color: ThemeData().colorScheme.secondary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ),
                    )
                  : Container()),
              Obx(() => healingController.isCtrlByTimePlan.value
                  ? PlanZone(
                      ctrlByTimePlan: ctrlByTimePlan,
                      pauseCtrlByTimePlan: pauseCtrlByTimePlan,
                      quitCtrlByTimePlan: quitCtrlByTimePlan,
                      title: healingController.title.value,
                      subTitle: healingController.subTitle.value,
                      audioTitle: healingController.audioTitle.value,
                      audioSubTitle: healingController.audioSubTitle.value,
                      isTimerRunning: healingController.isTimerRunning.value,
                      isShowDetails: healingController.isShowDetails.value,
                      onLeadingTap: () => {
                        healingController.isShowDetails.value =
                            !healingController.isShowDetails.value
                      },
                      leadingIcon: healingController.isShowDetails.value
                          ? Icons.keyboard_double_arrow_up
                          : Icons.keyboard_double_arrow_down,
                      healingTimeText:
                          healingController.healingTimePlanTexts.toList(),
                      healingTimeIndex:
                          healingController.healingTimePlanIndex.value,
                    )
                  : Container()),
              const SizedBox(height: 10),
              PlayBox(
                title: "脑波音频",
                controller: hemController,
              ),
              AudiosRow(
                audios: _audios.hem,
                controller: hemController,
              ),
              PlayBox(
                title: "生境纯音",
                controller: envController,
              ),
              AudiosRow(
                audios: _audios.env,
                controller: envController,
              ),
              PlayBox(
                title: "经典器乐",
                controller: bgmController,
              ),
              AudiosRow(
                audios: _audios.bgm,
                controller: bgmController,
              ),
              PlayBox(
                title: "双耳节拍",
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
                child: const Text("音乐疗愈美好生活"),
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
        strokeWidth: 1,
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
  final RxBool repeatAll = false.obs;
  PlayBox({
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
            onPressed: () {
              //repeatAll.value = !repeatAll.value;
            },
            icon: Obx(() => repeatAll.value
                ? const Icon(Icons.repeat_rounded)
                : const Icon(Icons
                    .repeat_one_rounded)), //const Icon(Icons.repeat_one_rounded),
          ),
          Text(title),
          const SizedBox(
            width: 10,
          ),
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
                        onChangeStart: (value) => {controller.pause()},
                        onChanged: (value) {
                          controller.pos.value = value.toDouble();
                        },
                        onChangeEnd: (value) {
                          controller.player
                              .seek(Duration(milliseconds: value.toInt()));
                          controller.play();
                        }),
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
  final VoidCallback ctrlByTimePlan;
  final VoidCallback pauseCtrlByTimePlan;
  final VoidCallback quitCtrlByTimePlan;
  final String title;
  final String subTitle;
  final String audioTitle;
  final String audioSubTitle;
  final List healingTimeText;
  final int healingTimeIndex;
  final bool isTimerRunning;
  final bool isShowDetails;
  final VoidCallback onLeadingTap;
  final IconData leadingIcon;
  const PlanZone(
      {super.key,
      required this.ctrlByTimePlan,
      required this.pauseCtrlByTimePlan,
      required this.quitCtrlByTimePlan,
      required this.title,
      required this.subTitle,
      required this.audioTitle,
      required this.audioSubTitle,
      required this.healingTimeText,
      required this.healingTimeIndex,
      required this.isTimerRunning,
      required this.isShowDetails,
      required this.onLeadingTap,
      required this.leadingIcon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ParagraphListTile(
          onLeadingTap: onLeadingTap,
          leadingIcon: leadingIcon,
          title: title,
          icon: Icons.close,
          onTap: () {
            showConfirmationDialog(context);
          },
        ),
        isShowDetails
            ? ItemListTile(
                title: audioTitle,
                subtitle: audioSubTitle,
                icon: isTimerRunning ? Icons.pause : Icons.play_arrow,
                onTap: () async {
                  if (isTimerRunning) {
                    pauseCtrlByTimePlan();
                  } else {
                    ctrlByTimePlan();
                  }
                },
              )
            : Container(),
        isShowDetails
            ? HealingItemListTile(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: healingTimeText.map((healingTime) {
                    int i = getNumberBeforeColon(healingTime);
                    return Text(
                      healingTime,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: (i - 1 == healingTimeIndex)
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: (i - 1 == healingTimeIndex)
                              ? ThemeData().colorScheme.primary
                              : Colors.grey),
                    );
                  }).toList(),
                ),
              )
            : Container(),
        isShowDetails
            ? ParagraphBottomListTile(
                title: subTitle,
                onTap: () {},
              )
            : Container(),
      ],
    );
  }

  int getNumberBeforeColon(String healingTime) {
    RegExp regex = RegExp(r'(\d+):');
    Match? match = regex.firstMatch(healingTime);
    if (match != null && match.groupCount > 0) {
      String numberString = match.group(1)!;
      return int.parse(numberString);
    } else {
      return 0;
    }
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
                quitCtrlByTimePlan();
                Navigator.of(context).pop(); // 关闭对话框
              },
            ),
          ],
        );
      },
    );
  }
}
