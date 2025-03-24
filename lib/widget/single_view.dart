import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healing_music/controller/healing_controller.dart';
import 'package:healing_music/widget/circular_button.dart';

class SingleView extends StatelessWidget {
  final HealingController controller = Get.find();
  SingleView({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: SingleChildScrollView(
            child: Column(children: [
          ListTile(
            title: Text('乐器', style: Theme.of(context).textTheme.titleLarge),
            subtitle: const Text('颂钵、雨棍、丁夏等疗愈专用乐器'),
            trailing: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.close)),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            CircularButton(
              text: '·颂钵·',
              icon: Icons.rice_bowl,
              onPressed: () async {
                await controller.singlePlayer
                    .setAsset("assets/audio/10s Singging Bowl.MP3");
                await controller.singlePlayer.play();
              },
            ),
            CircularButton(
              text: '·雨棍·',
              icon: Icons.line_style,
              onPressed: () async {
                await controller.singlePlayer
                    .setAsset("assets/audio/10s Rain Stick.MP3");
                await controller.singlePlayer.play();
              },
            ),
            CircularButton(
              text: '·丁夏·',
              icon: Icons.ring_volume,
              onPressed: () async {
                await controller.singlePlayer
                    .setAsset("assets/audio/10s Bell.MP3");
                await controller.singlePlayer.play();
              },
            ),
          ]),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            CircularButton(
              text: '风铃春',
              icon: Icons.more_horiz,
              onPressed: () async {
                await controller.singlePlayer
                    .setAsset("assets/audio/10s Wind Chime1.MP3");
                await controller.singlePlayer.play();
              },
            ),
            CircularButton(
              text: '风铃夏',
              icon: Icons.more_horiz,
              onPressed: () async {
                await controller.singlePlayer
                    .setAsset("assets/audio/10s Wind Chime2.MP3");
                await controller.singlePlayer.play();
              },
            ),
            CircularButton(
              text: '风铃秋',
              icon: Icons.more_horiz,
              onPressed: () async {
                await controller.singlePlayer
                    .setAsset("assets/audio/10s Wind Chime3.MP3");
                await controller.singlePlayer.play();
              },
            ),
          ]),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            CircularButton(
              text: '萨满鼓',
              icon: Icons.more_horiz,
              onPressed: () async {
                await controller.singlePlayer
                    .setAsset("assets/audio/10s Shaman Drum.MP3");
                await controller.singlePlayer.play();
              },
            ),
            CircularButton(
              text: '海浪鼓',
              icon: Icons.more_horiz,
              onPressed: () async {
                await controller.singlePlayer
                    .setAsset("assets/audio/10s Sea Wave Drum.MP3");
                await controller.singlePlayer.play();
              },
            ),
            CircularButton(
              text: '风铃冬',
              icon: Icons.more_horiz,
              onPressed: () async {
                await controller.singlePlayer
                    .setAsset("assets/audio/10s Wind Chime4.MP3");
                await controller.singlePlayer.play();
              },
            ),
          ]),
          const SizedBox(height: 100),
        ])));
  }
}
