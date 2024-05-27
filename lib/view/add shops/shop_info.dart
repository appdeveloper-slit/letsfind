// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letsfind/values/colors.dart';
import 'package:letsfind/values/dimens.dart';
import 'package:letsfind/values/styles.dart';
import '../../data/static_method.dart';
import '../../values/colors.dart';
import '../../values/dimens.dart';
import '../../values/strings.dart';
import '../../values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../shop_listing.dart';
import 'shop_category.dart';

class ShopInfo extends StatefulWidget {
  final data;

  const ShopInfo({super.key, this.data});

  @override
  State<ShopInfo> createState() => _ShopInfoState();
}

class _ShopInfoState extends State<ShopInfo> {
  late BuildContext ctx;

  bool isFocused = false;
  bool isFocused2 = false;
  bool isFocused3 = false;
  bool isFocused4 = false;
  bool isFocused5 = false;

  final _formKey = GlobalKey<FormState>();
  TextEditingController yearCtrl = TextEditingController();
  TextEditingController gstCtrl = TextEditingController();
  TextEditingController websiteCtrl = TextEditingController();
  TextEditingController fbCtrl = TextEditingController();
  TextEditingController ytCtrl = TextEditingController();

  String? sShopID, sToken;

  getsessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sShopID = sp.getString("shop_id") ?? "";
    sToken = sp.getString("token") ?? "";
    print("Shop ID :: $sShopID");
    if (widget.data != null) {
      setState(() {
        yearCtrl = TextEditingController(
            text: widget.data['shop_information']['year_of_establishment']);
        gstCtrl = TextEditingController(
            text: widget.data['shop_information']['gst_number']);
        websiteCtrl = TextEditingController(
            text: widget.data['shop_information']['website']);
        fbCtrl = TextEditingController(
            text: widget.data['shop_information']['facebook_link']);
        ytCtrl = TextEditingController(
            text: widget.data['shop_information']['youtube_link']);
      });
    }
    // STM().checkInternet(context, widget).then((value) {
    //   if (value) {
    //     getCities();
    //   }
    // });
  }

  @override
  void initState() {
    getsessionData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return WillPopScope(
      onWillPop: () async {
        widget.data != null
            ? STM().replacePage(ctx, const ShopListing())
            : showDialog(
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
                        Text('Cancel Process?',
                            style: Sty().largeText.copyWith(
                                color: Clr().primaryColor,
                                fontWeight: FontWeight.w800)),
                        SizedBox(
                          height: Dim().d12,
                        ),
                        Text('Are you sure want to cancel this process ?',
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(Dim().d12)))),
                                child: Center(
                                  child: Text('Cancel',
                                      style: Sty().mediumText.copyWith(
                                          color: Clr()
                                              .textcolor
                                              .withOpacity(0.8))),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: Dim().d12,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: () async {
                                    STM().replacePage(ctx, const ShopListing());
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Clr().primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(Dim().d12),
                                      ),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text('Back',
                                        style: Sty()
                                            .mediumText
                                            .copyWith(color: Clr().white)),
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                });
        return false;
      },
      child: Scaffold(
        backgroundColor: Clr().background,
        appBar: AppBar(
          forceMaterialTransparency: true,
          surfaceTintColor: Clr().white,
          backgroundColor: Clr().white,
          leading: InkWell(
            onTap: () {
              widget.data != null
                  ? STM().replacePage(ctx, const ShopListing())
                  : showDialog(
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
                              Text('Cancel Process?',
                                  style: Sty().largeText.copyWith(
                                      color: Clr().primaryColor,
                                      fontWeight: FontWeight.w800)),
                              SizedBox(
                                height: Dim().d12,
                              ),
                              Text('Are you sure want to cancel this process ?',
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
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(Dim().d12)))),
                                      child: Center(
                                        child: Text('Cancel',
                                            style: Sty().mediumText.copyWith(
                                                color: Clr()
                                                    .textcolor
                                                    .withOpacity(0.8))),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Dim().d12,
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          STM().replacePage(
                                              ctx, const ShopListing());
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Clr().primaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(Dim().d12),
                                            ),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text('Back',
                                              style: Sty().mediumText.copyWith(
                                                  color: Clr().white)),
                                        )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      });
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
                  padding: EdgeInsets.all(Dim().d8),
                  child: SvgPicture.asset(
                    "assets/back.svg",
                  ),
                ),
              ),
            ),
          ),
          title: InkWell(
            onTap: () {
              // STM().redirect2page(ctx, BusinessHour(isOpen: true, startTime: '', endTime: ''));
              // STM().redirect2page(context, SelectTiming());
            },
            child: RichText(
              text: TextSpan(
                text: "Step ",
                // text: '₹10,000 ',
                style: Sty().smallText.copyWith(
                      color: Clr().textcolor,
                      fontFamily: 'SP',
                      fontWeight: FontWeight.w400,
                    ),
                children: [
                  TextSpan(
                    text: '2 ',
                    style: Sty().smallText.copyWith(
                          color: Color(0xffFF8000),
                          fontFamily: 'SP',
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  TextSpan(
                    text: 'of 6',
                    style: Sty().smallText.copyWith(
                          color: Clr().textcolor,
                          fontFamily: 'SP',
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ],
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Dim().d16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Column(
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                                color: Clr().borderColor.withOpacity(0.3),
                                blurRadius: 5,
                                spreadRadius: 0)
                          ],
                        ),
                        child: Card(
                          elevation: 0,
                          shape: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Clr().borderColor.withOpacity(0.8)),
                              borderRadius: BorderRadius.circular(18)),
                          color: Clr().white,
                          surfaceTintColor: Clr().white,
                          child: Padding(
                            padding: EdgeInsets.all(Dim().d16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Shop Information',
                                  style: Sty().largeText.copyWith(
                                      color: Clr().primaryColor,
                                      fontSize: 38,
                                      fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  'Fill the basic details of your shop',
                                  style: Sty().mediumText.copyWith(
                                        color: Clr().textcolor,
                                        fontFamily: 'SP',
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                SizedBox(
                                  height: Dim().d32,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Year of Establishment',
                                      style: Sty().microText.copyWith(
                                          color: Clr().textcolor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: Dim().d8,
                                ),
                                Focus(
                                  onFocusChange: (hasFocus) {
                                    setState(() {
                                      isFocused = hasFocus;
                                    });
                                  },
                                  child: TextFormField(
                                    controller: yearCtrl,
                                    maxLength: 4,
                                    onTapOutside: (event) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    cursorColor: Clr().textcolorsgray,
                                    style: Sty().smallText,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    obscureText: false,
                                    decoration: Sty()
                                        .textFieldOutlineStyle
                                        .copyWith(
                                          border: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(width: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(55)),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(55),
                                            borderSide: BorderSide(
                                              color: yearCtrl.text.isNotEmpty ||
                                                      isFocused
                                                  ? Clr().primaryColor
                                                  : Clr().hintColor,
                                            ),
                                          ),
                                          hintStyle: Sty().smallText.copyWith(
                                              color: Clr().grey,
                                              fontFamily: "SF"),
                                          hintText: "Enter Year",
                                          counterText: "",
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: Dim().d20,
                                            vertical: Dim().d14,
                                          ),
                                        ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return Str().invalidEmpty;
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: Dim().d20,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'GSTIN (Optional)',
                                      style: Sty().microText.copyWith(
                                          color: Clr().textcolor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: Dim().d8,
                                ),
                                Focus(
                                  onFocusChange: (hasFocus) {
                                    setState(() {
                                      isFocused2 = hasFocus;
                                    });
                                  },
                                  child: TextFormField(
                                    controller: gstCtrl,
                                    onTapOutside: (event) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    cursorColor: Clr().textcolorsgray,
                                    style: Sty().smallText,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.done,
                                    obscureText: false,
                                    decoration: Sty()
                                        .textFieldOutlineStyle
                                        .copyWith(
                                          border: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(width: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(55)),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(55),
                                            borderSide: BorderSide(
                                              color: gstCtrl.text.isNotEmpty ||
                                                      isFocused2
                                                  ? Clr().primaryColor
                                                  : Clr().hintColor,
                                            ),
                                          ),
                                          hintStyle: Sty().smallText.copyWith(
                                              color: Clr().grey,
                                              fontFamily: "SF"),
                                          hintText: "Enter GSTIN Number",
                                          counterText: "",
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: Dim().d20,
                                            vertical: Dim().d14,
                                          ),
                                        ),
                                  ),
                                ),
                                SizedBox(
                                  height: Dim().d20,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Website Link  (Optional)',
                                      style: Sty().microText.copyWith(
                                          color: Clr().textcolor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: Dim().d8,
                                ),
                                Focus(
                                  onFocusChange: (hasFocus) {
                                    setState(() {
                                      isFocused3 = hasFocus;
                                    });
                                  },
                                  child: TextFormField(
                                    controller: websiteCtrl,
                                    onTapOutside: (event) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    cursorColor: Clr().textcolorsgray,
                                    style: Sty().smallText,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.done,
                                    obscureText: false,
                                    decoration: Sty()
                                        .textFieldOutlineStyle
                                        .copyWith(
                                          border: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(width: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(55)),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(55),
                                            borderSide: BorderSide(
                                              color:
                                                  websiteCtrl.text.isNotEmpty ||
                                                          isFocused3
                                                      ? Clr().primaryColor
                                                      : Clr().hintColor,
                                            ),
                                          ),
                                          hintStyle: Sty().smallText.copyWith(
                                              color: Clr().grey,
                                              fontFamily: "SF"),
                                          hintText: "Enter Website Link",
                                          counterText: "",
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: Dim().d20,
                                            vertical: Dim().d14,
                                          ),
                                        ),
                                  ),
                                ),
                                SizedBox(
                                  height: Dim().d20,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Facebook (Optional)',
                                      style: Sty().microText.copyWith(
                                          color: Clr().textcolor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: Dim().d8,
                                ),
                                Focus(
                                  onFocusChange: (hasFocus) {
                                    setState(() {
                                      isFocused4 = hasFocus;
                                    });
                                  },
                                  child: TextFormField(
                                    controller: fbCtrl,
                                    onTapOutside: (event) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    cursorColor: Clr().textcolorsgray,
                                    style: Sty().smallText,
                                    keyboardType: TextInputType.name,
                                    textInputAction: TextInputAction.done,
                                    obscureText: false,
                                    decoration: Sty()
                                        .textFieldOutlineStyle
                                        .copyWith(
                                          border: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(width: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(55)),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(55),
                                            borderSide: BorderSide(
                                              color: fbCtrl.text.isNotEmpty ||
                                                      isFocused4
                                                  ? Clr().primaryColor
                                                  : Clr().hintColor,
                                            ),
                                          ),
                                          hintStyle: Sty().smallText.copyWith(
                                              color: Clr().grey,
                                              fontFamily: "SF"),
                                          hintText: "Enter Facebook Link",
                                          counterText: "",
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: Dim().d20,
                                            vertical: Dim().d14,
                                          ),
                                        ),
                                  ),
                                ),
                                SizedBox(
                                  height: Dim().d20,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'YouTube (Optional)',
                                      style: Sty().microText.copyWith(
                                          color: Clr().textcolor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: Dim().d8,
                                ),
                                Focus(
                                  onFocusChange: (hasFocus) {
                                    setState(() {
                                      isFocused5 = hasFocus;
                                    });
                                  },
                                  child: TextFormField(
                                    controller: ytCtrl,
                                    onTapOutside: (event) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    cursorColor: Clr().textcolorsgray,
                                    style: Sty().smallText,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.done,
                                    obscureText: false,
                                    decoration: Sty()
                                        .textFieldOutlineStyle
                                        .copyWith(
                                          border: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(width: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(55)),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(55),
                                            borderSide: BorderSide(
                                              color: ytCtrl.text.isNotEmpty ||
                                                      isFocused5
                                                  ? Clr().primaryColor
                                                  : Clr().hintColor,
                                            ),
                                          ),
                                          hintStyle: Sty().smallText.copyWith(
                                              color: Clr().grey,
                                              fontFamily: "SF"),
                                          hintText: "Enter YouTube Link",
                                          counterText: "",
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: Dim().d20,
                                            vertical: Dim().d14,
                                          ),
                                        ),
                                  ),
                                ),
                                SizedBox(
                                  height: Dim().d20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0, backgroundColor: Clr().primaryColor),
                        onPressed: () {
                          submitStep2();
                        },
                        child: Text(
                          widget.data != null ? 'Update' : 'Next',
                          style: Sty().mediumText.copyWith(color: Clr().white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dim().d32,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///Submit Step 1
  void submitStep2() async {
    FormData body = FormData.fromMap(
      {
        "id": widget.data != null ? widget.data['id'] : null,
        "shop_id": widget.data != null ? widget.data['id'] : sShopID,
        "year_of_establishment": yearCtrl.text,
        "gst_number": gstCtrl.text,
        "facebook_link": fbCtrl.text,
        "youtube_link": ytCtrl.text,
        "website": websiteCtrl.text,
        "schedules": [
          {
            "day_id": "1",
            "time": [
              {"from": "12:00", "to": "13:00"},
              {"from": "17:00", "to": "18:00"}
            ]
          },
          {
            "day_id": "2",
            "time": [
              {"from": "12:00", "to": "13:00"},
              {"from": "17:00", "to": "18:00"}
            ]
          }
        ]
      },
    );
    var result =
        await STM().postWithToken(ctx, Str().loading, 'step2', body, sToken);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      if (widget.data != null) {
        STM().successDialogWithReplace(ctx, message, const ShopListing());
      } else {
        STM().displayToast(message);
        STM().redirect2page(
          ctx,
          const ShopCategory(),
        );
      }
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
