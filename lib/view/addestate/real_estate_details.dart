// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:letsfind/values/dimens.dart';
import 'package:letsfind/view/imageview.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bottomnavigation/bottomnavigationPage.dart';
import '../../data/static_method.dart';
import '../../values/colors.dart';
import '../../values/dimens.dart';
import '../../values/strings.dart';
import '../../values/styles.dart';

class RealEstateDetails extends StatefulWidget {
  final sID;

  const RealEstateDetails({Key? key, this.sID}) : super(key: key);

  @override
  State<RealEstateDetails> createState() => _RealEstateDetailsState();
}

class _RealEstateDetailsState extends State<RealEstateDetails> {
  late BuildContext ctx;

  getsessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        propertyDetails();
      }
    });
  }

  @override
  void initState() {
    getsessionData();
    super.initState();
  }

  dynamic pDetails;
  int pageIndex = 0;
  List<dynamic> imageList = [];
  List<dynamic> amenitiesList = [];
  List<dynamic> similarPropList = [];
  bool isLoaded = false;

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
          centerTitle: true,
          actions: [
            Container(
              width: 30,
            )
          ],
          title: Text(
            // 'Victory Splendefsd gfgfdgf dfgdfgd dfdfhdfdfgsdfgw r retey thtrh',
            isLoaded ? pDetails['name'].toString() : '',
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: Sty().largeText.copyWith(
                  color: Clr().primaryColor,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ),
        bottomNavigationBar: bottomBarLayout(ctx, 0),
        body: SingleChildScrollView(
          child: isLoaded
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 380,
                            viewportFraction: 1,
                            enlargeCenterPage: true,
                            enableInfiniteScroll: true,
                            autoPlay: true,
                            onPageChanged: (index, reason) {
                              setState(() {
                                pageIndex = index;
                              });
                            },
                          ),
                          items: imageList
                              .map((e) => InkWell(
                                    onTap: () {
                                      // List<dynamic> imagePaths = imageList
                                      //     .map((e) => e['image'].toString())
                                      //     .toList();
                                      // print("Page Index :: $pageIndex");
                                      // print("Image Path :: $imagePaths");
                                      STM().redirect2page(
                                          context,
                                          ImageViewPage(
                                              img: imageList[pageIndex]['image']
                                                  .toString()));
                                    },
                                    child: ClipRRect(
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: <Widget>[
                                          CachedNetworkImage(
                                            imageUrl: e['image'].toString(),
                                            width: double.infinity,
                                            // height: 300,
                                            fit: BoxFit.cover,
                                            // fit: BoxFit.fill,
                                            placeholder: (context, url) =>
                                                CircularProgressIndicator(
                                              color: Clr().transparent,
                                            ),
                                            errorWidget: (context, url,
                                                    error) =>
                                                Image.network(
                                                    'https://www.famunews.com/wp-content/themes/newsgamer/images/dummy.png',
                                                    height: 56,
                                                    width: 56,
                                                    fit: BoxFit.cover),
                                          )
                                          // Image.network(
                                          //   imageList['image'],
                                          //   fit: BoxFit.cover,
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                        Positioned(
                          bottom: 16,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xffffffff),
                                // color: Colors.red,
                                borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 2.0),
                              child: SizedBox(
                                height: Dim().d8,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: imageList.length,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    final isLastItem =
                                        index == imageList.length - 1;
                                    final margin = isLastItem ? 0.0 : 6.0;
                                    return Container(
                                      width: Dim().d8,
                                      height: Dim().d8,
                                      margin: EdgeInsets.only(right: margin),
                                      decoration: BoxDecoration(
                                        color: pageIndex == index
                                            ? Clr().primaryColor
                                            : Color(0xffB3B3B3),
                                        // : Color(0xffe3e3e3),
                                        shape: BoxShape.circle,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Dim().d20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dim().d16,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Clr().white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                                color: Clr().hintColor.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 0)
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Dim().d16, vertical: Dim().d16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                // 'Victory Splendeour RESALE 2BHK Flat in Koperkhairan',
                                pDetails['name'].toString(),
                                style: Sty().mediumText.copyWith(
                                    color: Clr().textcolor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: Dim().d12,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 22,
                                    decoration: BoxDecoration(
                                        color: Color(0xffDCDCDC),
                                        borderRadius:
                                            BorderRadius.circular(55)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 2),
                                      child: Text(
                                        pDetails['property_type'].toString(),
                                        style: Sty().microText.copyWith(
                                            color: const Color(0xff606060),
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Dim().d12,
                                  ),
                                  Container(
                                    height: 22,
                                    decoration: BoxDecoration(
                                        color: Color(0xffDCDCDC),
                                        borderRadius:
                                            BorderRadius.circular(55)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 2),
                                      child: Text(
                                        pDetails['ownership'].toString(),
                                        style: Sty().microText.copyWith(
                                            color: const Color(0xff606060),
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: Dim().d12,
                              ),
                              ReadMoreText(
                                pDetails['description'].toString(),
                                trimLines: 3,
                                colorClickableText: Clr().primaryColor,
                                trimMode: TrimMode.Line,
                                trimCollapsedText: 'Read More',
                                trimExpandedText: ' Show less',
                                moreStyle: TextStyle(
                                  fontSize: 14,
                                  color: Clr().primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: Clr().textcolor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dim().d20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dim().d16,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Clr().white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                                color: Clr().hintColor.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 0)
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dim().d16, vertical: Dim().d16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Type of Property ",
                                        style: Sty().smallText.copyWith(
                                            color: Clr().textcolor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: Dim().d4,
                                      ),
                                      Text(
                                        pDetails['type_of_property'].toString(),
                                        style: Sty().smallText.copyWith(
                                            color: Clr().textcolor,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Property Status",
                                        style: Sty().smallText.copyWith(
                                            color: Clr().textcolor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: Dim().d4,
                                      ),
                                      Text(
                                        pDetails['property_status'].toString(),
                                        style: Sty().smallText.copyWith(
                                            color: Clr().textcolor,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            pDetails['property_type'].toString() != "Commercial"
                                ? const Divider(
                                    color: Color(0xffDCDCDC),
                                  )
                                : Container(),
                            pDetails['property_type'].toString() != "Commercial"
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Dim().d16,
                                        vertical: Dim().d16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Rooms",
                                              style: Sty().smallText.copyWith(
                                                  color: Clr().textcolor,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: Dim().d4,
                                            ),
                                            Text(
                                              pDetails['room'].toString(),
                                              style: Sty().smallText.copyWith(
                                                  color: Clr().textcolor,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "Balcony",
                                              style: Sty().smallText.copyWith(
                                                  color: Clr().textcolor,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: Dim().d4,
                                            ),
                                            Text(
                                              pDetails['balcony'].toString(),
                                              style: Sty().smallText.copyWith(
                                                  color: Clr().textcolor,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            const Divider(
                              color: Color(0xffDCDCDC),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dim().d16, vertical: Dim().d16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        pDetails['property_type'].toString() !=
                                                "Commercial"
                                            ? "Bathroom"
                                            : "Washroom",
                                        style: Sty().smallText.copyWith(
                                            color: Clr().textcolor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: Dim().d4,
                                      ),
                                      Text(
                                        pDetails['property_type'].toString() !=
                                                "Commercial"
                                            ? pDetails['bathroom'].toString()
                                            : pDetails['washroom'].toString(),
                                        style: Sty().smallText.copyWith(
                                            color: Clr().textcolor,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(pDetails['washroom'].toString()),
                                      Text(
                                        "Parking Availability",
                                        style: Sty().smallText.copyWith(
                                            color: Clr().textcolor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: Dim().d4,
                                      ),
                                      Text(
                                        pDetails['parking'].toString() == "1" ||
                                                pDetails['parking']
                                                        .toString() ==
                                                    1
                                            ? "Yes"
                                            : " No",
                                        style: Sty().smallText.copyWith(
                                            color: Clr().textcolor,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dim().d20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dim().d16,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Clr().white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                                color: Clr().hintColor.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 0)
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dim().d16, vertical: Dim().d16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Builtup Area",
                                        style: Sty().smallText.copyWith(
                                            color: Clr().textcolor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: Dim().d4,
                                      ),
                                      Text(
                                        "${pDetails['builtup_area'].toString()} sqft",
                                        style: Sty().smallText.copyWith(
                                            color: Clr().textcolor,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Carpet Area",
                                        style: Sty().smallText.copyWith(
                                            color: Clr().textcolor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: Dim().d4,
                                      ),
                                      Text(
                                        "${pDetails['carpet_area'].toString()} sqft",
                                        style: Sty().smallText.copyWith(
                                            color: Clr().textcolor,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              color: Color(0xffDCDCDC),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dim().d16, vertical: Dim().d16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Total Price",
                                        style: Sty().smallText.copyWith(
                                            color: Clr().textcolor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: Dim().d4,
                                      ),
                                      Text(
                                        "₹ ${pDetails['total_price'].toString()}",
                                        style: Sty().smallText.copyWith(
                                            color: Clr().textcolor,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "Booking Amount",
                                        style: Sty().smallText.copyWith(
                                            color: Clr().textcolor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: Dim().d4,
                                      ),
                                      Text(
                                        "₹ ${pDetails['booking_amount'].toString()}",
                                        style: Sty().smallText.copyWith(
                                            color: Clr().textcolor,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              color: Color(0xffDCDCDC),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dim().d16, vertical: Dim().d16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Registration Price",
                                          style: Sty().smallText.copyWith(
                                              color: Clr().textcolor,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          height: Dim().d4,
                                        ),
                                        Text(
                                          "₹ ${pDetails['registration_price'].toString()}",
                                          style: Sty().smallText.copyWith(
                                              color: Clr().textcolor,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "RERA ID",
                                          style: Sty().smallText.copyWith(
                                              color: Clr().textcolor,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          height: Dim().d4,
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            pDetails['rara_id'].toString(),
                                            textAlign: TextAlign.right,
                                            style: Sty().smallText.copyWith(
                                                color: Clr().textcolor,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dim().d20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dim().d16,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Clr().white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                                color: Clr().hintColor.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 0)
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dim().d16, vertical: Dim().d16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Mobile Number",
                                        style: Sty().smallText.copyWith(
                                            color: Clr().textcolor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: Dim().d4,
                                      ),
                                      Text(
                                        "+91 ${pDetails['mobile'].toString()}",
                                        style: Sty().smallText.copyWith(
                                            color: Clr().textcolor,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 35,
                                    height: 35,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        STM().openDialer(
                                          "+91 ${pDetails['mobile'].toString()}",
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(55),
                                          ),
                                          backgroundColor: Clr().primaryColor),
                                      child: SvgPicture.asset(
                                        "assets/call.svg",
                                        width: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              color: Color(0xffDCDCDC),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dim().d16, vertical: Dim().d16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "City",
                                        style: Sty().smallText.copyWith(
                                            color: Clr().textcolor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: Dim().d4,
                                      ),
                                      Text(
                                        pDetails['city'].toString(),
                                        style: Sty().smallText.copyWith(
                                            color: Clr().textcolor,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              color: Color(0xffDCDCDC),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dim().d16, vertical: Dim().d16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Address",
                                          style: Sty().smallText.copyWith(
                                              color: Clr().textcolor,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          height: Dim().d4,
                                        ),
                                        Text(
                                          pDetails['address'].toString(),
                                          style: Sty().smallText.copyWith(
                                              color: Clr().textcolor,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: Dim().d12,
                                  ),
                                  SizedBox(
                                    width: 35,
                                    height: 35,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await launchUrl(
                                          Uri.parse(
                                              'geo:${pDetails['latitude']},${pDetails['longitude']}?q=${pDetails['latitude']},${pDetails['longitude']}'),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(55),
                                          ),
                                          backgroundColor: Clr().primaryColor),
                                      child: SvgPicture.asset(
                                        "assets/location.svg",
                                        width: 35,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    amenitiesList.isNotEmpty
                        ? SizedBox(
                            height: Dim().d20,
                          )
                        : Container(),
                    amenitiesList.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dim().d16,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Clr().white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                      color: Clr().hintColor.withOpacity(0.1),
                                      blurRadius: 10,
                                      spreadRadius: 0)
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Ammenities",
                                      style: Sty().smallText.copyWith(
                                          color: Clr().textcolor,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(
                                      height: Dim().d12,
                                    ),
                                    ListView.separated(
                                      separatorBuilder: (context, index) {
                                        return SizedBox(
                                          height: Dim().d12,
                                        );
                                      },
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: amenitiesList.length,
                                      itemBuilder: (ctx, index) {
                                        return Row(
                                          children: [
                                            SvgPicture.asset(
                                                "assets/points.svg"),
                                            SizedBox(
                                              width: Dim().d12,
                                            ),
                                            Expanded(
                                              child: Text(
                                                amenitiesList[index]['name']
                                                    .toString(),
                                                style: Sty().smallText.copyWith(
                                                    color: Clr().textcolor),
                                              ),
                                            )
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: Dim().d20,
                    ),
                    similarPropList.isEmpty
                        ? Container()
                        : Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dim().d16,
                            ),
                            child: Text(
                              "Similar Properties",
                              style: Sty().smallText.copyWith(
                                  color: Clr().textcolor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                    SizedBox(
                      height: Dim().d12,
                    ),
                    similarPropList.isEmpty
                        ? Container()
                        : SizedBox(
                            height: 136,
                            child: ListView.separated(
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  width: Dim().d20,
                                );
                              },
                              shrinkWrap: true,
                              padding:
                                  EdgeInsets.symmetric(horizontal: Dim().d16),
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              itemCount: similarPropList.length,
                              itemBuilder: (context, index) {
                                return similarCardLayout(
                                    ctx, index, similarPropList);
                              },
                            ),
                          ),
                    SizedBox(
                      height: Dim().d40,
                    ),
                  ],
                )
              : Container(),
        ));
  }

  /// Similar Properties Card Layout
  Widget similarCardLayout(ctx, index, list) {
    var v = list[index];

    return InkWell(
      onTap: () {
        STM().redirect2page(
          ctx,
          RealEstateDetails(
            sID: v['id'],
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 1.2,
        decoration: BoxDecoration(
          color: Clr().white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: Clr().hintColor.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 0)
          ],
        ),
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: Dim().d12, vertical: Dim().d12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Clr().borderColor,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          v['image'],
                          width: 90,
                          height: 110,
                          fit: BoxFit.cover,
                        )),
                  ),
                  SizedBox(
                    width: Dim().d20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          v['name'].toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Sty().mediumText.copyWith(
                              color: Clr().textcolor,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: Dim().d8,
                        ),
                        Text(
                          '₹ ${v['price']}/-',
                          style: Sty().mediumText.copyWith(
                              color: Clr().textcolor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: Dim().d12,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Posted On: ${v['posted_on']}',
                            style: Sty().microText.copyWith(
                                color: Color(0xff949494),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///property Details Api
  void propertyDetails() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      "property_id": widget.sID,
    });
    var result = await STM().postWithToken(
        ctx, Str().loading, 'property_details', body, sp.getString('token'));
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(() {
        isLoaded = true;
        imageList = result['data']['images'];
        amenitiesList = result['data']['amenity'];
        similarPropList = result['data']['similar_properties'];
        pDetails = result['data'];
        log(pDetails.toString());
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
