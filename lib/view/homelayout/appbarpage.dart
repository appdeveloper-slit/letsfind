import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/static_method.dart';
import '../../values/colors.dart';
import '../../values/dimens.dart';
import 'home.dart';

class appbarPageLayout extends AppBar {
  AppBar bar = AppBar(
    forceMaterialTransparency: true,
    backgroundColor: Clr().background,
    title: Image.asset(
      'assets/home_logo.png',
      height: Dim().d40,
      fit: BoxFit.fitHeight,
    ),
    centerTitle: true,
    leading: InkWell(
      onTap: () {
        // STM().back2Previous(ctx);
        // SharedPreferences sp = await SharedPreferences.getInstance();
        // sp.clear();

        scaffoldState.currentState!.openDrawer();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(55),
            color: Clr().primaryLightColor,
          ),
          width: 20,
          height: 20,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset("assets/menu.svg"),
          ),
        ),
      ),
    ),
    actions: [
      // Container(
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(55),
      //     color: Clr().primaryLightColor,
      //   ),
      //   width: 40,
      //   height: 40,
      //   child: Padding(
      //     padding: EdgeInsets.all(Dim().d12),
      //     child: SvgPicture.asset("assets/search.svg"),
      //   ),
      // ),
      // SizedBox(
      //   width: Dim().d12,
      // ),
      // Container(
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(55),
      //     color: Clr().primaryLightColor,
      //   ),
      //   width: 40,
      //   height: 40,
      //   child: Padding(
      //     padding: const EdgeInsets.all(10),
      //     child: SvgPicture.asset("assets/bell.svg"),
      //   ),
      // ),
      SizedBox(
        width: Dim().d12,
      ),
    ],
  );
}
