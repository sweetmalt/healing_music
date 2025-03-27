import 'package:flutter/material.dart';
import 'package:healing_music/style/style.dart';

class ParagraphTitle extends Text {
  ParagraphTitle(super.data, {super.key})
      : super(
          style: MyStyle.paragraphTitleTextStyle,
        );
}

class ParagraphListTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final IconData? icon;

  const ParagraphListTile({
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
        color: ThemeData().colorScheme.primaryContainer,
        border: Border(
          top: BorderSide(
              color: ThemeData().colorScheme.primary, width: 5), // 顶部边框
          left: BorderSide(
              color: ThemeData().colorScheme.primary, width: 3), // 左侧边框
          right: BorderSide(
              color: ThemeData().colorScheme.primary, width: 3), // 右侧边框
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10), // 左上角圆角
          topRight: Radius.circular(10), // 右上角圆角
        ),
      ),
      child: ListTile(
        title: ParagraphTitle(title),
        trailing: Icon(
          icon,//Icons.attach_file,
          size: 15,
        ),
        onTap: onTap,
      ),
    );
  }
}

class UserParagraphListTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const UserParagraphListTile({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40, left: 10, right: 10),
      decoration: const BoxDecoration(
        color: Color.fromARGB(200, 255, 255, 255),
        border: Border(
          top: BorderSide(color: Colors.white, width: 5), // 顶部边框
          left: BorderSide(color: Colors.white, width: 3), // 左侧边框
          right: BorderSide(color: Colors.white, width: 3), // 右侧边框
          bottom: BorderSide(color: Colors.white, width: 1), // 底部边框
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10), // 左上角圆角
          topRight: Radius.circular(10), // 右上角圆角
        ),
      ),
      child: ListTile(
        title: ParagraphTitle(title),
        trailing: IconButton(
            onPressed: onTap,
            icon: const Icon(
              Icons.edit,
              size: 15,
            )),
        //onTap: onTap,
      ),
    );
  }
}

class AlbumParagraphListTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const AlbumParagraphListTile({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40, left: 10, right: 10),
      decoration: const BoxDecoration(
        color: Color.fromARGB(200, 255, 255, 255),
        border: Border(
          top: BorderSide(color: Colors.white, width: 5), // 顶部边框
          left: BorderSide(color: Colors.white, width: 3), // 左侧边框
          right: BorderSide(color: Colors.white, width: 3), // 右侧边框
          bottom: BorderSide(color: Colors.white, width: 1), // 底部边框
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10), // 左上角圆角
          topRight: Radius.circular(10), // 右上角圆角
        ),
      ),
      child: ListTile(
        title: ParagraphTitle(title),
        trailing: const Icon(
          Icons.music_note,
          size: 15,
        ),
        onTap: onTap,
      ),
    );
  }
}
