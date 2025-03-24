import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healing_music/controller/binaural_beat_controller.dart';

class BinauralBeatForm extends StatelessWidget {
  final BinauralBeatController bbController = Get.put(BinauralBeatController());
  BinauralBeatForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
      child: ListView(
        children: [
          Obx(() => SwitchListTile(
                title: const Text('德尔塔波(1HZ)-助眠'),
                value: bbController.deltaWave.value,
                onChanged: (value) {
                  bbController.setDeltaWave(value);
                },
              )),
          Obx(() => SwitchListTile(
                title: const Text('阿尔法波(10HZ)-放松'),
                value: bbController.alphaWave.value,
                onChanged: (value) {
                  bbController.setAlphaWave(value);
                },
              )),
          Obx(() => SwitchListTile(
                title: const Text('伽马波(40HZ)-心流'),
                value: bbController.gammaWave.value,
                onChanged: (value) {
                  bbController.setGammaWave(value);
                },
              )),
        ],
      ),
    );
  }
}
