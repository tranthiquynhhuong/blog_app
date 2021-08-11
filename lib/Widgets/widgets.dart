import 'package:flutter/material.dart';
import 'package:simple_blog_app/Res/color.dart';

Widget appCircularProgressIndicator() {
  return CircularProgressIndicator(
    backgroundColor: Colors.white,
    valueColor: AlwaysStoppedAnimation<Color>(Cl.col1_pink_weight),
  );
}

Widget centerAppCircularProgressIndicator() {
  return Center(
    child: CircularProgressIndicator(
      backgroundColor: Colors.white,
      valueColor: AlwaysStoppedAnimation<Color>(Cl.col1_pink_weight),
    ),
  );
}
