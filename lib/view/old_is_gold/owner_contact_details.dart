import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:letsfind/data/static_method.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:letsfind/values/colors.dart';
import 'package:letsfind/values/dimens.dart';
import 'package:letsfind/values/strings.dart';
import 'package:letsfind/values/styles.dart';
import 'product_list.dart';

class OwnerContact extends StatefulWidget {
  final sContact, sType;

  const OwnerContact({Key? key, this.sContact, this.sType}) : super(key: key);

  @override
  State<OwnerContact> createState() => _OwnerContactState();
}

class _OwnerContactState extends State<OwnerContact> {
  late BuildContext ctx;

  bool isFocused = false;

  final _formKey = GlobalKey<FormState>();
  TextEditingController mobileCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  TextEditingController locationCtrl = TextEditingController();

  String? sCity, slat, slng;
  List<dynamic> cityList = [];

  String? sToken, sProductID;

  getsessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sProductID = sp.getString("product_id") ?? "";
    sToken = sp.getString("token") ?? "";
    print("sProduct ID :: $sProductID");
    if (widget.sType == "edit") {
      addressCtrl =
          TextEditingController(text: widget.sContact['address'].toString());
      locationCtrl =
          TextEditingController(text: widget.sContact['location'].toString());
      mobileCtrl =
          TextEditingController(text: widget.sContact['mobile'].toString());
      sCity = widget.sContact['city']['name'].toString();
      slat = widget.sContact['latitude'].toString();
      slng = widget.sContact['longitude'].toString();
    }
    print("Address Ctrl :: ${addressCtrl.text}");

    STM().checkInternet(context, widget).then((value) {
      if (value) {
        setState(() {
          getCities();
        });
      }
    });
  }

  @override
  void initState() {
    getsessionData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;

    print("sContact :: ${widget.sContact}");

    return Scaffold(
      backgroundColor: Clr().background,
      appBar: AppBar(
        forceMaterialTransparency: true,
        surfaceTintColor: Clr().white,
        backgroundColor: Clr().white,
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
                text: '3 ',
                style: Sty().smallText.copyWith(
                      color: Color(0xffFF8000),
                      fontFamily: 'SP',
                      fontWeight: FontWeight.w600,
                    ),
              ),
              TextSpan(
                text: 'of 3',
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
                                    'City',
                                    style: Sty().microText.copyWith(
                                        color: Clr().textcolor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: Dim().d8,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(55),
                                    border:
                                        Border.all(color: Clr().borderColor)),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButtonFormField<String>(
                                    borderRadius: BorderRadius.circular(10),
                                    decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Clr().white,
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Clr().primaryColor),
                                            borderRadius:
                                                BorderRadius.circular(55)),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(55),
                                            borderSide: BorderSide(
                                                color: Clr().borderColor,
                                                width: 0.5)),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: Dim().d20,
                                          vertical: Dim().d12,
                                        )),
                                    // value: sCity,
                                    isExpanded: true,
                                    hint: Text(
                                      sCity ?? 'Select City',
                                      style: Sty().smallText.copyWith(
                                            color: Clr().hintColor,
                                          ),
                                    ),
                                    icon: SvgPicture.asset(
                                      "assets/down_arrow.svg",
                                      color: Clr().textcolor,
                                    ),
                                    // style: TextStyle(color: Color(0xff2D2D2D)),
                                    items: cityList.map((string) {
                                      return DropdownMenuItem<String>(
                                        value: string['id'].toString(),
                                        child: Text(string['name'].toString(),
                                            style: Sty().smallText.copyWith(
                                                  color: Clr().black,
                                                )),
                                      );
                                    }).toList(),
                                    onChanged: (v) {
                                      setState(() {
                                        sCity = v;
                                        print("City :: $sCity");
                                      });
                                    },
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
                                    'Location',
                                    style: Sty().microText.copyWith(
                                        color: Clr().textcolor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: Dim().d8,
                              ),
                              // Focus(
                              //   onFocusChange: (hasFocus) {
                              //     setState(() {
                              //       isFocused = hasFocus;
                              //     });
                              //   },
                              //   child: TextFormField(
                              //     controller: locationCtrl,
                              //     onTapOutside: (event) {
                              //       FocusScope.of(context).unfocus();
                              //     },
                              //     maxLength: 10,
                              //     cursorColor: Clr().textcolorsgray,
                              //     style: Sty().smallText,
                              //     keyboardType: TextInputType.number,
                              //     textInputAction: TextInputAction.done,
                              //     obscureText: false,
                              //     readOnly: true,
                              //     decoration: Sty()
                              //         .textFieldOutlineStyle
                              //         .copyWith(
                              //       border: OutlineInputBorder(
                              //           borderSide: BorderSide(width: 0.1),
                              //           borderRadius:
                              //           BorderRadius.circular(55)),
                              //       enabledBorder: OutlineInputBorder(
                              //         borderRadius:
                              //         BorderRadius.circular(55),
                              //         borderSide: BorderSide(
                              //           color:
                              //           locationCtrl.text.isNotEmpty ||
                              //               isFocused
                              //               ? Clr().primaryColor
                              //               : Clr().hintColor,
                              //         ),
                              //       ),
                              //       hintStyle: Sty().smallText.copyWith(
                              //           color: Clr().grey,
                              //           fontFamily: "SF"),
                              //       hintText: "Select Map Location",
                              //       counterText: "",
                              //       contentPadding: EdgeInsets.symmetric(
                              //         horizontal: Dim().d20,
                              //         vertical: Dim().d14,
                              //       ),
                              //     ),
                              //     // validator: (value) {
                              //     //   if (value!.isEmpty) {
                              //     //     return Str().invalidEmpty;
                              //     //   } else {
                              //     //     return null;
                              //     //   }
                              //     // },
                              //   ),
                              // ),
                              Focus(
                                onFocusChange: (hasFocus) {
                                  setState(() {
                                    isFocused = hasFocus;
                                  });
                                },
                                child: GooglePlaceAutoCompleteTextField(
                                  showError: true,
                                  textEditingController: locationCtrl,
                                  googleAPIKey:
                                      "AIzaSyC4s2RytxTio18VZNUZ2cF4mzAySh0AfUM",
                                  inputDecoration: InputDecoration(
                                    hintText: "Select Shop Location",
                                    border: InputBorder.none,
                                    hintStyle: Sty().smallText.copyWith(
                                        color: Clr().grey, fontFamily: "SF"),
                                    enabledBorder: InputBorder.none,
                                  ),
                                  textStyle: Sty().smallText.copyWith(
                                      color: Clr().textcolor, fontFamily: "SF"),
                                  debounceTime: 400,
                                  countries: ["in", "fr"],
                                  boxDecoration: BoxDecoration(
                                    color: Clr().white,
                                    borderRadius: BorderRadius.circular(55),
                                    border: Border.all(
                                      color: locationCtrl.text.isNotEmpty ||
                                              isFocused
                                          ? Clr().primaryColor
                                          : Clr().hintColor,
                                    ),
                                  ),
                                  isLatLngRequired: true,
                                  getPlaceDetailWithLatLng:
                                      (Prediction prediction) {
                                    slng = prediction.lng.toString();
                                    slat = prediction.lat.toString();
                                    print("Longitude + $slng");
                                    print("Latitude + $slat");
                                  },

                                  itemClick: (Prediction prediction) {
                                    locationCtrl.text =
                                        prediction.description ?? "";
                                    locationCtrl.selection =
                                        TextSelection.fromPosition(TextPosition(
                                            offset: prediction
                                                    .description?.length ??
                                                0));
                                  },
                                  seperatedBuilder: Divider(color: Clr().white),
                                  containerHorizontalPadding: 10,

                                  // OPTIONAL// If you want to customize list view item builder
                                  itemBuilder:
                                      (context, index, Prediction prediction) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          // color: Clr().white,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Icon(Icons.location_on,
                                              color: Clr().primaryColor),
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          Expanded(
                                              child: Text(
                                            "${prediction.description ?? ""}",
                                            style: Sty().smallText.copyWith(
                                                color: Clr().textcolor),
                                          ))
                                        ],
                                      ),
                                    );
                                  },
                                  isCrossBtnShown: true,

                                  // default 600 ms ,
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
                                    'Full Address',
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
                                  controller: addressCtrl,
                                  onTapOutside: (event) {
                                    FocusScope.of(context).unfocus();
                                  },
                                  cursorColor: Clr().textcolorsgray,
                                  style: Sty().smallText,
                                  keyboardType: TextInputType.name,
                                  textInputAction: TextInputAction.done,
                                  obscureText: false,
                                  maxLines: 3,
                                  decoration: Sty()
                                      .textFieldOutlineStyle
                                      .copyWith(
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(width: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(18)),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          borderSide: BorderSide(
                                            color:
                                                addressCtrl.text.isNotEmpty ||
                                                        isFocused
                                                    ? Clr().primaryColor
                                                    : Clr().hintColor,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          borderSide: BorderSide(
                                            color: Clr().primaryColor,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          borderSide: BorderSide(
                                            color: Clr().errorRed,
                                          ),
                                        ),
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(18),
                                          borderSide: BorderSide(
                                            color: Clr().errorRed,
                                          ),
                                        ),
                                        hintStyle: Sty().smallText.copyWith(
                                            color: Clr().grey,
                                            fontFamily: "SF"),
                                        hintText: "Enter Full Address",
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
                                    isFocused = hasFocus;
                                  });
                                },
                                child: TextFormField(
                                  controller: mobileCtrl,
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
                                            borderSide: BorderSide(width: 0.1),
                                            borderRadius:
                                                BorderRadius.circular(55)),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(55),
                                          borderSide: BorderSide(
                                            color: mobileCtrl.text.isNotEmpty ||
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
                                height: Dim().d12,
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
                  RichText(
                    text: TextSpan(
                      text: "By Submitting, you agree to the  ",
                      // text: '₹10,000 ',
                      style: Sty().smallText.copyWith(
                            color: Clr().textcolor,
                            fontFamily: 'SP',
                            fontWeight: FontWeight.w400,
                          ),
                      children: [
                        TextSpan(
                          text: 'Terms & Conditions',
                          style: Sty().smallText.copyWith(
                                color: Color(0xff0856C3),
                                fontFamily: 'SP',
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Dim().d20,
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
                                addContact();
                              }
                            },
                          );
                        }
                        ;
                      },
                      child: Text(
                        'Submit',
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
    );
  }

  /// getCities List Api
  void getCities() async {
    //Output
    var result =
        await STM().getwithToken(ctx, Str().loading, "get_cities", sToken);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(() {
        cityList = result['data'];
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  /// Add Product Api
  void addContact() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      "product_id": sProductID,
      "city_id": sCity,
      "latitude": slat,
      "longitude": slng,
      "location": locationCtrl.text,
      "address": addressCtrl.text,
      "mobile": mobileCtrl.text,
    });

    //Output
    var result = await STM().postWithToken(
        context, Str().loading, "add_product_contact", body, sToken);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(
        () {
          STM().successDialogWithReplace(ctx, message, ProductList());
        },
      );
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
