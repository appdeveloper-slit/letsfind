// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letsfind/otp.dart';
import 'package:letsfind/view/sign_up.dart';
import 'package:letsfind/values/colors.dart';
import 'package:letsfind/values/dimens.dart';
import 'package:letsfind/values/styles.dart';
import 'package:letsfind/data/fireremotepage.dart';
import 'data/static_method.dart';
import 'values/strings.dart';
import 'values/text.dart';
import 'view/crimebranch/cb_sign_in.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  late BuildContext ctx;

  final _formKey = GlobalKey<FormState>();
  TextEditingController mobileCtrl = TextEditingController();
  bool isFocused = false;
  var sendOTPApi;
  var sendotpdetails;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return Scaffold(
      backgroundColor: Clr().background,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Clr().background,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    side: BorderSide(color: Clr().secondary),
                    backgroundColor: const Color(0xfffff8f0)),
                onPressed: () {
                  STM().redirect2page(ctx, const CBSignIn());
                },
                child: Row(
                  children: [
                    Text(
                      'Crime Branch Login',
                      style: Sty().smallText.copyWith(color: Clr().secondary),
                    ),
                    SizedBox(
                      width: Dim().d8,
                    ),
                    SvgPicture.asset("assets/crime_branch_logo.svg")
                  ],
                )),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(Dim().d16),
          child: Column(
            children: [
              Expanded(
                child: Column(
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
                                    textLayoutPage().signin_title,
                                    style: Sty().largeText.copyWith(
                                        color: Clr().primaryColor,
                                        fontSize: 38,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    textLayoutPage().signin_subtitle,
                                    style: Sty().mediumText.copyWith(
                                        color: Clr().textcolor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: Dim().d32,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 16),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        textLayoutPage().signin_text,
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
                                                color: mobileCtrl
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
                                                textLayoutPage().signin_hintext,
                                            counterText: "",
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              horizontal: Dim().d20,
                                              vertical: Dim().d14,
                                            ),
                                          ),
                                      maxLength: 10,
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
                                    height: Dim().d4,
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
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
                            STM().checkInternet(context, widget).then((value) {
                              if (value) {
                                sendOTP();
                              }
                            });
                          }
                        },
                        child: Text(
                          textLayoutPage().signin_login,
                          style: Sty().mediumText.copyWith(color: Clr().white),
                        )),
                  ),
                  SizedBox(
                    height: Dim().d16,
                  ),
                  GestureDetector(
                    onTap: () {
                      STM().redirect2page(context, SignUp());
                    },
                    child: RichText(
                        text: TextSpan(
                            text: textLayoutPage().signin_signuptext,
                            // text: '₹10,000 ',
                            style: Sty().smallText.copyWith(
                                  color: Clr().textcolor,
                                  fontFamily: 'SP',
                                  fontWeight: FontWeight.w400,
                                ),
                            children: [
                          TextSpan(
                            text: textLayoutPage().signin_signuptext1,
                            style: Sty().smallText.copyWith(
                                  color: Clr().errorRed,
                                  fontFamily: 'SP',
                                  fontWeight: FontWeight.w600,
                                ),
                          )
                        ])),
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
    );
  }

  void sendOTP() async {
    var body = {
      'mobile': mobileCtrl.text,
    };
    var result = await STM().allApi(
      apiname: 'send_login_otp',
      body: body,
      ctx: ctx,
      load: true,
      loadtitle: 'Sending OTP...',
      type: 'post',
    );
    if (result['success'] == true) {
      STM().redirect2page(
          ctx,
          OTP(
            sMobile: mobileCtrl.text,
          ));
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }
}
