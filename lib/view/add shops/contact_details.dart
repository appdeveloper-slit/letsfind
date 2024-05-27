// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:letsfind/view/shop_listing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/static_method.dart';
import '../../values/colors.dart';
import '../../values/dimens.dart';
import '../../values/strings.dart';
import '../../values/styles.dart';
import 'shop_offers.dart';

class ContactDetails extends StatefulWidget {
  final data;

  const ContactDetails({Key? key, this.data}) : super(key: key);

  @override
  State<ContactDetails> createState() => _ContactDetailsState();
}

class _ContactDetailsState extends State<ContactDetails> {
  late BuildContext ctx;

  bool isFocused = false;

  final _formKey = GlobalKey<FormState>();
  TextEditingController mobileCtrl = TextEditingController();
  TextEditingController altmobileCtrl = TextEditingController();
  TextEditingController whatsappCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();

  String? sShopID, sToken;

  getsessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sShopID = sp.getString("shop_id") ?? "";
    // sToken = sp.getString("token") ?? "";
    sToken = sp.getString("token") ?? "";
    print("Shop ID :: $sShopID");
    if (widget.data != null) {
      setState(() {
        mobileCtrl =
            TextEditingController(text: widget.data['shop_contact']['mobile']);
        altmobileCtrl = TextEditingController(
            text: widget.data['shop_contact']['alt_mobile']);
        whatsappCtrl = TextEditingController(
            text: widget.data['shop_contact']['wp_mobile']);
        emailCtrl =
            TextEditingController(text: widget.data['shop_contact']['email']);
      });
    }
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
                        Text(
                          'Cancel Process?',
                          style: Sty().largeText.copyWith(
                                color: Clr().primaryColor,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
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
          title: RichText(
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
                  text: '5 ',
                  style: Sty().smallText.copyWith(
                        color: Color(0xffFF8000),
                        fontFamily: 'SP',
                        fontWeight: FontWeight.w600,
                      ),
                ),
                TextSpan(
                  text: 'of 7',
                  style: Sty().smallText.copyWith(
                        color: Clr().textcolor,
                        fontFamily: 'SP',
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ],
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
                                  'Contact Details',
                                  style: Sty().largeText.copyWith(
                                      color: Clr().primaryColor,
                                      fontSize: 38,
                                      fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  'Fill the shop contact details',
                                  style: Sty().mediumText.copyWith(
                                        color: Clr().textcolor,
                                        fontFamily: 'SP',
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                SizedBox(
                                  height: Dim().d32,
                                ),
                                SizedBox(
                                  height: Dim().d20,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Contact Number',
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
                                    controller: mobileCtrl,
                                    maxLength: 10,
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
                                              color:
                                                  mobileCtrl.text.isNotEmpty ||
                                                          isFocused
                                                      ? Clr().primaryColor
                                                      : Clr().hintColor,
                                            ),
                                          ),
                                          hintStyle: Sty().smallText.copyWith(
                                              color: Clr().grey,
                                              fontFamily: "SF"),
                                          hintText: "Enter Mobile Number",
                                          counterText: "",
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: Dim().d20,
                                            vertical: Dim().d14,
                                          ),
                                        ),
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          !RegExp(r'([5-9]{1}[0-9]{9})')
                                              .hasMatch(value)) {
                                        return Str().invalidMobile;
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
                                      'Alternate Contact Number',
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
                                    controller: altmobileCtrl,
                                    onTapOutside: (event) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    maxLength: 10,
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
                                              color: altmobileCtrl
                                                          .text.isNotEmpty ||
                                                      isFocused
                                                  ? Clr().primaryColor
                                                  : Clr().hintColor,
                                            ),
                                          ),
                                          hintStyle: Sty().smallText.copyWith(
                                              color: Clr().grey,
                                              fontFamily: "SF"),
                                          hintText:
                                              "Enter Alternative Mobile Number",
                                          counterText: "",
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: Dim().d20,
                                            vertical: Dim().d14,
                                          ),
                                        ),
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          !RegExp(r'([5-9]{1}[0-9]{9})')
                                              .hasMatch(value)) {
                                        return Str().invalidMobile;
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
                                      'WhatsApp Number',
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
                                    controller: whatsappCtrl,
                                    onTapOutside: (event) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    maxLength: 10,
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
                                              color: whatsappCtrl
                                                          .text.isNotEmpty ||
                                                      isFocused
                                                  ? Clr().primaryColor
                                                  : Clr().hintColor,
                                            ),
                                          ),
                                          hintStyle: Sty().smallText.copyWith(
                                              color: Clr().grey,
                                              fontFamily: "SF"),
                                          hintText:
                                              "Enter Valid WhatsApp Number",
                                          counterText: "",
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: Dim().d20,
                                            vertical: Dim().d14,
                                          ),
                                        ),
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          !RegExp(r'([5-9]{1}[0-9]{9})')
                                              .hasMatch(value)) {
                                        return Str().invalidMobile;
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
                                      'Email Address',
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
                                    controller: emailCtrl,
                                    onTapOutside: (event) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    cursorColor: Clr().textcolorsgray,
                                    style: Sty().smallText,
                                    keyboardType: TextInputType.emailAddress,
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
                                                  emailCtrl.text.isNotEmpty ||
                                                          isFocused
                                                      ? Clr().primaryColor
                                                      : Clr().hintColor,
                                            ),
                                          ),
                                          hintStyle: Sty().smallText.copyWith(
                                              color: Clr().grey,
                                              fontFamily: "SF"),
                                          hintText: "Enter Email Address",
                                          counterText: "",
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: Dim().d20,
                                            vertical: Dim().d14,
                                          ),
                                        ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return Str().invalidEmail;
                                      } else {
                                        return null;
                                      }
                                    },
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
                          if (_formKey.currentState!.validate()) {
                            STM().checkInternet(context, widget).then(
                              (value) {
                                if (value) {
                                  submitStep5();
                                }
                              },
                            );
                          }
                          ;
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
  void submitStep5() async {
    FormData body = FormData.fromMap({
      "id": widget.data != null ? widget.data['shop_contact']['id'] : null,
      "shop_id": sShopID,
      "mobile": mobileCtrl.text,
      "alt_mobile": altmobileCtrl.text,
      "wp_mobile": whatsappCtrl.text,
      "email": emailCtrl.text,
    });
    var result =
        await STM().postWithToken(ctx, Str().loading, 'step4', body, sToken);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      if (widget.data != null) {
        STM().successDialogWithReplace(ctx, message, const ShopListing());
      } else {
        STM().displayToast(message);
        STM().redirect2page(
          ctx,
          ShopOffers(),
        );
      }
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
