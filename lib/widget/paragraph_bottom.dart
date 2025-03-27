import 'package:flutter/material.dart';
import 'package:healing_music/style/style.dart';

class ParagraphBottomTitle extends Text {
  ParagraphBottomTitle(super.data, {super.key})
      : super(
          style: MyStyle.paragraphBottomTitleTextStyle,
        );
}

class ParagraphBottomListTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final IconData? icon;

  const ParagraphBottomListTile({
    super.key,
    required this.title,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
        color: ThemeData().colorScheme.secondaryContainer,
        border: Border(
          left: BorderSide(color: ThemeData().colorScheme.primary, width: 3), // 左侧边框
          right: BorderSide(color: ThemeData().colorScheme.primary, width: 3), // 右侧边框
          bottom: BorderSide(color: ThemeData().colorScheme.primary, width: 5), // 底部边框
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(10), // 左上角圆角
          bottomRight: Radius.circular(10), // 右上角圆角
        ),
      ),
      child: ListTile(
        title: ParagraphBottomTitle(title),
        trailing: Icon(
          icon,//Icons.auto_stories_outlined,
          size: 12,
        ),
        onTap: onTap,
      ),
    );
  }
}

class UserParagraphBottomListTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const UserParagraphBottomListTile({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      decoration: const BoxDecoration(
        color: Color.fromARGB(200, 255, 255, 255),
        border: Border(
          left: BorderSide(color: Colors.white, width: 3), // 左侧边框
          right: BorderSide(color: Colors.white, width: 3), // 右侧边框
          bottom: BorderSide(color: Colors.white, width: 5), // 底部边框
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10), // 左上角圆角
          bottomRight: Radius.circular(10), // 右上角圆角
        ),
      ),
      child: ListTile(
        title: ParagraphBottomTitle(title),
        trailing: const Icon(
          Icons.question_answer_outlined,
          size: 12,
        ),
        onTap: onTap,
      ),
    );
  }
}

class AlbumParagraphBottomListTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const AlbumParagraphBottomListTile({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      decoration: const BoxDecoration(
        color: Color.fromARGB(200, 255, 255, 255),
        border: Border(
          left: BorderSide(color: Colors.white, width: 3), // 左侧边框
          right: BorderSide(color: Colors.white, width: 3), // 右侧边框
          bottom: BorderSide(color: Colors.white, width: 5), // 底部边框
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10), // 左上角圆角
          bottomRight: Radius.circular(10), // 右上角圆角
        ),
      ),
      child: ListTile(
        title: ParagraphBottomTitle(title),
        trailing: const Icon(
          Icons.question_answer_outlined,
          size: 12,
        ),
        onTap: onTap,
      ),
    );
  }
}
