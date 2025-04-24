import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healing_music/data/data.dart';
import 'package:healing_music/page/report_list_page.dart';

class AiTextView extends GetView {
  @override
  final ReporPageController controller;
  const AiTextView(this.controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ThemeData().colorScheme.primaryContainer,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(children: [
        TextButton(
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(
                ThemeData().colorScheme.surface,
              ),
            ),
            onPressed: () async {
              controller.isAiLoading.value = true;
              controller.aiText.value =
                  await Data.generateAiText(controller.aiPrompt);
              controller.isAiLoading.value = false;
            },
            child: Obx(() => controller.isAiLoading.value
                ? const CircularProgressIndicator()
                : const Text('AI解读-基于DeepSeek-V3'))),
        const SizedBox(
          height: 20,
        ),
        Obx(() => Text(
              controller.aiText.value,
              style: const TextStyle(
                fontSize: 16,
              ),
            ))
      ]),
    );
  }
}
