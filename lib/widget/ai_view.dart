import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healing_music/controller/depot_controller.dart';
import 'package:healing_music/data/data.dart';
import 'package:healing_music/page/report_list_page.dart';
import 'package:healing_music/widget/brain_wave_view.dart';

class AiTextView extends GetView {
  @override
  final ReporPageController controller;
  AiTextView(this.controller, {super.key});

  final DepotController depotController = Get.put(DepotController());
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: ThemeData().colorScheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: ThemeData().colorScheme.primaryContainer,
            width: 3,
          )),
      child: Column(children: [
        ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                ThemeData().colorScheme.primaryContainer,
              ),
            ),
            onPressed: () async {
              if (controller.isAiLoading.value == true) {
                return;
              }
              controller.isAiLoading.value = true;
              controller.aiText.value = await Data.generateAiText2(
                  controller.aiPrompt, depotController.user.bearer.value);
              await Data.write({"aiText": controller.aiText.value},
                  controller.aiTextFileName.value);
              controller.isAiLoading.value = false;
            },
            child: Obx(() => controller.isAiLoading.value
                ? const CircularProgressIndicator()
                : const Text('脑波 AI 情绪解读'))),
        const SizedBox(
          height: 20,
        ),
        Obx(() => Text(
              controller.isAiLoading.value ? "AI调用需要5~10秒，请耐心等待……" : "",
              style: const TextStyle(fontSize: 16),
            )),
        Obx(() => Text(
              controller.aiText.value,
              style: const TextStyle(fontSize: 16),
            )),
      ]),
    );
  }
}

class AiImageView extends GetView {
  @override
  final ReporPageController controller;
  AiImageView(this.controller, {super.key});
  final DepotController depotController = Get.put(DepotController());
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      decoration: BoxDecoration(
          color: ThemeData().colorScheme.surface,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: ThemeData().colorScheme.primaryContainer,
            width: 3,
          )),
      child: Column(children: [
        TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                ThemeData().colorScheme.primaryContainer,
              ),
            ),
            onPressed: () async {
              if (controller.isAiImageLoading.value == true) {
                return;
              }
              controller.isAiImageLoading.value = true;
              controller.aiImageUrl.value = await Data.generateAiImage(
                  controller.aiPrompt, depotController.user.bearer.value);
              controller.isAiImageExists.value = false;
              final timestamp = DateTime.now().millisecondsSinceEpoch;
              final newPath = "${controller.aiImageFilePath_}?v=$timestamp";
              controller.aiImageFilePath.value = newPath;
              await Data.downloadAndSaveImage(
                  controller.aiImageUrl.value, controller.aiImageFilePath_);
              await Data.downloadAndSaveImage(controller.aiImageUrl.value,
                  controller.aiImageFilePath.value);

              controller.isAiImageExists.value = true;
            },
            child: Obx(() => controller.isAiImageLoading.value
                ? const CircularProgressIndicator()
                : const Text('脑波 AI 写意绘画'))),
        const SizedBox(
          height: 20,
        ),
        Obx(() => !controller.isAiImageExists.value
            ? const SizedBox()
            : ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Image.file(
                  File(controller.aiImageFilePath.value),
                  //key: ValueKey("${DateTime.now().millisecondsSinceEpoch}"),
                  width: Get.width,
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                    if (frame != null) {
                      // 图片加载完成时触发
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        controller.isAiImageLoading.value = false;
                      });
                    }
                    return child;
                  },
                ),
                // Image.network(
                //   controller.aiImageUrl.value,
                //   width: Get.width,
                //   frameBuilder:
                //       (context, child, frame, wasSynchronouslyLoaded) {
                //     if (frame != null) {
                //       // 图片加载完成时触发
                //       WidgetsBinding.instance.addPostFrameCallback((_) {
                //         controller.isAiImageLoading.value = false;
                //       });
                //     }
                //     return child;
                //   },
                // ),
              )),
        Obx(() => controller.isAiImageExists.value &&
                !controller.isAiImageLoading.value
            ? ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    ThemeData().colorScheme.primaryContainer,
                  ),
                ),
                onPressed: () async {
                  await Data.saveImageToGallery(controller.aiImageFilePath_);
                },
                child: const Text("保存到相册"))
            : const SizedBox()),
        const SizedBox(
          height: 20,
        ),
        const Text("这张作品是您的大脑——这位神秘艺术大师的杰作和秘密的显化"),
        const Text("通过阅读它，您将更深了解自己的潜意识诉求，并与真实自我更好相处"),
        const Text("更多深度解读，请咨询您的专业顾问"),
      ]),
    );
  }
}

class SuggestView extends GetView {
  @override
  final ReporPageController controller;
  SuggestView(this.controller, {super.key});
  final DepotController deportController = Get.put(DepotController());
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: ThemeData().colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: ThemeData().colorScheme.primaryContainer,
              width: 3,
            )),
        child: Column(children: [
          ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                  ThemeData().colorScheme.primaryContainer,
                ),
              ),
              onPressed: () {
                controller.isShowSuggest.value =
                    !controller.isShowSuggest.value;
              },
              child: const Text('AI脑机-能量疗愈方案建议')),
          Obx(() => controller.isShowSuggest.value
              ? Column(children: [
                  const SizedBox(
                    height: 20,
                  ),
                  const Text("定制您的专属焕新之旅"),
                  const SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    title: Text(
                        "方案时间：${controller.formatTimestamp(controller.report['timestamp'])}"),
                  ),
                  ListTile(
                    title: Text('顾客昵称：${controller.report['nickname']}'),
                  ),
                  ListTile(
                    title: Text('顾客年龄：${controller.report['age']}岁'),
                  ),
                  ListTile(
                    title: Text(
                        '顾客性别：${controller.report['sex'] == 0 ? "男" : "女"}'),
                  ),
                  const ListTile(
                    title: Text('亲爱的朋友：'),
                    subtitle: Text(
                        "感谢您选择与我们共同踏上这段身心疗愈的旅程。通过精准的脑机接口设备与AI数据分析，我们聆听了您身体与心灵的“声音”，并为您量身定制了专属疗愈方案。此刻，您已迈出自我关怀的重要一步——愿这份方案如春日细雨，滋养您的能量场域，唤醒内在的平衡与活力，拥抱身心的温柔觉醒。"),
                  ),
                  ListTile(
                    title: const Text('【身心能量图谱与疗愈建议】'),
                    subtitle: Text(
                        "基于您的生理能量值（${controller.hrvEnergy.value}分）与心理能量值（${controller.bciEnergy.value}分）的综合分析，我们分析您的能量疗愈地图如下：（数值越低，代表越需要被疗愈的“缺失”方向）"),
                  ),
                  BciSliderBox(),
                  const ListTile(
                    title: Text('【疗愈方向详解】'),
                  ),
                  const ListTile(
                    title: Text('全息能量'),
                    subtitle: Text('''
              缺失：脊椎僵硬、头昏脑涨、神经紧张、焦虑不安
              改善：全身轻松、神清目明、轻松愉悦、气定神闲
              靶向：脑垂体
              五韵整合疗愈：色（全息光疗）+声（全息音疗）+香（全息和香）+味（全息茶）+触（睡眠能量霜与手法服务）
              '''),
                  ),
                  const ListTile(
                    title: Text('睡眠'),
                    subtitle: Text('''
              缺失：失眠头疼、记忆下降、容易困倦、容易伤感
              改善：安睡清醒、提升记忆、集中精力、开心觉醒
              靶向：松果体
              五韵整合疗愈：色（AI光疗）+声（AI音疗）+香（睡眠和香）+味（睡眠茶）+触（睡眠能量霜与手法服务）
              '''),
                  ),
                  const ListTile(
                    title: Text('代谢'),
                    subtitle: Text('''
              缺失：呼吸问题、肠胃问题、肩颈劳损、易胖易怒
              改善：呼吸顺畅、改善肠胃、身体轻松、情绪平和
              靶向：甲状腺
              五韵整合疗愈：色（AI光疗）+声（AI音疗）+香（代谢和香）+味（代谢茶）+触（代谢能量霜与手法服务）
              '''),
                  ),
                  const ListTile(
                    title: Text('免疫'),
                    subtitle: Text('''
              缺失：容易感冒、乳腺增生、皮肤暗淡、无力易胖
              改善：增强体质、改善结节、肤色改善、改变身形
              靶向：胸腺
              五韵整合疗愈：色（AI光疗）+声（AI音疗）+香（免疫和香）+味（免疫茶）+触（免疫能量霜与手法服务）
              '''),
                  ),
                  const ListTile(
                    title: Text('消化'),
                    subtitle: Text('''
              缺失：消化不良、大腹便便、气血亏虚、五心烦躁
              改善：调理脾胃、身线窈窕、气血旺盛、神清气爽
              靶向：胰腺
              五韵整合疗愈：色（AI光疗）+声（AI音疗）+香（消化和香）+味（消化茶）+触（消化能量霜与手法服务）
              '''),
                  ),
                  const ListTile(
                    title: Text('幸福'),
                    subtitle: Text('''
              缺失：月经不调、性欲降低、皮肤衰老、烦躁失眠
              改善：例假正常、敏感润滑、紧致细腻、心情愉悦
              靶向：性腺
              五韵整合疗愈：色（AI光疗）+声（AI音疗）+香（幸福和香）+味（幸福茶）+触（幸福能量霜与手法服务）
              '''),
                  ),
                  const ListTile(
                    title: Text('动力'),
                    subtitle: Text('''
              缺失：困倦乏力、长期便秘、腰腹肥胖、了无生趣
              改善：充满活力、肠清身轻、精神十足、热情积极
              靶向：肾上腺
              五韵整合疗愈：色（AI光疗）+声（AI音疗）+香（动力和香）+味（动力茶）+触（动力能量霜与手法服务）
              '''),
                  ),
                  const ListTile(
                    title: Text('【温馨提醒】'),
                    subtitle: Text('''
              1.具体疗愈方案选择，请咨询您的客户顾问。
              2.为您有更好的疗愈之旅，请您：
              '''),
                  ),
                  const ListTile(
                    leading: Icon(Icons.check_circle_outline),
                    title: Text('疗愈前：请提前远离电子屏幕，保持平静'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.check_circle_outline),
                    title: Text('疗愈中：穿戴我们提供的脑机设备，让AI实时优化服务'),
                  ),
                  const ListTile(
                    leading: Icon(Icons.check_circle_outline),
                    title: Text('疗愈后：静心休息，可再做一次检测以对比记录变化'),
                  ),
                  const ListTile(
                    title: Text('【结语】'),
                    subtitle: Text(
                        '亲爱的朋友，真正的疗愈始于对自我的慈悲觉察。请相信，每一刻的关照都会在时光中沉淀为生命的光彩。我们愿做您旅程中的温暖烛火，静候您绽放身心原生的力量。'),
                  ),
                  ListTile(
                    title: Text(
                        '您的专属疗愈师：${deportController.user.adminNickname.value}'),
                  ),
                  ListTile(
                    title:
                        Text('机构名称：${deportController.user.agencyName.value}'),
                  ),
                ])
              : const Text("点击按钮查看")),
        ]));
  }
}
