import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:healing_music/controller/healing_controller.dart';
import 'package:healing_music/controller/main_controller.dart';
import 'package:healing_music/controller/players_controller.dart';
import 'package:healing_music/page/music_album.dart';
import 'package:healing_music/widget/page_title.dart';
import 'package:healing_music/widget/paragraph.dart';
import 'package:healing_music/widget/item.dart';
import 'package:healing_music/widget/paragraph_bottom.dart';

class MusicPage extends StatelessWidget {
  MusicPage({super.key});
  final MainController mainController = Get.find();
  final HealingController healingController = Get.put(HealingController());
  final EnvController envController = Get.put(EnvController());
  final HemController hemController = Get.put(HemController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 25,
        title: PageTitle('Audio & Music'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          ParagraphListTile(
            title: '全息能量',
            onTap: () {},
          ),
          ItemListTile(
            title: '全息963HZ & 鸟鸣',
            subtitle: '963HZ,Birds Songs',
            onTap: () async {
              healingController.title.value = '全息能量';
              hemController.setTitle('全息963HZ');
              await hemController.changeAudio(
                  audio: "assets/audio/90s 963HZ.MP3", autoPlay: false);
              envController.setTitle('鸟鸣');
              await envController.changeAudio(
                  audio: "assets/audio/40s Birds Songs.MP3", autoPlay: false);
              Get.to(AlbumPage());
            },
          ),
          ParagraphBottomListTile(
            title:
                '在全息能量SPA中，我们为您精心挑选了963HZ & 鸟鸣音乐，其和谐的旋律和深邃的音波能够帮助您全身心地放松，达到身心灵的完美和谐。让音乐的疗愈力量，带您进入一个全方位的能量平衡之旅。',
            onTap: () {},
          ),
          ParagraphListTile(
            title: '头部 松果体 睡眠能量',
            onTap: () {},
          ),
          ItemListTile(
            title: '睡眠852HZ & 篝火',
            subtitle: '852HZ,Fire',
            onTap: () async {
              healingController.title.value = '头部 松果体 睡眠能量';
              hemController.setTitle('睡眠852HZ');
              await hemController.changeAudio(
                  audio: "assets/audio/90s 852HZ.MP3", autoPlay: false);
              envController.setTitle('篝火');
              await envController.changeAudio(
                  audio: "assets/audio/40s Fire.MP3", autoPlay: false);

              Get.to(AlbumPage());
            },
          ),
          ParagraphBottomListTile(
            title:
                '为了帮助您在睡眠能量SPA中更好地放松头部，我们特别推荐852HZ & 篝火音乐，它能够温和地调节您的脑波，配合自然白噪音，让您的大脑迅速进入深度放松状态，一夜好眠，从此告别失眠困扰。',
            onTap: () {},
          ),
          ParagraphListTile(
            title: '喉部 甲状腺 代谢能量',
            onTap: () {},
          ),
          ItemListTile(
            title: '代谢714HZ & 虫鸣',
            subtitle: '714HZ,Night',
            onTap: () async {
              healingController.title.value = '喉部 甲状腺 代谢能量';
              hemController.setTitle('代谢714HZ');
              await hemController.changeAudio(
                  audio: "assets/audio/90s 714HZ.MP3", autoPlay: false);
              envController.setTitle('虫鸣');
              await envController.changeAudio(
                  audio: "assets/audio/40s Night.MP3", autoPlay: false);

              Get.to(AlbumPage());
            },
          ),
          ParagraphBottomListTile(
            title:
                '代谢能量SPA搭配714HZ & 虫鸣音乐，能够有效刺激甲状腺，提升新陈代谢。清新的旋律如同春日里的微风，让您的喉部得到彻底的放松，身体活力自然提升。',
            onTap: () {},
          ),
          ParagraphListTile(
            title: '胸部 胸腺 免疫能量',
            onTap: () {},
          ),
          ItemListTile(
            title: '免疫639HZ & 细雨',
            subtitle: '639HZ,Rain Drop Lotus',
            onTap: () async {
              healingController.title.value = '胸部 胸腺 免疫能量';
              hemController.setTitle('免疫639HZ');
              await hemController.changeAudio(
                  audio: "assets/audio/90s 639HZ.MP3", autoPlay: false);
              envController.setTitle('细雨');
              await envController.changeAudio(
                  audio: "assets/audio/40s Rain Drop Lotus.MP3",
                  autoPlay: false);

              Get.to(AlbumPage());
            },
          ),
          ParagraphBottomListTile(
            title:
                '免疫能量SPA结合639HZ & 细雨音乐，其温暖宁静的和声能够滋养您的胸腺，增强免疫系统。让音乐的疗愈力量，为您的健康保驾护航。',
            onTap: () {},
          ),
          ParagraphListTile(
            title: '腹部 胰腺 消化能量',
            onTap: () {},
          ),
          ItemListTile(
            title: '消化528HZ & 小溪',
            subtitle: '528HZ,Rivulet',
            onTap: () async {
              healingController.title.value = '腹部 胰腺 消化能量';
              hemController.setTitle('消化528HZ');
              await hemController.changeAudio(
                  audio: "assets/audio/90s 528HZ.MP3", autoPlay: false);
              envController.setTitle('小溪');
              await envController.changeAudio(
                  audio: "assets/audio/40s Rivulet.MP3", autoPlay: false);

              Get.to(AlbumPage());
            },
          ),
          ParagraphBottomListTile(
            title:
                '在消化能量SPA中，我们为您准备了528HZ & 小溪流音乐，其流畅的节奏能够按摩您的腹部，促进胰腺功能，帮助消化吸收。让音乐成为您消化健康的温柔守护者。',
            onTap: () {},
          ),
          ParagraphListTile(
            title: '生殖系统 性腺 幸福能量',
            onTap: () {},
          ),
          ItemListTile(
            title: '幸福417HZ & 颂钵',
            subtitle: '417HZ,Singing Bowl',
            onTap: () async {
              healingController.title.value = '生殖系统 性腺 幸福能量';
              hemController.setTitle('幸福417HZ');
              await hemController.changeAudio(
                  audio: "assets/audio/90s 417HZ.MP3", autoPlay: false);
              envController.setTitle('颂钵');
              await envController.changeAudio(
                  audio: "assets/audio/40s Singing Bowl.MP3", autoPlay: false);

              Get.to(AlbumPage());
            },
          ),
          ParagraphBottomListTile(
            title:
                '幸福能量SPA搭配柔和旋律的417HZ & 颂钵音乐，能够激发性腺的活力，提升情感体验。用音乐的力量，唤醒您内心的幸福感，增进生活的和谐与美好。',
            onTap: () {},
          ),
          ParagraphListTile(
            title: '腰部 肾上腺 动力能量',
            onTap: () {},
          ),
          ItemListTile(
            title: '动力396HZ & 水滴',
            subtitle: '396HZ,Water Drops',
            onTap: () async {
              healingController.title.value = '腰部 肾上腺 动力能量';
              hemController.setTitle('动力396HZ');
              await hemController.changeAudio(
                  audio: "assets/audio/90s 396HZ.MP3", autoPlay: false);
              envController.setTitle('水滴');
              await envController.changeAudio(
                  audio: "assets/audio/40s Water Drops.MP3", autoPlay: false);

              Get.to(AlbumPage());
            },
          ),
          ParagraphBottomListTile(
            title:
                '动力能量SPA结合396HZ & 水滴音乐，能够激发肾上腺素的分泌，提升您的活力和动力。如同您内心的独白，让您在面对挑战时充满自信。',
            onTap: () {},
          ),
          Container(
            height: 120,
          )
        ],
      ),
    );
  }
}
