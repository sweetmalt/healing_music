import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healing_music/controller/healing_controller.dart';
import 'package:healing_music/controller/players_controller.dart';

class VolumeView extends StatelessWidget {
  final BgmController bgmController = Get.find();
  final EnvController envController = Get.find();
  final BbmController bbmController = Get.find();
  final HemController hemController = Get.find();

  final HealingController healingController = Get.find();

  VolumeView({
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
        child: Column(
          children: [
            ListTile(
                title:
                    Text('音量', style: Theme.of(context).textTheme.titleLarge),
                subtitle: const Text('调节各音乐元素的音量'),
                trailing: IconButton(
                  onPressed: () {
                    healingController.isMute.value =
                        !healingController.isMute.value;
                    if (healingController.isMute.value) {
                      bgmController.setMaxVol(0.001);
                      envController.setMaxVol(0.001);
                      bbmController.setMaxVol(0.001);
                      hemController.setMaxVol(0.001);
                    } else {
                      bgmController.setMaxVol(0.5);
                      envController.setMaxVol(0.5);
                      bbmController.setMaxVol(0.5);
                      hemController.setMaxVol(0.5);
                    }
                  },
                  icon: Obx(() => healingController.isMute.value
                      ? const Icon(
                          Icons.volume_off_sharp,
                          size: 40,
                        )
                      : const Icon(Icons.volume_up_sharp)),
                )),
            Row(
              children: [
                const Text('脑波音频'),
                Expanded(
                    child: Obx(() => Slider(
                          value: hemController.maxVol.value,
                          min: 0,
                          max: 1,
                          onChanged: (value) {
                            hemController.setMaxVol(value);
                          },
                        ))),
                Obx(() =>
                    Text('${(hemController.maxVol.value * 100).toInt()}%')),
              ],
            ),
            Row(
              children: [
                const Text('生境纯音'),
                Expanded(
                    child: Obx(() => Slider(
                          value: envController.maxVol.value,
                          min: 0,
                          max: 1,
                          onChanged: (value) {
                            envController.setMaxVol(value);
                          },
                        ))),
                Obx(() =>
                    Text('${(envController.maxVol.value * 100).toInt()}%')),
              ],
            ),
            const Text('脑波音频 & 生境纯音 均衡器'),
            Container(
              height: 60,
              padding: const EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                color: ThemeData().colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Obx(() => Text(
                      '脑波 ${(hemController.maxVol.value / (hemController.maxVol.value + envController.maxVol.value) * 100).toInt()}%')),
                  Expanded(
                      child: Obx(() => Slider(
                            value: hemController.maxVol.value /
                                (hemController.maxVol.value +
                                    envController.maxVol.value),
                            min: 0,
                            max: 1,
                            activeColor: ThemeData().colorScheme.surface,
                            inactiveColor: ThemeData().colorScheme.surface,
                            onChanged: (value) {
                              hemController.setMaxVol(value);
                              envController.setMaxVol(1 - value);
                            },
                          ))),
                  Obx(() => Text(
                      '${(envController.maxVol.value / (hemController.maxVol.value + envController.maxVol.value) * 100).toInt()}% 生境')),
                ],
              ),
            ),
            Row(
              children: [
                const Text('经典器乐'),
                Expanded(
                    child: Obx(() => Slider(
                          value: bgmController.maxVol.value,
                          min: 0,
                          max: 1,
                          onChanged: (value) {
                            bgmController.setMaxVol(value);
                          },
                        ))),
                Obx(() =>
                    Text('${(bgmController.maxVol.value * 100).toInt()}%')),
              ],
            ),
            Row(
              children: [
                const Text('双耳节拍'),
                Expanded(
                    child: Obx(() => Slider(
                          value: bbmController.maxVol.value,
                          min: 0,
                          max: 1,
                          onChanged: (value) {
                            bbmController.setMaxVol(value);
                          },
                        ))),
                Obx(() =>
                    Text('${(bbmController.maxVol.value * 100).toInt()}%')),
              ],
            ),
            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
