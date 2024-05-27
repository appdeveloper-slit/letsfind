import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letsfind/otp.dart';
import 'package:letsfind/sign_in.dart';
import 'package:letsfind/values/colors.dart';
import 'package:letsfind/values/dimens.dart';
import 'package:letsfind/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/static_method.dart';
import '../../values/colors.dart';
import '../../values/dimens.dart';
import '../../values/strings.dart';
import '../../values/styles.dart';
import 'cb_home.dart';

class CBSignIn extends StatefulWidget {
  const CBSignIn({super.key});

  @override
  State<CBSignIn> createState() => _CBSignInState();
}

class _CBSignInState extends State<CBSignIn> {
  late BuildContext ctx;

  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  bool isFocused = false;
  bool isHidden = false;

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return WillPopScope(
      onWillPop: () async {
        STM().finishAffinity(ctx, const SignIn());
        return false;
      },
      child: Scaffold(
        backgroundColor: Clr().background,
        appBar: AppBar(
          forceMaterialTransparency: true,
          backgroundColor: Clr().background,
          leading: InkWell(
            onTap: () {
              STM().finishAffinity(ctx, const SignIn());
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
        body: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.all(Dim().d16),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Clr().white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                    color: Clr().borderColor.withOpacity(0.5),
                                    blurRadius: 5,
                                    spreadRadius: 0)
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(Dim().d16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Welcome Back!',
                                    style: Sty().largeText.copyWith(
                                        color: Clr().primaryColor,
                                        fontSize: 38,
                                        fontWeight: FontWeight.w800),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    'Hello! Sign in to stay connected  ',
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
                                        'User ID',
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
                                      controller: usernameCtrl,
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
                                                color: usernameCtrl
                                                            .text.isNotEmpty ||
                                                        isFocused
                                                    ? Clr().primaryColor
                                                    : Clr().hintColor,
                                              ),
                                            ),
                                            hintStyle: Sty().smallText.copyWith(
                                                color: Clr().grey,
                                                fontFamily: "SF"),
                                            hintText: "Enter Assigned User ID",
                                            counterText: "",
                                            contentPadding:
                                                EdgeInsets.symmetric(
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
                                        'Password',
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
                                      controller: passwordCtrl,
                                      onTapOutside: (event) {
                                        FocusScope.of(context).unfocus();
                                      },
                                      cursorColor: Clr().textcolorsgray,
                                      style: Sty().smallText,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.done,
                                      obscureText: isHidden,
                                      decoration: Sty()
                                          .textFieldOutlineStyle
                                          .copyWith(
                                            border: OutlineInputBorder(
                                                borderSide:
                                                    BorderSide(width: 0.1),
                                                borderRadius:
                                                    BorderRadius.circular(55)),
                                            suffixIcon: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    isHidden = !isHidden;
                                                  });
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: SvgPicture.asset(isHidden
                                                      ? "assets/eye_open.svg"
                                                      : "assets/eye_closed.svg"),
                                                )),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(55),
                                              borderSide: BorderSide(
                                                color: passwordCtrl
                                                            .text.isNotEmpty ||
                                                        isFocused
                                                    ? Clr().primaryColor
                                                    : Clr().hintColor,
                                              ),
                                            ),
                                            hintStyle: Sty().smallText.copyWith(
                                                color: Clr().grey,
                                                fontFamily: "SF"),
                                            hintText: "Enter Valid Password",
                                            counterText: "",
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              horizontal: Dim().d20,
                                              vertical: Dim().d14,
                                            ),
                                          ),
                                      maxLength: 10,
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
                                    height: Dim().d4,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
                              elevation: 0,
                              backgroundColor: Clr().primaryColor),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              STM().checkInternet(context, widget).then(
                                (value) {
                                  if (value) {
                                    crimeBranchLogin();
                                  }
                                },
                              );
                            }
                            ;
                          },
                          child: Text(
                            'Log In',
                            style:
                                Sty().mediumText.copyWith(color: Clr().white),
                          )),
                    ),
                    SizedBox(
                      height: Dim().d0,
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

  /// Crime Branch Login
  void crimeBranchLogin() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      'username': usernameCtrl.text,
      'password': passwordCtrl.text,
    });
    var result =
        await STM().post(ctx, Str().loading, 'crime_branch/login', body);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(() {
        sp.setString("token", result['data']['token'].toString());
        sp.setString("username", result['data']['username'].toString());
        STM().displayToast(message);
        STM().finishAffinity(ctx, CBHome());
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
