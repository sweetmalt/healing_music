import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healing_music/controller/healing_controller.dart';
import 'package:healing_music/controller/main_controller.dart';
import 'package:healing_music/controller/players_controller.dart';
import 'package:healing_music/data/audios.dart';
import 'package:healing_music/data/data.dart';
import 'package:healing_music/widget/circular_button.dart';
import 'package:healing_music/widget/page_title.dart';

class AlbumPage extends StatelessWidget {
  final MainController mainController = Get.find();
  final HealingController healingController = Get.find();
  final HemController hemController = Get.find();
  final EnvController envController = Get.find();
  final BgmController bgmController = Get.find();
  final BbmController bbmController = Get.find();
  static const Audios _audios = Audios();
  final List<List> _pla = _audios.pla;
  AlbumPage({super.key});

  Future<void> _setTimer(String k, int v) async {
    healingController.isCtrlByPlan.value = true;
    healingController.isPauseCtrlByPlan.value = false;
    healingController.healingTimeIndex.value = 0;
    healingController.healingTimeKey.value = k;
    healingController.setTimer(v);
    Data dataObj = Data(jsonFileName: "healing.json");
    dataObj.read().then((healingPlan) {
      if (k != "") {
        var healingTimeData = healingPlan[k];
        if (healingTimeData is List) {
          List<Map<String, dynamic>> htd = healingTimeData
              .map((item) => Map<String, dynamic>.from(item))
              .toList();
          List temp = [];
          for (var i = 0; i < htd.length; i++) {
            //int start = htd[i]["start"] as int;
            //int end = htd[i]["end"] as int;
            String interval = htd[i]["interval"] as String;
            Map<String, String> task = Map<String, String>.from(htd[i]["task"]);
            String player = task["player"] ?? "";
            //String audio = task["audio"] ?? "";
            String healing = task["healing"] ?? "";
            temp.add("${i + 1}:$interval:$player:$healing");
          }
          healingController.healingTimeText.value = temp;
          healingController.healingTimeData = htd;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Image.asset(
        "assets/images/bgi.png",
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 50,
          title: PageTitle('Music Album'),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 40,
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  decoration: const BoxDecoration(),
                  child: Obx(() => Text(healingController.title.value,
                      style: TextStyle(
                          color: ThemeData().colorScheme.surface,
                          fontSize: 20,
                          fontWeight: FontWeight.bold))),
                ),
                Container(
                  height: 40,
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  decoration: const BoxDecoration(),
                  child: Text("疗愈时长选择",
                      style: TextStyle(
                          color: ThemeData().colorScheme.secondary,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ),
                for (int i = 0; i < _pla.length; i++)
                  Column(
                    children: [
                      Obx(() => CircularButton(
                            text: _pla[i][0],
                            icon:
                                healingController.healingTimeKeyIndex.value == i
                                    ? Icons.check_box_rounded
                                    : Icons.check_box_outline_blank_rounded,
                            onPressed: () async {
                              healingController.healingTimeKeyIndex.value = i;
                              await _setTimer(
                                  _pla[healingController
                                      .healingTimeKeyIndex.value][0],
                                  _pla[healingController
                                      .healingTimeKeyIndex.value][1]);
                            },
                          )),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                SizedBox(
                  height: 120,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                ThemeData().colorScheme.primaryContainer,
                            foregroundColor: ThemeData().colorScheme.primary,
                          ),
                          onPressed: () {
                            Get.back();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.navigate_before_rounded,
                                size: 20,
                                color: ThemeData().colorScheme.primary,
                              ),
                              Text(
                                '返回',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: ThemeData().colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                ThemeData().colorScheme.primaryContainer,
                            foregroundColor: ThemeData().colorScheme.primary,
                          ),
                          onPressed: () {
                            mainController.changePage(1);
                            Get.back(closeOverlays: true);
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '确定',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: ThemeData().colorScheme.primary,
                                ),
                              ),
                              Icon(
                                Icons.navigate_next_rounded,
                                size: 20,
                                color: ThemeData().colorScheme.primary,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    ]);
  }
}
