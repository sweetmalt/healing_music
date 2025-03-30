import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healing_music/controller/healing_controller.dart';
import 'package:healing_music/controller/players_controller.dart';
import 'package:healing_music/data/data.dart';

class VolumeView extends StatefulWidget {
  const VolumeView({super.key});

  @override
  VolumeViewState createState() => VolumeViewState();
}

class VolumeViewState extends State<VolumeView> with WidgetsBindingObserver {
  final HemController hemController = Get.put(HemController());
  final EnvController envController = Get.put(EnvController());
  final BgmController bgmController = Get.put(BgmController());
  final BbmController bbmController = Get.put(BbmController());

  final HealingController healingController = Get.find();
  final Map<String, double> _volumes = {
    'hem': 0.5,
    'env': 0.5,
    'bgm': 0.5,
    'bbm': 0.5
  };
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadVolumes();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _saveVolumes();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _saveVolumes();
    }
  }

  void _loadVolumes() {
    Data dataObj = Data(jsonFileName: "volume.json");
    dataObj.read().then((volumesData) {
      _volumes['hem'] = volumesData['hem'];
      _volumes['env'] = volumesData['env'];
      _volumes['bgm'] = volumesData['bgm'];
      _volumes['bbm'] = volumesData['bbm'];
      hemController.setMaxVol(_volumes['hem']!);
      envController.setMaxVol(_volumes['env']!);
      bgmController.setMaxVol(_volumes['bgm']!);
      bbmController.setMaxVol(_volumes['bbm']!);
    });
  }

  void _saveVolumes() {
    Data dataObj = Data(jsonFileName: "volume.json");
    dataObj.write(_volumes);
  }

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
                    Text('最高音量', style: Theme.of(context).textTheme.titleLarge),
                subtitle: const Text('限定各音乐元素的最高音量'),
                trailing: IconButton(
                  onPressed: () {
                    healingController.isMute.value =
                        !healingController.isMute.value;
                    hemController.setVolMute(healingController.isMute.value);
                    envController.setVolMute(healingController.isMute.value);
                    bgmController.setVolMute(healingController.isMute.value);
                    bbmController.setVolMute(healingController.isMute.value);
                  },
                  icon: Obx(() => healingController.isMute.value
                      ? const Icon(Icons.volume_off_sharp)
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
                             _volumes['hem'] = value;
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
                             _volumes['env'] = value;
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
                              _volumes['hem'] = value;
                              _volumes['env'] = 1 - value;
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
                            _volumes['bgm'] = value;
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
                            _volumes['bbm'] = value;
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
