import 'package:flutter/material.dart';
import 'package:healing_music/style/style.dart';

class ParagraphTitle extends StatelessWidget {
  final String title;
  const ParagraphTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: MyStyle.paragraphTitleTextStyle,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class ParagraphListTile extends StatelessWidget {
  final VoidCallback? onLeadingTap;
  final IconData? leadingIcon;
  final String title;
  final VoidCallback onTap;
  final IconData? icon;

  const ParagraphListTile({
    super.key,
    this.onLeadingTap,
    this.leadingIcon,
    required this.title,
    required this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ThemeData().colorScheme.primaryContainer,
        border: Border(
          top: BorderSide(
              color: ThemeData().colorScheme.primary, width: 1), // 顶部边框
          left: BorderSide(
              color: ThemeData().colorScheme.primary, width: 1), // 左侧边框
          right: BorderSide(
              color: ThemeData().colorScheme.primary, width: 1), // 右侧边框
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10), // 左上角圆角
          topRight: Radius.circular(10), // 右上角圆角
        ),
      ),
      child: ListTile(
        horizontalTitleGap: 0,
        leading: leadingIcon != null
            ? IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onLeadingTap,
                icon: Icon(
                  leadingIcon,
                  size: 15,
                ))
            : null,
        title: ParagraphTitle(title),
        trailing: icon != null
            ? IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: onTap,
                icon: Icon(
                  icon,
                  size: 30,
                ), //Icons.attach_file,
              )
            : null,
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
