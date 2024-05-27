import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letsfind/controller/signupcontroller.dart';
import 'package:letsfind/sign_in.dart';
import 'package:letsfind/values/colors.dart';
import 'package:letsfind/values/dimens.dart';
import 'package:letsfind/values/styles.dart';
import '../data/static_method.dart';
import '../otp.dart';
import '../values/strings.dart';
import 'crimebranch/cb_sign_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({
    super.key,
  });

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late BuildContext ctx;
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController mobileCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  bool isFocused1 = false;
  bool isFocused2 = false;
  bool isFocused3 = false;

  String? jewelryValue;
  List<dynamic> jewelryList = [
    {"id": "1", "name": "User"},
    {"id": "2", "name": "Vendor"},
  ];

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
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(Dim().d16),
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
                                'Get Started',
                                style: Sty().largeText.copyWith(
                                    color: Clr().primaryColor,
                                    fontSize: 38,
                                    fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                'Fill the detail to create account',
                                style: Sty().mediumText.copyWith(
                                    color: Clr().textcolor,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: Dim().d32,
                              ),
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 16),
                              //   child: Align(
                              //     alignment: Alignment.centerLeft,
                              //     child: Text(
                              //       'Select User',
                              //       style: Sty().microText.copyWith(
                              //           color: Clr().textcolor,
                              //           fontWeight: FontWeight.w500),
                              //     ),
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: Dim().d8,
                              // ),
                              // DropdownButtonFormField(
                              //   borderRadius: BorderRadius.circular(15),
                              //   value: jewelryValue,
                              //   icon: Icon(
                              //     Icons.keyboard_arrow_down_sharp,
                              //     color: Clr().primaryColor,
                              //   ),
                              //   hint: Text(
                              //     'Select user type',
                              //     style: Sty().smallText.copyWith(
                              //         color: Clr().hintColor, fontFamily: "SF"),
                              //   ),
                              //   onChanged: (v) {
                              //     setState(() {
                              //       jewelryValue = v!;
                              //     });
                              //   },
                              //   style: Sty()
                              //       .mediumText
                              //       .copyWith(color: Clr().primaryColor),
                              //   decoration:
                              //       Sty().textFieldOutlineStyle.copyWith(
                              //             fillColor: Clr().white,
                              //             filled: true,
                              //           ),
                              //   items: jewelryList.map((string) {
                              //     return DropdownMenuItem<dynamic>(
                              //       value: string['id'],
                              //       child: Text(string['name'],
                              //           style: Sty().smallText.copyWith(
                              //               color: Clr().primaryColor)),
                              //     );
                              //   }).toList(),
                              //   validator: (value) =>
                              //       signuController().userTypeValidation(value),
                              // ),
                              // SizedBox(
                              //   height: Dim().d20,
                              // ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Full Name',
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
                                    isFocused1 = hasFocus;
                                  });
                                },
                                child: TextFormField(
                                  controller: nameCtrl,
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
                                                const BorderSide(width: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(55)),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(55),
                                          borderSide: BorderSide(
                                            color: nameCtrl.text.isNotEmpty ||
                                                    isFocused1
                                                ? Clr().primaryColor
                                                : Clr().hintColor,
                                          ),
                                        ),
                                        hintStyle: Sty().smallText.copyWith(
                                            color: Clr().hintColor,
                                            fontFamily: "SF"),
                                        hintText: "Enter Full Name",
                                        counterText: "",
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: Dim().d20,
                                          vertical: Dim().d14,
                                        ),
                                      ),
                                  validator: (value) =>
                                      signuController().nameValidation(value),
                                ),
                              ),
                              SizedBox(
                                height: Dim().d20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Mobile Number',
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
                                                const BorderSide(width: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(55)),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(55),
                                          borderSide: BorderSide(
                                            color: mobileCtrl.text.isNotEmpty ||
                                                    isFocused2
                                                ? Clr().primaryColor
                                                : Clr().hintColor,
                                          ),
                                        ),
                                        hintStyle: Sty().smallText.copyWith(
                                            color: Clr().hintColor,
                                            fontFamily: "SF"),
                                        hintText: "Enter Mobile Number",
                                        counterText: "",
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: Dim().d20,
                                          vertical: Dim().d14,
                                        ),
                                      ),
                                  maxLength: 10,
                                  validator: (value) =>
                                      signuController().mobileValidation(value),
                                ),
                              ),
                              SizedBox(
                                height: Dim().d20,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
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
                                    isFocused3 = hasFocus;
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
                                                const BorderSide(width: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(55)),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(55),
                                          borderSide: BorderSide(
                                            color: emailCtrl.text.isNotEmpty ||
                                                    isFocused3
                                                ? Clr().primaryColor
                                                : Clr().hintColor,
                                          ),
                                        ),
                                        hintStyle: Sty().smallText.copyWith(
                                            color: Clr().hintColor,
                                            fontFamily: "SF"),
                                        hintText: "Enter Email Address",
                                        counterText: "",
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: Dim().d20,
                                          vertical: Dim().d14,
                                        ),
                                      ),
                                  validator: (value) =>
                                      signuController().emailValidaion(value),
                                ),
                              ),
                              SizedBox(
                                height: Dim().d8,
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
                SizedBox(
                  height: Dim().d80,
                ),
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
                                signuController().registerUserApi(
                                  ctx,
                                  emailCtrl: emailCtrl.text,
                                  mobileCtrl: mobileCtrl.text,
                                  nameCtrl: nameCtrl.text,
                                );
                              }
                            },
                          );
                        }
                      },
                      child: Text(
                        'Sign Up',
                        style: Sty().mediumText.copyWith(color: Clr().white),
                      )),
                ),
                SizedBox(
                  height: Dim().d16,
                ),
                GestureDetector(
                  onTap: () {
                    STM().finishAffinity(context, const SignIn());
                  },
                  child: RichText(
                      text: TextSpan(
                          text: "Already have an account? ",
                          // text: '₹10,000 ',
                          style: Sty().smallText.copyWith(
                                color: Clr().textcolor,
                                fontFamily: 'SP',
                                fontWeight: FontWeight.w400,
                              ),
                          children: [
                        TextSpan(
                          text: 'Login Now',
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
            ),
          ),
        ),
      ),
    );
  }
}
