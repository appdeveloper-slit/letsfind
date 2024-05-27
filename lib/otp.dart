// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letsfind/view/homelayout/home.dart';
import 'package:letsfind/view/sign_up.dart';
import 'package:letsfind/values/colors.dart';
import 'package:letsfind/values/dimens.dart';
import 'package:letsfind/values/styles.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/static_method.dart';
import 'values/strings.dart';

class OTP extends StatefulWidget {
  final sMobile;
  final registerData;
  const OTP({super.key, this.sMobile, this.registerData});

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  late BuildContext ctx;

  final _formKey = GlobalKey<FormState>();
  TextEditingController otpCtrl = TextEditingController();
  bool isFocused = false;
  String? _pinCode;
  bool again = false;

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return Scaffold(
      backgroundColor: Clr().background,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Clr().background,
        leading: InkWell(
          onTap: () {
            STM().back2Previous(ctx);
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
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset("assets/back.svg"),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
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
                                  'Verify OTP',
                                  style: Sty().largeText.copyWith(
                                      color: Clr().primaryColor,
                                      fontSize: 38,
                                      fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                RichText(
                                    text: TextSpan(
                                        text: "Enter the code sent to ",
                                        // text: '₹10,000 ',
                                        style: Sty().mediumText.copyWith(
                                              color: Clr().textcolor,
                                              fontFamily: 'SP',
                                              fontWeight: FontWeight.w500,
                                            ),
                                        children: [
                                      TextSpan(
                                        text:
                                            '+91 ${widget.sMobile ?? widget.registerData['mobile']}',
                                        style: Sty().mediumText.copyWith(
                                              color: Clr().secondary,
                                              fontFamily: 'SP',
                                              fontWeight: FontWeight.w500,
                                            ),
                                      )
                                    ])),
                                SizedBox(
                                  height: Dim().d32,
                                ),
                                PinCodeTextField(
                                  controller: otpCtrl,
                                  // errorAnimationController: errorController,
                                  appContext: context,
                                  enableActiveFill: true,
                                  textStyle: Sty().largeText,
                                  length: 4,
                                  obscureText: false,
                                  keyboardType: TextInputType.number,
                                  animationType: AnimationType.scale,
                                  cursorColor: Clr().primaryColor,
                                  pinTheme: PinTheme(
                                    shape: PinCodeFieldShape.box,
                                    borderRadius: BorderRadius.circular(16),
                                    fieldWidth: Dim().d60,
                                    fieldHeight: Dim().d60,
                                    selectedFillColor: Clr().transparent,
                                    activeFillColor: Clr().transparent,
                                    inactiveFillColor: Clr().transparent,
                                    borderWidth: 0.2,
                                    selectedBorderWidth: 0.9,
                                    activeBorderWidth: 0.9,
                                    inactiveBorderWidth: 0.6,
                                    inactiveColor: Clr().grey,
                                    activeColor: Clr().primaryColor,
                                    selectedColor: Clr().primaryColor,
                                  ),
                                  animationDuration:
                                      const Duration(milliseconds: 200),
                                  onChanged: (value) {
                                    _pinCode = value;
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        !RegExp(r'(.{4,})').hasMatch(value)) {
                                      return "";
                                    } else {
                                      return null;
                                    }
                                  },
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
                        verifyOTP();
                      },
                      child: Text(
                        'Verify',
                        style: Sty().mediumText.copyWith(color: Clr().white),
                      )),
                ),
                SizedBox(
                  height: Dim().d16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '',
                      style: Sty().smallText.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Clr().textcolor),
                    ),
                    Visibility(
                      visible: !again,
                      child: TweenAnimationBuilder<Duration>(
                          duration: const Duration(seconds: 60),
                          tween: Tween(
                              begin: const Duration(seconds: 60),
                              end: Duration.zero),
                          onEnd: () {
                            // ignore: avoid_print
                            // print('Timer ended');
                            setState(() {
                              again = true;
                            });
                          },
                          builder: (BuildContext context, Duration value,
                              Widget? child) {
                            final minutes = value.inMinutes;
                            final seconds = value.inSeconds % 60;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  Text(
                                    "Didn’t receive code ?",
                                    textAlign: TextAlign.center,
                                    style: Sty().smallText.copyWith(
                                        color: Clr().primaryColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    " 0$minutes:$seconds",
                                    textAlign: TextAlign.center,
                                    style: Sty().smallText.copyWith(
                                        color: Clr().errorRed,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                    // Visibility(
                    //   visible: !isResend,
                    //   child: Text("I didn't receive a code! ${(  sTime  )}",
                    //       style: Sty().mediumText),
                    // ),
                    Visibility(
                      visible: again,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            again = false;
                            // resendOTP();
                            resendOTP();
                          });
                        },
                        child: Text(
                          'Resend Code',
                          style: Sty().smallText.copyWith(
                              color: Clr().primaryColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: Dim().d32,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void verifyOTP() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var body = widget.sMobile == null
        ? {
            "name": widget.registerData['name'],
            "mobile": widget.registerData['mobile'],
            "email": widget.registerData['email'],
            "otp": otpCtrl.text,
          }
        : {
            "mobile": widget.sMobile,
            "otp": otpCtrl.text,
          };
    var result = await STM().allApi(
      apiname: widget.sMobile == null ? 'verify_otp' : 'verify_login_otp',
      body: body,
      ctx: ctx,
      load: true,
      loadtitle: 'Verifying...',
      type: 'post',
    );
    if (result['success'] == true) {
      setState(() {
        sp.setString('token', result['data']['token']);
        sp.setBool('login', true);
        sp.setString('userid', result['data']['user']['id'].toString());
        STM().successDialogWithAffinity(ctx, result['message'], const Home());
      });
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }

  void resendOTP() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var body = {
      "mobile": widget.sMobile ?? widget.registerData['mobile'],
    };
    var result = await STM().allApi(
      apiname: 'resend_otp',
      body: body,
      ctx: ctx,
      load: true,
      loadtitle: 'Resending...',
      type: 'post',
    );
    if (result['success'] == true) {
      setState(() {
        otpCtrl.clear();
        STM().displayToast(result['message']);
      });
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }
}
