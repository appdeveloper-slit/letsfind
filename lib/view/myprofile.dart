// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:letsfind/controller/profilecontroller.dart';
import 'package:letsfind/sign_in.dart';
import 'package:letsfind/values/dimens.dart';
import 'package:letsfind/view/homelayout/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/signupcontroller.dart';
import '../data/static_method.dart';
import '../values/colors.dart';
import '../values/strings.dart';
import '../values/styles.dart';

class myprofilePage extends StatefulWidget {
  const myprofilePage({super.key});

  @override
  State<myprofilePage> createState() => _myprofilePageState();
}

class _myprofilePageState extends State<myprofilePage> {
  late BuildContext ctx;
  final _formKey = GlobalKey<FormState>();
  TextEditingController updatenumberCtrl = TextEditingController();
  TextEditingController updateUserOtpController = TextEditingController();
  bool again = false;
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(
      Duration.zero,
      () {
        profileController().getProfile(context, setState);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: () async {
        STM().finishAffinity(ctx, const Home());
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          backgroundColor: Clr().background,
          leading: InkWell(
            onTap: () {
              STM().finishAffinity(ctx, const Home());
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
          centerTitle: true,
          title: Text(
            'My Profile',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Sty().largeText.copyWith(
                  color: Clr().primaryColor,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(Dim().d12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Clr().white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dim().d12),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 5,
                        spreadRadius: 1,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(Dim().d16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Full Name',
                          style: Sty().smallText,
                        ),
                        SizedBox(
                          height: Dim().d12,
                        ),
                        TextFormField(
                          controller: namCtrl,
                          decoration:
                              Sty().TextFormFieldOutlineDarkStyle.copyWith(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Clr().black,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        Dim().d56,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Clr().black,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        Dim().d56,
                                      ),
                                    ),
                                    hintText: 'Enter a name',
                                    hintStyle: Sty().smallText.copyWith(
                                          color: Clr().hintColor,
                                        ),
                                  ),
                          validator: (v) {
                            if (v!.isEmpty) {
                              return 'Please enter a name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: Dim().d20,
                        ),
                        Text(
                          'Mobile Number',
                          style: Sty().smallText,
                        ),
                        SizedBox(
                          height: Dim().d12,
                        ),
                        TextFormField(
                          controller: mobCtrl,
                          readOnly: true,
                          decoration:
                              Sty().TextFormFieldOutlineDarkStyle.copyWith(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Clr().black,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        Dim().d56,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Clr().black,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        Dim().d56,
                                      ),
                                    ),
                                    hintText: 'Enter a mobile number',
                                    hintStyle: Sty().smallText.copyWith(
                                          color: Clr().hintColor,
                                        ),
                                    suffixIcon: InkWell(
                                      onTap: () {
                                        updateUserOtpController.clear();
                                        updatenumberCtrl.clear();
                                        updateMobileNumber(setState);
                                      },
                                      child: Icon(
                                        Icons.edit_outlined,
                                        color: Clr().primaryColor,
                                      ),
                                    ),
                                  ),
                        ),
                        SizedBox(
                          height: Dim().d20,
                        ),
                        Text(
                          'Email Address',
                          style: Sty().smallText,
                        ),
                        SizedBox(
                          height: Dim().d12,
                        ),
                        TextFormField(
                          controller: emlCtrl,
                          decoration:
                              Sty().TextFormFieldOutlineDarkStyle.copyWith(
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Clr().black,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        Dim().d56,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Clr().black,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                        Dim().d56,
                                      ),
                                    ),
                                    hintText: 'Enter a email address',
                                    hintStyle: Sty().smallText.copyWith(
                                          color: Clr().hintColor,
                                        ),
                                  ),
                          validator: (value) =>
                              signuController().emailValidaion(value),
                        ),
                        SizedBox(
                          height: Dim().d28,
                        ),
                        InkWell(
                          onTap: () {
                            profileController().addProfile(
                              ctx,
                              setState,
                              {
                                'name': namCtrl.text,
                                'email': emlCtrl.text,
                              },
                            );
                          },
                          child: Container(
                            height: Dim().d48,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Clr().primaryColor,
                              border: Border.all(
                                color: Clr().primaryColor,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(Dim().d20),
                            ),
                            child: Center(
                              child: Text(
                                'Update',
                                style: Sty().mediumText.copyWith(
                                      color: Clr().white,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: Dim().d200,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
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
                                                    Radius.circular(Dim().d12),
                                                  ),
                                                ),
                                              ),
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
                        height: Dim().d44,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Clr().primaryColor,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(Dim().d20),
                        ),
                        child: Center(
                          child: Text(
                            'Log out',
                            style: Sty().mediumText.copyWith(
                                  color: Clr().primaryColor,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dim().d20,
                    ),
                    InkWell(
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
                                    Text('Delete Account',
                                        style: Sty().largeText.copyWith(
                                            color: Clr().primaryColor,
                                            fontWeight: FontWeight.w800)),
                                    SizedBox(
                                      height: Dim().d12,
                                    ),
                                    Text(
                                        'Are you sure want to delete your account?',
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
                                              onPressed: () {
                                                deleteAccount();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Clr().primaryColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(Dim().d12),
                                                  ),
                                                ),
                                              ),
                                              child: Center(
                                                child: Text('Delete',
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
                      child: Center(
                        child: Text(
                          'Delete My Account',
                          style:
                              Sty().mediumText.copyWith(color: Clr().errorRed),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dim().d20,
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

  void deleteAccount() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var result = await STM().allApi(
      apiname: 'delete_account',
      ctx: ctx,
      load: true,
      loadtitle: 'Deleting..',
      token: sp.getString('token'),
      type: 'get',
    );
    if (result['success'] == true) {
      setState(() {
        sp.setBool('login', false);
        sp.clear();
        STM().successDialogWithAffinity(
            context, result['message'], const SignIn());
      });
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }

  //Update number pop up
  void updateMobileNumber(setStates) {
    bool otpsend = false;
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              backgroundColor: Clr().white,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              title: Text("Change Mobile Number",
                  style: Sty().mediumBoldText.copyWith(color: Clr().black)),
              content: SizedBox(
                height: 120,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                            visible: !otpsend,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 8,
                                ),
                                Text("New Mobile Number",
                                    style: Sty().smallText.copyWith(
                                          color: Clr().black,
                                        )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    controller: updatenumberCtrl,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Mobile filed is required';
                                      }
                                      if (value.length != 10) {
                                        return 'Mobile digits must be 10';
                                      }
                                    },
                                    maxLength: 10,
                                    decoration: Sty()
                                        .TextFormFieldOutlineStyle
                                        .copyWith(
                                          counterText: "",
                                          hintText: "Enter Mobile Number",
                                          hintStyle: Sty()
                                              .smallText
                                              .copyWith(color: Clr().hintColor),
                                          // prefixIcon: Icon(
                                          //   Icons.phone,
                                          //   size: iconSizeNormal(),
                                          //   color: primary(),
                                          // ),
                                        ),
                                  ),
                                ),
                              ],
                            )),
                        Visibility(
                            visible: otpsend,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "One Time Password",
                                  style: Sty()
                                      .mediumText
                                      .copyWith(color: Clr().black),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2, color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: TextFormField(
                                    controller: updateUserOtpController,
                                    keyboardType: TextInputType.number,
                                    maxLength: 4,
                                    decoration: InputDecoration(
                                      counterText: "",
                                      hintText: "Enter OTP",
                                      prefixIconConstraints:
                                          const BoxConstraints(
                                              minWidth: 50, minHeight: 0),
                                      suffixIconConstraints:
                                          const BoxConstraints(
                                              minWidth: 10, minHeight: 2),
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Clr().black,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: Dim().d12,
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
                                              begin:
                                                  const Duration(seconds: 60),
                                              end: Duration.zero),
                                          onEnd: () {
                                            // ignore: avoid_print
                                            // print('Timer ended');
                                            setState(() {
                                              again = true;
                                            });
                                          },
                                          builder: (BuildContext context,
                                              Duration value, Widget? child) {
                                            final minutes = value.inMinutes;
                                            final seconds =
                                                value.inSeconds % 60;
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 2),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    "Didn’t receive code ?",
                                                    textAlign: TextAlign.center,
                                                    style: Sty()
                                                        .smallText
                                                        .copyWith(
                                                            color: Clr()
                                                                .primaryColor,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                  ),
                                                  Text(
                                                    " 0$minutes:$seconds",
                                                    textAlign: TextAlign.center,
                                                    style: Sty()
                                                        .smallText
                                                        .copyWith(
                                                            color:
                                                                Clr().errorRed,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
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
                                            resendOTP(updatenumberCtrl.text);
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
                              ],
                            )),
                      ]),
                ),
              ),
              actions: [
                Row(
                  children: [
                    Visibility(
                      visible: !otpsend,
                      child: Expanded(
                        child: InkWell(
                            onTap: () async {
                              // API UPDATE START
                              SharedPreferences sp =
                                  await SharedPreferences.getInstance();
                              FormData body = FormData.fromMap({
                                'mobile': updatenumberCtrl.text,
                              });
                              var result = await STM().postWithToken(
                                  ctx,
                                  Str().sendingOtp,
                                  'update_mobile_send_otp',
                                  body,
                                  sp.getString('token'));
                              var success = result['success'];
                              var message = result['message'];
                              if (success) {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    otpsend = true;
                                  });
                                }
                              } else {
                                STM().errorDialog(context, message);
                              }

                              // API UPDATE END
                            },
                            child: Container(
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(55),
                                  color: Clr().primaryColor,
                                ),
                                child: const Center(
                                    child: Text("Send OTP",
                                        style:
                                            TextStyle(color: Colors.white))))),
                      ),
                    ),
                    Visibility(
                      visible: otpsend,
                      child: Expanded(
                        child: InkWell(
                          onTap: () {
                            // API UPDATE START
                            setState(() {
                              otpsend = true;
                              profileController().updateMobile(
                                ctx,
                                setStates,
                                {
                                  'mobile': updatenumberCtrl.text,
                                  'otp': updateUserOtpController.text
                                },
                              );
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(55),
                              color: Clr().primaryColor,
                            ),
                            child: const Center(
                              child: Text(
                                "Update",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                border: Border.all(color: Clr().textcolor),
                                borderRadius: BorderRadius.circular(55),
                              ),
                              child: Center(
                                  child: Text("Cancel",
                                      style: TextStyle(
                                          color: Clr().textcolor,
                                          fontWeight: FontWeight.w600))))),
                    ),
                  ],
                ),
              ],
              actionsAlignment: MainAxisAlignment.center,
            ),
          );
        });
  }

  void resendOTP(mobile) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var body = {
      "mobile": mobile,
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
        STM().displayToast(result['message']);
      });
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }
}
