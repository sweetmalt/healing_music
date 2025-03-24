import 'package:flutter/material.dart';
import 'package:healing_music/style/style.dart';

class PageTitle extends Text {
   PageTitle(super.data, {super.key})
      : super(
          style: MyStyle.pageTitleTextStyle,
        );
}