// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:geocoding/geocoding.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letsfind/values/colors.dart';
import 'package:letsfind/values/dimens.dart';
import 'package:letsfind/values/styles.dart';
import 'package:letsfind/view/add%20shops/shop_info.dart';
import 'package:letsfind/view/shop_listing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/static_method.dart';
import '../../values/colors.dart';
import '../../values/dimens.dart';
import '../../values/strings.dart';
import '../../values/styles.dart';
import '../imageview.dart';

class ShopDetails extends StatefulWidget {
  final data;
  const ShopDetails({super.key, this.data});
  @override
  State<ShopDetails> createState() => _ShopDetailsState();
}

class _ShopDetailsState extends State<ShopDetails> {
  late BuildContext ctx;

  bool isFocused = false;
  bool isFocused2 = false;
  bool isFocused3 = false;
  bool isFocused4 = false;
  bool isFocused5 = false;
  bool isFocused6 = false;
  List<dynamic> cityList = [];
  String? sCity, sToken, mapLoc, slat, slng, bse64Img, sCityId, sLocation;

  final _formKey = GlobalKey<FormState>();
  TextEditingController ownerNameCtrl = TextEditingController();
  TextEditingController shopNameCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  TextEditingController pincodeCtrl = TextEditingController();
  TextEditingController aboutCtrl = TextEditingController();
  TextEditingController locationCtrl = TextEditingController();
  File? imgFile;
  var getData;

  getsessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    print("Token :: $sToken");
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getCities();
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
    return WillPopScope(
      onWillPop: () async {
        widget.data != null
            ? STM().replacePage(ctx, const ShopListing())
            : STM().back2Previous(ctx);
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
                  : STM().back2Previous(ctx);
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
                  text: '1 ',
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
                                  'Shop Details',
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

                                Center(
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        height: Dim().d120,
                                        width: Dim().d120,
                                        decoration: const BoxDecoration(
                                          color: Color(0xffDCDCDC),
                                          shape: BoxShape.circle,
                                        ),
                                        child: imgFile != null
                                            ? InkWell(
                                                onTap: () {
                                                  STM().redirect2page(
                                                    ctx,
                                                    ImageViewPage(
                                                      img: imgFile,
                                                      type: 'file',
                                                    ),
                                                  );
                                                },
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(Dim().d100),
                                                  ),
                                                  child: Image.file(
                                                    imgFile!,
                                                    height: Dim().d150,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              )
                                            : widget.data != null
                                                ? InkWell(
                                                    onTap: () {
                                                      ImageViewPage(
                                                        img: widget
                                                            .data['shop_logo'],
                                                      );
                                                    },
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      child: CachedNetworkImage(
                                                        height: 55,
                                                        width: 55,
                                                        fit: BoxFit.cover,
                                                        imageUrl: widget
                                                            .data['shop_logo'],
                                                        placeholder: (context,
                                                                url) =>
                                                            STM()
                                                                .loadingPlaceHolder(),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Image.network(
                                                                fit: BoxFit
                                                                    .cover,
                                                                'https://www.famunews.com/wp-content/themes/newsgamer/images/dummy.png'),
                                                      ),
                                                    ),
                                                  )
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            32.0),
                                                    child: Image.asset(
                                                      'assets/home.png',
                                                      height: Dim().d32,
                                                      width: Dim().d20,
                                                      fit: BoxFit.contain,
                                                    ),
                                                  ),
                                      ),
                                      Positioned(
                                        bottom: 1,
                                        right: -15,
                                        child: InkWell(
                                          onTap: () {
                                            showModalBottomSheet(
                                                context: context,
                                                backgroundColor: Clr()
                                                    .background1,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    Dim().d14),
                                                            topRight:
                                                                Radius.circular(
                                                                    Dim()
                                                                        .d14))),
                                                builder: (index) {
                                                  return Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    Dim().d12,
                                                                vertical:
                                                                    Dim().d20),
                                                        child: Text('Shop Logo',
                                                            style: Sty()
                                                                .mediumBoldText),
                                                      ),
                                                      SizedBox(
                                                          height: Dim().d28),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              getImage(
                                                                  ImageSource
                                                                      .camera);
                                                              STM()
                                                                  .back2Previous(
                                                                      ctx);
                                                            },
                                                            child: Icon(
                                                              Icons
                                                                  .camera_alt_outlined,
                                                              color: Clr()
                                                                  .primaryColor,
                                                              size: Dim().d32,
                                                            ),
                                                          ),
                                                          InkWell(
                                                              onTap: () {
                                                                getImage(
                                                                    ImageSource
                                                                        .gallery);
                                                                STM()
                                                                    .back2Previous(
                                                                        ctx);
                                                              },
                                                              child: Icon(
                                                                Icons
                                                                    .yard_outlined,
                                                                size: Dim().d32,
                                                                color: Clr()
                                                                    .primaryColor,
                                                              )),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                          height: Dim().d40),
                                                    ],
                                                  );
                                                });
                                          },
                                          child: SvgPicture.asset(
                                            'assets/camera.svg',
                                            height: Dim().d56,
                                            width: Dim().d32,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Owner Name',
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
                                    controller: ownerNameCtrl,
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
                                              color: ownerNameCtrl
                                                          .text.isNotEmpty ||
                                                      isFocused
                                                  ? Clr().primaryColor
                                                  : Clr().hintColor,
                                            ),
                                          ),
                                          hintStyle: Sty().smallText.copyWith(
                                              color: Clr().grey,
                                              fontFamily: "SF"),
                                          hintText: "Enter Owner Name",
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
                                      'Shop Name',
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
                                    controller: shopNameCtrl,
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
                                              color: shopNameCtrl
                                                          .text.isNotEmpty ||
                                                      isFocused2
                                                  ? Clr().primaryColor
                                                  : Clr().hintColor,
                                            ),
                                          ),
                                          hintStyle: Sty().smallText.copyWith(
                                              color: Clr().grey,
                                              fontFamily: "SF"),
                                          hintText: "Enter Valid Shop Name",
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
                                              fontWeight: FontWeight.w400,
                                              color: sCity != null
                                                  ? Clr().black
                                                  : Clr().hintColor,
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
                                          sCityId = v;
                                          sCity =
                                              cityList[int.parse(v.toString())]
                                                  ['name'];
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
                                      'Shop Location',
                                      style: Sty().microText.copyWith(
                                          color: Clr().textcolor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: Dim().d8,
                                ),

                                /// Google Places API
                                Focus(
                                  onFocusChange: (hasFocus) {
                                    setState(() {
                                      isFocused3 = hasFocus;
                                    });
                                  },
                                  child: GooglePlaceAutoCompleteTextField(
                                    showError: true,
                                    textEditingController: locationCtrl,
                                    googleAPIKey:
                                        "AIzaSyAkOzCph93Hg4lejvCvndXXf_VdHANLaD4",
                                    inputDecoration: InputDecoration(
                                      hintText:
                                          sLocation ?? "Select Shop Location",
                                      border: InputBorder.none,
                                      hintStyle: Sty().smallText.copyWith(
                                          color: sLocation != null
                                              ? Clr().black
                                              : Clr().grey,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "SF"),
                                      enabledBorder: InputBorder.none,
                                    ),
                                    textStyle: Sty().smallText.copyWith(
                                        color: Clr().textcolor,
                                        fontFamily: "SF"),
                                    debounceTime: 400,
                                    countries: ["in", "fr"],
                                    boxDecoration: BoxDecoration(
                                      color: Clr().white,
                                      borderRadius: BorderRadius.circular(55),
                                      border: Border.all(
                                        color: locationCtrl.text.isNotEmpty ||
                                                isFocused3
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
                                          TextSelection.fromPosition(
                                        TextPosition(
                                            offset: prediction
                                                    .description?.length ??
                                                0),
                                      );
                                    },
                                    seperatedBuilder:
                                        Divider(color: Clr().white),
                                    containerHorizontalPadding: 10,
                                    // OPTIONAL// If you want to customize list view item builder
                                    itemBuilder: (context, index,
                                        Prediction prediction) {
                                      return Container(
                                        decoration: BoxDecoration(
                                            // color: Clr().white,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        padding: const EdgeInsets.all(10),
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
                                              ),
                                            )
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
                                  padding: EdgeInsets.only(left: Dim().d16),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Shop Address',
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
                                    controller: addressCtrl,
                                    onTapOutside: (event) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    cursorColor: Clr().textcolorsgray,
                                    style: Sty().smallText,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.done,
                                    obscureText: false,
                                    maxLines: 3,
                                    decoration: Sty()
                                        .textFieldOutlineStyle
                                        .copyWith(
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            borderSide: BorderSide(
                                              color: Clr().errorRed,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            borderSide: BorderSide(
                                              color: Clr().errorRed,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(width: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            borderSide: BorderSide(
                                              color:
                                                  addressCtrl.text.isNotEmpty ||
                                                          isFocused4
                                                      ? Clr().primaryColor
                                                      : Clr().hintColor,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            borderSide: BorderSide(
                                              color:
                                                  addressCtrl.text.isNotEmpty ||
                                                          isFocused4
                                                      ? Clr().primaryColor
                                                      : Clr().hintColor,
                                            ),
                                          ),
                                          hintStyle: Sty().smallText.copyWith(
                                              color: Clr().grey,
                                              fontFamily: "SF"),
                                          hintText:
                                              "Enter Complete Shop Address",
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
                                      'Shop Zipcode / Pincode',
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
                                    setState(
                                      () {
                                        isFocused5 = hasFocus;
                                      },
                                    );
                                  },
                                  child: TextFormField(
                                    controller: pincodeCtrl,
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
                                                  pincodeCtrl.text.isNotEmpty ||
                                                          isFocused5
                                                      ? Clr().primaryColor
                                                      : Clr().hintColor,
                                            ),
                                          ),
                                          hintStyle: Sty().smallText.copyWith(
                                              color: Clr().grey,
                                              fontFamily: "SF"),
                                          hintText: "Enter Shop Area Code",
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
                                  padding: EdgeInsets.only(left: Dim().d16),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'About Shop',
                                      style: Sty().microText.copyWith(
                                            color: Clr().textcolor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: Dim().d8,
                                ),
                                Focus(
                                  onFocusChange: (hasFocus) {
                                    setState(() {
                                      isFocused6 = hasFocus;
                                    });
                                  },
                                  child: TextFormField(
                                    controller: aboutCtrl,
                                    onTapOutside: (event) {
                                      FocusScope.of(context).unfocus();
                                    },
                                    cursorColor: Clr().textcolorsgray,
                                    style: Sty().smallText,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.done,
                                    obscureText: false,
                                    maxLines: 3,
                                    decoration: Sty()
                                        .textFieldOutlineStyle
                                        .copyWith(
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            borderSide: BorderSide(
                                              color: Clr().errorRed,
                                            ),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            borderSide: BorderSide(
                                              color: Clr().errorRed,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(width: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            borderSide: BorderSide(
                                              color:
                                                  aboutCtrl.text.isNotEmpty ||
                                                          isFocused6
                                                      ? Clr().primaryColor
                                                      : Clr().hintColor,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            borderSide: BorderSide(
                                              color:
                                                  aboutCtrl.text.isNotEmpty ||
                                                          isFocused6
                                                      ? Clr().primaryColor
                                                      : Clr().hintColor,
                                            ),
                                          ),
                                          hintStyle: Sty().smallText.copyWith(
                                              color: Clr().grey,
                                              fontFamily: "SF"),
                                          hintText:
                                              "Write brief about your shop...",
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
                                const SizedBox(
                                  height: 20,
                                ),
                                // InkWell(
                                //   onTap: () {},
                                //   child: Container(
                                //     width: double.infinity,
                                //     padding: EdgeInsets.symmetric(
                                //         vertical: Dim().d12,
                                //         horizontal: Dim().d20),
                                //     decoration: BoxDecoration(
                                //       border: Border.all(
                                //         color: Colors.black54,
                                //         width: 1.0,
                                //       ),
                                //       borderRadius: BorderRadius.all(
                                //         Radius.circular(Dim().d56),
                                //       ),
                                //     ),
                                //     child: Text(
                                //       imgFile != null
                                //           ? 'Image selected'
                                //           : 'Select a shop logo',
                                //       style: Sty().smallText.copyWith(
                                //             color: imgFile != null
                                //                 ? Clr().black
                                //                 : Clr().hintColor,
                                //             fontWeight: FontWeight.w500,
                                //           ),
                                //     ),
                                //   ),
                                // ),
                                // SizedBox(
                                //   height: Dim().d12,
                                // ),
                                // InkWell(
                                //   onTap: () {
                                //     STM().redirect2page(
                                //       ctx,
                                //       ImageViewPage(
                                //         img: imgFile,
                                //         type: 'file',
                                //       ),
                                //     );
                                //   },
                                //   child: ClipRRect(
                                //     borderRadius: BorderRadius.all(
                                //       Radius.circular(Dim().d12),
                                //     ),
                                //     child: imgFile != null
                                //         ?
                                //         : Container(),
                                //   ),
                                // ),
                                // widget.data != null
                                //     ? SizedBox(
                                //         height: Dim().d12,
                                //       )
                                //     : Container(),
                                // if (widget.data != null)
                                //   InkWell(
                                //     onTap: () {
                                //       STM().redirect2page(
                                //         ctx,
                                //         ImageViewPage(
                                //           img: widget.data['shop_logo'],
                                //         ),
                                //       );
                                //     },
                                //     child: ClipRRect(
                                //       borderRadius: BorderRadius.all(
                                //         Radius.circular(Dim().d12),
                                //       ),
                                //       child: Image.network(
                                //         widget.data['shop_logo'],
                                //         height: Dim().d150,
                                //         width: double.infinity,
                                //         fit: BoxFit.cover,
                                //       ),
                                //     ),
                                //   ),
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
                              elevation: 0,
                              backgroundColor: Clr().primaryColor),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              STM().checkInternet(context, widget).then(
                                (value) {
                                  if (value) {
                                    if (widget.data != null ||
                                        bse64Img != null) {
                                      submitStep1();
                                    } else {
                                      STM().displayToast(
                                          'Please select a shop logo');
                                    }
                                  }
                                },
                              );
                            }
                            ;
                          },
                          child: Text(
                            widget.data != null ? 'Update' : 'Next',
                            style:
                                Sty().mediumText.copyWith(color: Clr().white),
                          )),
                    ),

                    // TextFormField(
                    //   readOnly: true,
                    //   keyboardType: TextInputType.name,
                    //   textInputAction: TextInputAction.done,
                    //   style: Sty().smallText,
                    //   cursorColor: Clr().black,
                    //   maxLines: mapLoc != null ? 4 : null,
                    //   onTap: () async {
                    //     await loc.PlacesAutocomplete.show(
                    //         context: context,
                    //         apiKey: 'AIzaSyC4s2RytxTio18VZNUZ2cF4mzAySh0AfUM',
                    //         onError: (value) {
                    //           STM().errorDialog(ctx, value.status);
                    //         },
                    //         // call the onerror function below
                    //         mode: loc.Mode.overlay,
                    //         language: 'en',
                    //         //you can set any language for search
                    //         strictbounds: false,
                    //         types: [],
                    //         decoration: InputDecoration(
                    //             hintStyle: Sty().smallText.copyWith(
                    //                 fontWeight: FontWeight.w400,
                    //                 color: Theme.of(ctx).colorScheme.primary),
                    //             hintText: 'search...',
                    //             fillColor: Theme.of(ctx).colorScheme.background,
                    //             filled: true),
                    //         logo: Container(
                    //           height: 0,
                    //         ),
                    //         components: [] // you can determine search for just one country
                    //     ).then((v) async {
                    //       await locationFromAddress(v!.description.toString())
                    //           .then((value) {
                    //         setState(() {
                    //           mapLoc = v.description;
                    //           slng = value[0].longitude.toString();
                    //           Slat = value[0].latitude.toString();
                    //         });
                    //       });
                    //     });
                    //   },
                    //   decoration: Sty().TextFormFieldOutlineDarkStyle.copyWith(
                    //     hintMaxLines: null,
                    //     hintText: mapLoc ?? 'Enter Location',
                    //     hintStyle: Sty().smallText.copyWith(
                    //       color:
                    //       mapLoc != null ? Clr().black : Clr().hintColor,
                    //       fontWeight: FontWeight.w400,
                    //     ),
                    //     suffixIcon: Icon(
                    //       Icons.my_location_outlined,
                    //       color: Clr().black,
                    //     ),
                    //     filled: true,
                    //     fillColor: Clr().white,
                    //   ),
                    //   validator: (value) {
                    //     if (mapLoc!.isEmpty) {
                    //       return 'Please enter a Address';
                    //     }
                    //   },
                    // ),
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

  placesAutoCompleteTextField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: locationCtrl,
        googleAPIKey: "AIzaSyAkOzCph93Hg4lejvCvndXXf_VdHANLaD4",
        inputDecoration: InputDecoration(
          hintText: "Search your location",
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
        debounceTime: 400,
        countries: ["in", "fr"],
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (Prediction prediction) {
          print("placeDetails" + prediction.lat.toString());
          print("placeDetails" + prediction.lng.toString());
        },

        itemClick: (Prediction prediction) {
          locationCtrl.text = prediction.description ?? "";
          locationCtrl.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description?.length ?? 0));
        },
        seperatedBuilder: Divider(),
        containerHorizontalPadding: 10,

        // OPTIONAL// If you want to customize list view item builder
        itemBuilder: (context, index, Prediction prediction) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(
                  width: 7,
                ),
                Expanded(child: Text("${prediction.description ?? ""}"))
              ],
            ),
          );
        },

        isCrossBtnShown: true,

        // default 600 ms ,
      ),
    );
  }

  ///Submit Step 1
  void submitStep1() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      "id": widget.data != null ? widget.data['id'] : null,
      "owner_name": ownerNameCtrl.text,
      "shop_name": shopNameCtrl.text,
      "city_id": sCityId,
      "latitude": slat,
      "longitude": slng,
      "address": addressCtrl.text,
      "pincode": pincodeCtrl.text,
      "about_shop": aboutCtrl.text,
      "shop_logo": bse64Img,
    });
    var result = await STM().postWithToken(
      ctx,
      Str().loading,
      'step1',
      body,
      sp.getString('token'),
    );
    var success = result['success'];
    var message = result['message'];
    if (success) {
      if (widget.data != null) {
        setState(() {
          sp.setString("shop_id", result['data']['shop_id'].toString());
        });
        STM().successDialogWithReplace(ctx, message, const ShopListing());
      } else {
        setState(() {
          sp.setString("shop_id", result['data']['shop_id'].toString());
          STM().displayToast(message);
          STM().redirect2page(
            ctx,
            const ShopInfo(),
          );
        });
      }
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  /// getCities List Api
  void getCities() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    //Output
    var result = await STM().getwithToken(
      context,
      Str().loading,
      "get_cities",
      sp.getString('token'),
    );
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(() {
        cityList = result['data'];
      });
      if (widget.data != null) {
        setState(() {
          ownerNameCtrl =
              TextEditingController(text: widget.data['owner_name']);
          shopNameCtrl = TextEditingController(text: widget.data['shop_name']);
          addressCtrl = TextEditingController(text: widget.data['address']);
          pincodeCtrl =
              TextEditingController(text: widget.data['pincode'].toString());
          aboutCtrl = TextEditingController(text: widget.data['about_shop']);
          int pos = cityList.indexWhere((element) =>
              element['id'].toString() == widget.data['city_id'].toString());
          sCity = cityList[pos]['name'];
          sCityId = widget.data['city_id'].toString();
          slat = widget.data['latitude'];
          slng = widget.data['longitude'];
          getLatLng(
            double.parse(slat.toString()),
            double.parse(
              slng.toString(),
            ),
          );
        });
      }
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  getLatLng(lat, lng) async {
    List<Placemark> list = await placemarkFromCoordinates(lat, lng);
    setState(() {
      sLocation = '${list[0].locality} ${list[0].subLocality}';
    });
  }

  void getImage(ImageSource) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imgFile = File(pickedFile.path.toString());
        var image = imgFile!.readAsBytesSync();
        bse64Img = base64Encode(image);
      });
    }
  }
}
