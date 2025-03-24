import 'package:flutter/material.dart';

class MyStyle {
  static TextStyle appBarTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: ThemeData().colorScheme.primary,
  );
  static TextStyle pageTitleTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: ThemeData().colorScheme.secondary,
  );
  static TextStyle paragraphTitleTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: ThemeData().colorScheme.primary,
  );
  static TextStyle paragraphBottomTitleTextStyle =
      TextStyle(fontSize: 12, color: ThemeData().colorScheme.secondary);
  static TextStyle itemTitleTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: ThemeData().colorScheme.secondary,
  );
  static TextStyle itemSubtitleTextStyle = TextStyle(
    fontSize: 12,
    color: ThemeData().colorScheme.primary,
  );

  static const TextStyle albumItemTitleTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static const TextStyle albumItemSubtitleTextStyle = TextStyle(
    fontSize: 12,
    color: Colors.white,
  );
}
