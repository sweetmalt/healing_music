import 'package:flutter/material.dart';
import 'package:healing_music/style/style.dart';
import 'package:healing_music/widget/circular_button.dart';

class ItemTitle extends Text {
  ItemTitle(super.data, {super.key})
      : super(
          style: MyStyle.itemTitleTextStyle,
        );
}

class ItemSubtitle extends Text {
  ItemSubtitle(super.data, {super.key})
      : super(
          style: MyStyle.itemSubtitleTextStyle,
        );
}

class AlbumItemTitle extends Text {
  const AlbumItemTitle(super.data, {super.key})
      : super(
          style: MyStyle.albumItemTitleTextStyle,
        );
}

class AlbumItemSubtitle extends Text {
  const AlbumItemSubtitle(super.data, {super.key})
      : super(
          style: MyStyle.albumItemSubtitleTextStyle,
        );
}

class ItemListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final IconData icon;

  const ItemListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
              color: ThemeData().colorScheme.primary, width: 3), // 左侧边框
          right: BorderSide(
              color: ThemeData().colorScheme.primary, width: 3), // 右侧边框
        ),
      ),
      child: ListTile(
        tileColor: ThemeData().colorScheme.secondaryContainer,
        title: ItemTitle(title),
        subtitle: ItemSubtitle(subtitle),
        trailing: CircularIconButton(
          onPressed: () {
            onTap();
          },
          icon: icon,//Icons.play_arrow,
        ),
        onTap: onTap,
      ),
    );
  }
}
class HealingItemListTile extends StatelessWidget {
  final Widget child;

  const HealingItemListTile({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20,top: 10, bottom: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
              color: ThemeData().colorScheme.primary, width: 3), // 左侧边框
          right: BorderSide(
              color: ThemeData().colorScheme.primary, width: 3), // 右侧边框
        ),
      ),
      child: child,
    );
  }
}

class UserItemListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const UserItemListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      decoration: const BoxDecoration(
        color: Color.fromARGB(200, 255, 255, 255),
        border: Border(
          bottom: BorderSide(
              color: Color.fromARGB(66, 255, 255, 255), width: 1), // 顶部边框
          left: BorderSide(color: Colors.white, width: 3), // 左侧边框
          right: BorderSide(color: Colors.white, width: 3), // 右侧边框
        ),
      ),
      child: ListTile(
        title: ItemTitle(title),
        subtitle: ItemSubtitle(subtitle),
        onTap: onTap,
      ),
    );
  }
}

class AlbumItemListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const AlbumItemListTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10),
      decoration: const BoxDecoration(
        color: Colors.grey,
        border: Border(
          bottom: BorderSide(
              color: Color.fromARGB(66, 255, 255, 255), width: 1), // 顶部边框
          left: BorderSide(color: Colors.white, width: 3), // 左侧边框
          right: BorderSide(color: Colors.white, width: 3), // 右侧边框
        ),
      ),
      child: ListTile(
        title: AlbumItemTitle(title),
        subtitle: AlbumItemSubtitle(subtitle),
        trailing: const Icon(
          Icons.play_arrow,
          size: 20,
          color: Colors.white,
        ),
        onTap: onTap,
      ),
    );
  }
}
