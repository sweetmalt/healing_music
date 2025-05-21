import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:healing_music/controller/depot_controller.dart';
import 'package:healing_music/controller/healing_controller.dart';
import 'package:healing_music/controller/main_controller.dart';
import 'package:healing_music/page/music_page.dart';
import 'package:healing_music/page/healing_page.dart';
import 'package:healing_music/page/depot_page.dart';
import 'package:healing_music/widget/brain_wave_view.dart';
import 'package:healing_music/widget/circular_button.dart';
import 'package:healing_music/widget/login_view.dart';

///
Color colorSurface = ThemeData().colorScheme.surface;
Color colorPrimary = ThemeData().colorScheme.primary;
Color colorPrimaryContainer = ThemeData().colorScheme.primaryContainer;
Color colorSecondary = ThemeData().colorScheme.secondary;
Color colorSecondaryContainer = ThemeData().colorScheme.secondaryContainer;
Color colorError = ThemeData().colorScheme.error;
List<Color> colorList = [
  Colors.purple,
  Colors.deepPurpleAccent,
  Colors.blue,
  Colors.green,
  Colors.yellow,
  Colors.orange,
  Colors.red,
  Colors.brown
];

class MainPage extends StatelessWidget {
  MainPage({super.key});
  final DepotController depotController = Get.put(DepotController());
  final HealingController healingController = Get.put(HealingController());
  @override
  Widget build(BuildContext context) {
    //开机显示face页面
    // Future.delayed(const Duration(seconds: 1), () {
    //   Get.to(() => const FacePage());
    // });
    return Scaffold(
      appBar: AppBar(
          elevation: 1,
          toolbarHeight: 100,
          leadingWidth: 100,
          backgroundColor: colorSurface,
          shadowColor: colorPrimaryContainer,
          title: const MyTextH1("脑波音疗"),
          leading: Row(children: [
            const SizedBox(width: 10),
            Obx(() => healingController.isDeviceLinking.value
                ? CircularIconButton(
                    foregroundColor: colorSurface,
                    backgroundColor: Colors.blue,
                    icon: Icons.bluetooth_audio_rounded,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        showDragHandle: true,
                        useRootNavigator: true,
                        isScrollControlled: true,
                        useSafeArea: true,
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.9,
                        ),
                        builder: (context) {
                          return BrainWaveView();
                        },
                      );
                    },
                  )
                : CircularIconButton(
                    foregroundColor: colorSurface,
                    backgroundColor: Colors.blue,
                    icon: Icons.bluetooth_rounded,
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        showDragHandle: true,
                        useRootNavigator: true,
                        isScrollControlled: true,
                        useSafeArea: true,
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.9,
                        ),
                        builder: (context) {
                          return BrainWaveView();
                        },
                      );
                    },
                  ))
          ]),
          actions: [
            //CircularIconButton(icon: Icons.share_rounded, onPressed: () {}),
            Obx(() => Text(
                '余额${depotController.user.tokens.value > 0 ? depotController.user.tokens.value : "不足"}')),
            CircularIconButton(
              icon: Icons.login_rounded,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  showDragHandle: true,
                  useRootNavigator: true,
                  isScrollControlled: true,
                  useSafeArea: true,
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.9,
                  ),
                  builder: (context) {
                    return LoginView();
                  },
                );
              },
            ),
            CircularIconButton(
              icon: Icons.adjust_rounded,
              onPressed: () {
                showLogoutDialog(context);
              },
            ),
            const SizedBox(width: 10),
          ]),
      body: GetX<MainController>(
        init: MainController(),
        builder: (controller) {
          return IndexedStack(
            index: controller.currentIndex.value,
            children: [
              MusicPage(),
              HealingPage(),
              DepotPage(),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBarWidget(),
    );
  }

  Future<void> showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // 用户必须点击按钮才能关闭对话框
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('退出程序'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('您确定要执行此操作吗？'),
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
                SystemNavigator.pop(); // 退出程序
              },
            ),
          ],
        );
      },
    );
  }
}

class BottomNavigationBarWidget extends StatelessWidget {
  BottomNavigationBarWidget({super.key});
  final MainController controller = Get.put(MainController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
          elevation: 3,
          selectedItemColor: Colors.blue,
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.blueGrey,
          iconSize: 30,
          selectedFontSize: 24,
          unselectedFontSize: 20,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.queue_music_rounded), label: '音乐'),
            BottomNavigationBarItem(
                icon: Icon(Icons.hearing_rounded), label: '疗愈'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: '我'),
          ],
        ));
  }
}

class MyTextH1 extends Text {
  final String text;
  const MyTextH1(this.text, {super.key}) : super('');
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 28,
        color: colorPrimary,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class MyTextH2 extends Text {
  final String text;
  const MyTextH2(this.text, {super.key}) : super('');
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 24,
        color: colorPrimary,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class MyTextH3 extends Text {
  final String text;
  final Color? foregroundColor;
  const MyTextH3(this.text, this.foregroundColor, {super.key}) : super('');
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        color: foregroundColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class MyTextP1 extends Text {
  final String text;
  const MyTextP1(this.text, {super.key}) : super('');
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20,
        color: colorSecondary,
      ),
    );
  }
}

class MyTextP2 extends Text {
  final String text;
  const MyTextP2(this.text, {super.key}) : super('');
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        color: colorSecondary,
      ),
    );
  }
}

class MyTextP3 extends Text {
  final String text;
  final Color? foregroundColor;
  const MyTextP3(this.text, this.foregroundColor, {super.key}) : super('');
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        color: foregroundColor,
      ),
    );
  }
}

class CircularIconTextButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  const CircularIconTextButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        iconSize: 40,
        minimumSize: const Size(100, 100),
        maximumSize: const Size(100, 100),
        fixedSize: const Size(100, 100),
        shape: const CircleBorder(),
        elevation: 0,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          MyTextP3(text, foregroundColor),
        ],
      ),
    );
  }
}

class LineIconTextButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  const LineIconTextButton({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        iconSize: 30,
        minimumSize: const Size(200, 40),
        maximumSize: const Size(400, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
      ),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          MyTextH3(text, foregroundColor),
        ],
      ),
    );
  }
}
