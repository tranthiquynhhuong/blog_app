import 'package:flutter/material.dart';
import 'package:simple_blog_app/Res/color.dart';

class St {
  St._();

  static const title1 = TextStyle(
    fontSize: 38,
    fontWeight: FontWeight.w600,
    letterSpacing: 2,
  );

  static const title2 = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w600,
  );

  static const subtitle1 = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w400,
  );

  static const normal1 = TextStyle(
    fontSize: 14,
  );

  static const title_drawer = TextStyle(
    fontSize: 14,
    color: Cl.col2_pink,
  );

  static const title_col2_pink = TextStyle(
    fontSize: 17,
    color: Cl.col2_pink,
  );

  // main profile
  static const title_main_profile = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
  );

  static const subTitle_main_profile = TextStyle(
    fontSize: 15,
  );

  static const username_profile = TextStyle(
    fontSize: 17,
    color: Cl.col2_pink,
    fontWeight: FontWeight.bold,
  );

  static const empty_notice = TextStyle(
    fontSize: 17,
    color: Colors.blueGrey,
  );
}
