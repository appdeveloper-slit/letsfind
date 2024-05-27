// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letsfind/sign_in.dart';
import 'package:letsfind/view/emergencyservices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import 'addestate/search_real_estate.dart';
import 'crime_report.dart';
import 'crimebranch/cb_home.dart';
import 'myprofile.dart';
import 'old_is_gold/old_is_gold.dart';

Widget navBar(context, scaffoldState, setState) {
  return SafeArea(
    child: WillPopScope(
      onWillPop: () async {
        if (scaffoldState.currentState.isDrawerOpen) {
          scaffoldState.currentState.openEndDrawer();
        }
        return true;
      },
      child: Drawer(
        width: MediaQuery.of(context).size.width * 0.75,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(color: Clr().white),
          child: WillPopScope(
            onWillPop: () async {
              if (scaffoldState.currentState!.isDrawerOpen) {
                scaffoldState.currentState!.openEndDrawer();
              }
              return true;
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    color: const Color(0xffCEE7FF),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: Dim().d20),
                        Image.asset(
                          "assets/logo.png",
                          width: Dim().d250,
                        ),
                        // SizedBox(height: Dim().d12),
                        // Text(
                        //   "Mobile Number : 2589745123",
                        //   style: Sty().microText.copyWith(color: Clr().white),
                        // ),
                      ],
                    ),
                    height: Dim().d180,
                  ),
                  SizedBox(
                    height: Dim().d8,
                  ),
                  ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SvgPicture.asset(
                        'assets/oldisgold.svg',
                      ),
                    ),
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: Dim().d12, vertical: Dim().d0),
                    title: Transform.translate(
                      offset: const Offset(-10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Old is Gold',
                            style: Sty().mediumText.copyWith(
                                fontSize: 14,
                                color: Clr().textcolor,
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: Dim().d14,
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      STM().redirect2page(context, OldIsGold());
                      // STM().finishAffinity(context, const AddBankAcc());
                      scaffoldState.currentState?.closeEndDrawer();
                    },
                  ),
                  ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SvgPicture.asset(
                        'assets/realestate.svg',
                      ),
                    ),
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: Dim().d12, vertical: Dim().d0),
                    title: Transform.translate(
                      offset: const Offset(-10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Real Estate',
                            style: Sty().mediumText.copyWith(
                                fontSize: 14,
                                color: Clr().textcolor,
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: Dim().d14,
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      // STM().redirect2page(context, NotificationPage());
                      STM().redirect2page(context, const SearchRealEstate());
                      scaffoldState.currentState?.closeEndDrawer();
                    },
                  ),
                  ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SvgPicture.asset(
                        'assets/matrimony.svg',
                      ),
                    ),
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: Dim().d12, vertical: Dim().d0),
                    title: Transform.translate(
                      offset: Offset(-10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Matrimony',
                            style: Sty().mediumText.copyWith(
                                fontSize: 14,
                                color: Clr().textcolor,
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: Dim().d14,
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      // STM().redirect2page(context, MyProfile());
                      scaffoldState.currentState?.closeEndDrawer();
                    },
                  ),
                  ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SvgPicture.asset(
                        'assets/jobsearch.svg',
                      ),
                    ),
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: Dim().d12, vertical: Dim().d0),
                    title: Transform.translate(
                      offset: Offset(-10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Job Search',
                            style: Sty().mediumText.copyWith(
                                fontSize: 14,
                                color: Clr().textcolor,
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: Dim().d14,
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      // STM().redirect2page(context, NotificationPage());
                      scaffoldState.currentState?.closeEndDrawer();
                    },
                  ),
                  ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SvgPicture.asset(
                        'assets/emergencyservices.svg',
                      ),
                    ),
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: Dim().d12, vertical: Dim().d0),
                    title: Transform.translate(
                      offset: Offset(-10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Emergency Services',
                            style: Sty().mediumText.copyWith(
                                fontSize: 14,
                                color: Clr().textcolor,
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: Dim().d14,
                          )
                        ],
                      ),
                    ),
                    onTap: () async {
                      STM().redirect2page(
                          context, const EmergensyServicesPage());
                      scaffoldState.currentState?.closeEndDrawer();
                    },
                  ),
                  ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SvgPicture.asset(
                        'assets/civilcrime.svg',
                      ),
                    ),
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: Dim().d12, vertical: Dim().d0),
                    title: Transform.translate(
                      offset: Offset(-10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Civil Crime Report',
                            style: Sty().mediumText.copyWith(
                                fontSize: 14,
                                color: Clr().textcolor,
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: Dim().d14,
                          ),
                        ],
                      ),
                    ),
                    onTap: () async {
                      STM().redirect2page(context, const CrimeReport());
                      scaffoldState.currentState?.closeEndDrawer();
                    },
                  ),
                  ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SvgPicture.asset(
                        'assets/myprofile.svg',
                      ),
                    ),
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: Dim().d12, vertical: Dim().d0),
                    title: Transform.translate(
                      offset: Offset(-10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'My Profile',
                            style: Sty().mediumText.copyWith(
                                fontSize: 14,
                                color: Clr().textcolor,
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: Dim().d14,
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      STM().redirect2page(context, const myprofilePage());
                      setState(() {
                        scaffoldState.currentState?.closeEndDrawer();
                      });
                    },
                  ),
                  ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SvgPicture.asset(
                        'assets/notification.svg',
                      ),
                    ),
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: Dim().d12, vertical: Dim().d0),
                    title: Transform.translate(
                      offset: const Offset(-10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Notifications',
                            style: Sty().mediumText.copyWith(
                                fontSize: 14,
                                color: Clr().textcolor,
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: Dim().d14,
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      scaffoldState.currentState?.closeEndDrawer();
                    },
                  ),
                  ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SvgPicture.asset(
                        'assets/privacypolicy.svg',
                      ),
                    ),
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: Dim().d12, vertical: Dim().d0),
                    title: Transform.translate(
                      offset: const Offset(-10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Privacy Policy',
                            style: Sty().mediumText.copyWith(
                                fontSize: 14,
                                color: Clr().textcolor,
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: Dim().d14,
                          )
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SvgPicture.asset(
                        'assets/termsandconditions.svg',
                      ),
                    ),
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: Dim().d12, vertical: Dim().d0),
                    title: Transform.translate(
                      offset: Offset(-10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Terms and Conditions',
                            style: Sty().mediumText.copyWith(
                                fontSize: 14,
                                color: Clr().textcolor,
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: Dim().d14,
                          )
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SvgPicture.asset(
                        'assets/refundpolicy.svg',
                      ),
                    ),
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: Dim().d12, vertical: Dim().d0),
                    title: Transform.translate(
                      offset: Offset(-10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Refund Policy',
                            style: Sty().mediumText.copyWith(
                                fontSize: 14,
                                color: Clr().textcolor,
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_outlined,
                            size: Dim().d14,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dim().d16,
                  ),
                  Padding(
                    padding: EdgeInsets.all(Dim().d20),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: Clr().white,
                                surfaceTintColor: Clr().white,
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: Dim().d12,
                                    ),
                                    Text('Logout?',
                                        style: Sty().largeText.copyWith(
                                            color: Clr().primaryColor,
                                            fontWeight: FontWeight.w800)),
                                    SizedBox(
                                      height: Dim().d12,
                                    ),
                                    Text('Are you sure want to Log Out?',
                                        style: Sty().mediumText),
                                    SizedBox(
                                      height: Dim().d28,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              STM().back2Previous(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Clr().white,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                Dim().d12)))),
                                            child: Center(
                                              child: Text('Cancel',
                                                  style: Sty()
                                                      .mediumText
                                                      .copyWith(
                                                          color: Clr()
                                                              .textcolor
                                                              .withOpacity(
                                                                  0.8))),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: Dim().d12,
                                        ),
                                        Expanded(
                                          child: ElevatedButton(
                                              onPressed: () async {
                                                SharedPreferences sp =
                                                    await SharedPreferences
                                                        .getInstance();
                                                sp.setBool('login', false);
                                                sp.clear();
                                                // ignore: use_build_context_synchronously
                                                STM().finishAffinity(
                                                    context, const SignIn());
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Clr().primaryColor,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  Dim().d12)))),
                                              child: Center(
                                                child: Text('Log Out',
                                                    style: Sty()
                                                        .mediumText
                                                        .copyWith(
                                                            color:
                                                                Clr().white)),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      child: Container(
                        height: Dim().d40,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Clr().primaryColor,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(Dim().d20),
                        ),
                        child: Center(
                          child: Text(
                            'Log out',
                            style: Sty()
                                .smallText
                                .copyWith(color: Clr().primaryColor),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

void close(key) {
  key.currentState.openEndDrawer();
}
