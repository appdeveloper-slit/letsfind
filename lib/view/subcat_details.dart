// ignore_for_file: prefer_const_constructors

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:letsfind/values/colors.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:readmore/readmore.dart';
import 'package:url_launcher/url_launcher.dart';
import '../bottomnavigation/bottomnavigationPage.dart';
import '../controller/subcatdetailscontroller.dart';
import '../data/static_method.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import 'reviewdetails.dart';

class SubCatDetails extends StatefulWidget {
  final data;
  const SubCatDetails({Key? key, this.data}) : super(key: key);

  @override
  State<SubCatDetails> createState() => _SubCatDetailsState();
}

class _SubCatDetailsState extends State<SubCatDetails> {
  late BuildContext ctx;
  bool isPressed = false;
  int selectedSlider = 0;

  bool checkhours = false;

  List<dynamic> sliderList = [
    "assets/detail_slider.png",
    "assets/detail_slider.png",
    "assets/detail_slider.png"
  ];

  List weekList = [
    {'day_id': 1, 'name': 'Sunday'},
    {'day_id': 2, 'name': 'Monday'},
    {'day_id': 3, 'name': 'Tuesday'},
    {'day_id': 4, 'name': 'Wednesday'},
    {'day_id': 5, 'name': 'Thursday'},
    {'day_id': 6, 'name': 'Friday'},
    {'day_id': 7, 'name': 'Saturday'},
  ];

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(
      Duration.zero,
      () {
        subcatdetilscontroller()
            .getshopDeatils(ctx, setState, widget.data['id']);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
      backgroundColor: Clr().background,
      bottomNavigationBar: bottomBarLayout(ctx, 0),
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
        title: Text(
          details != null ? details['shop_name'] : '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Sty().largeText.copyWith(
                color: Clr().primaryColor,
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
      body: SingleChildScrollView(
        child: details == null
            ? Container()
            : Column(
                children: [
                  sliderLayout(ctx),
                  Padding(
                    padding: EdgeInsets.all(Dim().d12),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.zero,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                  color: Clr().shimmerColor.withOpacity(0.1),
                                  blurRadius: 12,
                                  spreadRadius: 1)
                            ],
                          ),
                          child: Card(
                            color: Clr().white,
                            elevation: 0,
                            shape: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(18)),
                                borderSide: BorderSide(
                                  color: Clr().borderColor,
                                )),
                            child: Padding(
                              padding: EdgeInsets.all(Dim().d12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    details['shop_name'],
                                    style: Sty().largeText.copyWith(
                                        color: Clr().textcolor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: Dim().d12,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: const Color(0xffFFB400),
                                            borderRadius:
                                                BorderRadius.circular(55)),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: Dim().d8,
                                            vertical: Dim().d4,
                                          ),
                                          child: Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              Text(
                                                details['rating']
                                                    .toString(),
                                                style: Sty().microText.copyWith(
                                                    color: Clr().white,
                                                    fontWeight:
                                                        FontWeight.w800),
                                              ),
                                              SizedBox(
                                                width: Dim().d4,
                                              ),
                                              Icon(
                                                Icons.star,
                                                size: 14,
                                                color: Clr().white,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: Dim().d32,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          STM().redirect2page(
                                            ctx,
                                            reviewdetailsPage(
                                              id: widget.data['id'],
                                            ),
                                          );
                                        },
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${STM().formatAmount(details['total_review'])} Reviews',
                                              style: Sty().smallText.copyWith(
                                                  color: Color(0xff464646),
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              '-----------------',
                                              style: Sty().microText.copyWith(
                                                  color: Color(0xff464646),
                                                  height: 0.2,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: Dim().d32,
                                      ),
                                      if (details['is_verified'] == true)
                                        Container(
                                          decoration: BoxDecoration(
                                              color: const Color(0xff2AC0D4),
                                              borderRadius:
                                                  BorderRadius.circular(55)),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: Dim().d16,
                                              vertical: Dim().d4,
                                            ),
                                            child: Wrap(
                                              crossAxisAlignment:
                                                  WrapCrossAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.verified,
                                                  size: 14,
                                                  color: Clr().white,
                                                ),
                                                SizedBox(
                                                  width: Dim().d4,
                                                ),
                                                Text(
                                                  'Verified',
                                                  style: Sty()
                                                      .microText
                                                      .copyWith(
                                                          color: Clr().white,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: Dim().d12,
                                  ),
                                  ReadMoreText(
                                    details['about_shop'],
                                    trimMode: TrimMode.Line,
                                    trimLines: 2,
                                    trimLength: 200,
                                    style: Sty().smallText.copyWith(
                                        color: Clr().black,
                                        height: 1.4,
                                        fontWeight: FontWeight.w400),
                                    trimCollapsedText: 'Expand',
                                    trimExpandedText: ' Collapse ',
                                    colorClickableText: Clr().primaryColor,
                                  ),
                                  // Text(
                                  //   details['about_shop'],
                                  //   maxLines: isPressed ? null : 2,
                                  //   style: Sty().smallText.copyWith(
                                  //       color: Clr().black,
                                  //       height: 1.4,
                                  //       fontWeight: FontWeight.w400),
                                  // ),
                                  // SizedBox(
                                  //   height: Dim().d2,
                                  // ),
                                  // details['about_shop'].toString().length > 200
                                  //     ? InkWell(
                                  //         onTap: () {
                                  //           if (isPressed) {
                                  //             setState(() {
                                  //               isPressed = false;
                                  //             });
                                  //           } else {
                                  //             setState(() {
                                  //               isPressed = true;
                                  //             });
                                  //           }
                                  //         },
                                  //         child: Text(
                                  //           isPressed
                                  //               ? 'Read Less'
                                  //               : 'Read More',
                                  //           style: Sty().microText.copyWith(
                                  //               color: Clr().primaryColor,
                                  //               fontWeight: FontWeight.w600),
                                  //         ))
                                  //     : Container(),
                                  // Padding(
                                  //   padding: EdgeInsets.all(Dim().d20),
                                  //   child: Row(
                                  //     children: [
                                  //       InkWell(
                                  //           onTap: () async {
                                  //             await launch(
                                  //                 details['facebook_link']);
                                  //           },
                                  //           child: SvgPicture.asset(
                                  //               'assets/facebook.svg')),
                                  //       SizedBox(
                                  //         width: Dim().d28,
                                  //       ),
                                  //       InkWell(
                                  //           onTap: () async {
                                  //             await launch(
                                  //                 details['youtube_link']);
                                  //           },
                                  //           child: SvgPicture.asset(
                                  //               'assets/youtube.svg')),
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 75,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: details['offers'].length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: offerLayout(
                                      ctx, details['offers'][index]),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  width: Dim().d4,
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.zero,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                  color: Clr().shimmerColor.withOpacity(0.1),
                                  blurRadius: 12,
                                  spreadRadius: 1)
                            ],
                          ),
                          child: Card(
                            color: Clr().white,
                            elevation: 0,
                            shape: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(18)),
                                borderSide: BorderSide(
                                  color: Clr().borderColor,
                                )),
                            child: Padding(
                              padding: EdgeInsets.all(Dim().d12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: Dim().d8,
                                  ),
                                  Text('Address',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Clr().primaryColor,
                                      )),
                                  SizedBox(
                                    height: Dim().d4,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: Text(details['address'],
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: Clr().textcolor,
                                            )),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          await launchUrl(
                                            Uri.parse(
                                                'geo:${details['latitude']},${details['longitude']}?q=${details['latitude']},${details['longitude']}'),
                                          );
                                        },
                                        child: SvgPicture.asset(
                                          "assets/location.svg",
                                          width: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: Dim().d8,
                                  ),
                                  Divider(
                                    color: Clr().borderColor.withOpacity(1),
                                  ),
                                  SizedBox(
                                    height: Dim().d8,
                                  ),
                                  Text('City',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Clr().primaryColor,
                                      )),
                                  SizedBox(
                                    height: Dim().d4,
                                  ),
                                  Text(details['city'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Clr().textcolor,
                                      )),
                                  SizedBox(
                                    height: Dim().d8,
                                  ),
                                  Divider(
                                    color: Clr().borderColor.withOpacity(1),
                                  ),
                                  SizedBox(
                                    height: Dim().d8,
                                  ),
                                  Text('Contacts',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Clr().primaryColor,
                                      )),
                                  SizedBox(
                                    height: Dim().d4,
                                  ),
                                  Row(
                                    children: [
                                      Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          Text('${details['mobile']}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                                color: Clr().textcolor,
                                              )),
                                          SizedBox(
                                            width: Dim().d12,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              await STM().openDialer(
                                                  details['mobile']);
                                            },
                                            child: Container(
                                              height: 28,
                                              width: 28,
                                              decoration: BoxDecoration(
                                                  color: Clr().primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          55)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(9.0),
                                                child: SvgPicture.asset(
                                                  "assets/phone.svg",
                                                  width: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (details['alt_mobile'] != null)
                                        Text(
                                          '  /  ',
                                          style: Sty().extraLargeText,
                                        ),
                                      if (details['alt_mobile'] != null)
                                        Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            Text('${details['alt_mobile']}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  color: Clr().textcolor,
                                                )),
                                            SizedBox(
                                              width: Dim().d12,
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                await STM().openDialer(
                                                    details['alt_mobile']);
                                              },
                                              child: Container(
                                                height: 28,
                                                width: 28,
                                                decoration: BoxDecoration(
                                                    color: Clr().primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            55)),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(9.0),
                                                  child: SvgPicture.asset(
                                                    "assets/phone.svg",
                                                    width: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: Dim().d8,
                                  ),
                                  if (details['wp_mobile'] != null)
                                    Divider(
                                      color: Clr().borderColor.withOpacity(1),
                                    ),
                                  if (details['wp_mobile'] != null)
                                    SizedBox(
                                      height: Dim().d8,
                                    ),
                                  if (details['wp_mobile'] != null)
                                    Text('WhatsApp Number',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Clr().primaryColor,
                                        )),
                                  if (details['wp_mobile'] != null)
                                    SizedBox(
                                      height: Dim().d4,
                                    ),
                                  if (details['wp_mobile'] != null)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          details['wp_mobile'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: Clr().textcolor,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            await STM().openWhatsApp(
                                                details['wp_mobile']);
                                          },
                                          child: Container(
                                            height: 32,
                                            width: 32,
                                            decoration: BoxDecoration(
                                                color: Clr().green,
                                                borderRadius:
                                                    BorderRadius.circular(55)),
                                            child: Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: SvgPicture.asset(
                                                "assets/wp.svg",
                                                width: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  SizedBox(
                                    height: Dim().d8,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Dim().d20,
                        ),
                        Container(
                          margin: EdgeInsets.zero,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                  color: Clr().shimmerColor.withOpacity(0.1),
                                  blurRadius: 12,
                                  spreadRadius: 1)
                            ],
                          ),
                          child: Card(
                            color: Clr().white,
                            elevation: 0,
                            shape: OutlineInputBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(18)),
                              borderSide: BorderSide(
                                color: Clr().borderColor,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(Dim().d12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: Dim().d8,
                                  ),
                                  Text(
                                    'Services',
                                    style: Sty().largeText.copyWith(
                                          color: Clr().textcolor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  SizedBox(
                                    height: Dim().d8,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      AwesomeDialog(
                                        context: ctx,
                                        dialogType: DialogType.noHeader,
                                        body: SizedBox(
                                          height: 500.0,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Text(
                                                  'Services',
                                                  style: Sty()
                                                      .mediumText
                                                      .copyWith(
                                                        color:
                                                            Clr().primaryColor,
                                                      ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: ListView.builder(
                                                    itemCount:
                                                        details['services']
                                                            .length,
                                                    shrinkWrap: true,
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SvgPicture.asset(
                                                            "assets/tick.svg",
                                                            width: 14,
                                                          ),
                                                          SizedBox(
                                                            width: Dim().d8,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              '${details['services'][index]['name']}',
                                                              style: Sty()
                                                                  .smallText
                                                                  .copyWith(
                                                                      color: Clr()
                                                                          .textcolor),
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ).show();
                                    },
                                    child: Container(
                                      height: Dim().d40,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Clr().primaryColor,
                                          width: 0.5,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(Dim().d20),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Check Services',
                                          style: Sty().smallText.copyWith(
                                              color: Clr().primaryColor),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: Dim().d12,
                                  ),
                                  Text(
                                    'Quick Information',
                                    style: Sty().largeText.copyWith(
                                          color: Clr().textcolor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  SizedBox(
                                    height: Dim().d8,
                                  ),
                                  Text(
                                    'Business Hours',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Clr().primaryColor,
                                    ),
                                  ),
                                  SizedBox(
                                    height: Dim().d4,
                                  ),
                                  if (details['shop_schedule'].isNotEmpty)
                                    checkhours == true
                                        ? Container()
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${weekList[weekList.indexWhere((e) => e['day_id'] == details['shop_schedule'][0]['day_id'])]['name']} :',
                                                style: Sty().smallText,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${DateFormat('hh:mm a').format(DateTime.parse('0000-00-00T${details['shop_schedule'][0]['time'][0]['from']}'))} - ${DateFormat('hh:mm a').format(
                                                      DateTime.parse(
                                                          '0000-00-00T${details['shop_schedule'][0]['time'][0]['to']}'),
                                                    )}',
                                                    style: Sty().smallText,
                                                  ),
                                                  if (details['shop_schedule']
                                                              [0]['time']
                                                          .length >
                                                      1)
                                                    Text(
                                                        '           ${DateFormat('hh:mm a').format(DateTime.parse('0000-00-00T${details['shop_schedule'][0]['time'][1]['from']}'))} - ${DateFormat('hh:mm a').format(
                                                      DateTime.parse(
                                                          '0000-00-00T${details['shop_schedule'][0]['time'][1]['to']}'),
                                                    )}'),
                                                ],
                                              ),
                                              InkWell(
                                                  onTap: () {
                                                    if (checkhours == true) {
                                                      setState(() {
                                                        checkhours = false;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        checkhours = true;
                                                      });
                                                    }
                                                  },
                                                  child: checkhours == true
                                                      ? Icon(Icons
                                                          .keyboard_arrow_up_rounded)
                                                      : Icon(Icons
                                                          .keyboard_arrow_down_rounded)),
                                            ],
                                          ),
                                  checkhours == true
                                      ? ListView.builder(
                                          itemCount:
                                              details['shop_schedule'].length,
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: Dim().d14),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${weekList[weekList.indexWhere((e) => e['day_id'] == details['shop_schedule'][index]['day_id'])]['name']} :',
                                                        style: Sty().smallText,
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '    ${DateFormat('hh:mm a').format(DateTime.parse('0000-00-00T${details['shop_schedule'][index]['time'][0]['from']}'))} - ${DateFormat('hh:mm a').format(
                                                              DateTime.parse(
                                                                  '0000-00-00T${details['shop_schedule'][index]['time'][0]['to']}'),
                                                            )}',
                                                            style:
                                                                Sty().smallText,
                                                          ),
                                                          if (details['shop_schedule']
                                                                          [
                                                                          index]
                                                                      ['time']
                                                                  .length >
                                                              1)
                                                            Text(
                                                                '    ${DateFormat('hh:mm a').format(DateTime.parse('0000-00-00T${details['shop_schedule'][index]['time'][1]['from']}'))} - ${DateFormat('hh:mm a').format(
                                                              DateTime.parse(
                                                                  '0000-00-00T${details['shop_schedule'][index]['time'][1]['to']}'),
                                                            )}'),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  index ==
                                                          details['shop_schedule']
                                                                  .length -
                                                              1
                                                      ? InkWell(
                                                          onTap: () {
                                                            if (checkhours ==
                                                                true) {
                                                              setState(() {
                                                                checkhours =
                                                                    false;
                                                              });
                                                            } else {
                                                              setState(() {
                                                                checkhours =
                                                                    true;
                                                              });
                                                            }
                                                          },
                                                          child: checkhours ==
                                                                  true
                                                              ? Icon(Icons
                                                                  .keyboard_arrow_up_rounded)
                                                              : Icon(Icons
                                                                  .keyboard_arrow_down_rounded))
                                                      : Container(),
                                                ],
                                              ),
                                            );
                                          },
                                        )
                                      : Container(),
                                  if (details['shop_schedule'].isNotEmpty)
                                    SizedBox(
                                      height: Dim().d8,
                                    ),
                                  Divider(
                                    color: Clr().borderColor.withOpacity(1),
                                  ),
                                  SizedBox(
                                    height: Dim().d8,
                                  ),
                                  Text('Year of Establishment',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Clr().primaryColor,
                                      )),
                                  SizedBox(
                                    height: Dim().d4,
                                  ),
                                  Text(details['year_of_establishment'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: Clr().textcolor,
                                      )),
                                  SizedBox(
                                    height: Dim().d8,
                                  ),
                                  Divider(
                                    color: Clr().borderColor.withOpacity(1),
                                  ),
                                  SizedBox(
                                    height: Dim().d8,
                                  ),
                                  Text('GSTIN',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: Clr().primaryColor,
                                      )),
                                  SizedBox(
                                    height: Dim().d4,
                                  ),
                                  if (details['gst_number'] != null)
                                    Text(details['gst_number'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Clr().textcolor,
                                        )),
                                  SizedBox(
                                    height: Dim().d8,
                                  ),
                                  if (details['website'] != null)
                                    Divider(
                                      color: Clr().borderColor.withOpacity(1),
                                    ),
                                  if (details['website'] != null)
                                    SizedBox(
                                      height: Dim().d8,
                                    ),
                                  if (details['website'] != null)
                                    Text('Website',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: Clr().primaryColor,
                                        )),
                                  if (details['website'] != null)
                                    SizedBox(
                                      height: Dim().d4,
                                    ),
                                  if (details['website'] != null)
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Text(details['website'],
                                              maxLines: 2,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                                color: Clr().textcolor,
                                              )),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            await launch(details['website']);
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                left: 20.0, right: 12.0),
                                            child: SvgPicture.asset(
                                              "assets/export.svg",
                                              width: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  SizedBox(
                                    height: Dim().d8,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Dim().d20,
                        ),
                        Row(
                          mainAxisAlignment: details['facebook_link'] != null
                              ? MainAxisAlignment.spaceBetween
                              : MainAxisAlignment.start,
                          children: [
                            if (details['facebook_link'] != null)
                              InkWell(
                                onTap: () async {
                                  await launch(details['facebook_link']);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: const Color(0xffDEEBFF),
                                      borderRadius: BorderRadius.circular(18)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/fb.svg",
                                          width: 35,
                                        ),
                                        SizedBox(
                                          width: Dim().d16,
                                        ),
                                        Text(
                                          'Facebook ',
                                          style: Sty().smallText.copyWith(
                                              color: Clr().textcolor,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            if (details['facebook_link'] != null)
                              SizedBox(
                                width: Dim().d20,
                              ),
                            if (details['youtube_link'] != null)
                              InkWell(
                                onTap: () async {
                                  await launch(details['youtube_link']);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: const Color(0xffFFE3E3),
                                      borderRadius: BorderRadius.circular(18)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/yt.svg",
                                          width: 35,
                                        ),
                                        SizedBox(
                                          width: Dim().d16,
                                        ),
                                        Text(
                                          'YouTube ',
                                          style: Sty().smallText.copyWith(
                                              color: Clr().textcolor,
                                              fontWeight: FontWeight.w600),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(
                          height: Dim().d20,
                        ),
                        if (details['similar_shops'].isNotEmpty)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Similar Businesses",
                              style: Sty().largeText.copyWith(
                                    color: Clr().textcolor,
                                  ),
                            ),
                          ),
                        if (details['similar_shops'].isNotEmpty)
                          SizedBox(
                            height: Dim().d150,
                            child: ListView.builder(
                              itemCount: details['similar_shops'].length,
                              scrollDirection: Axis.horizontal,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(
                                      top: Dim().d12,
                                      right: Dim().d20,
                                      bottom: 20.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(Dim().d12),
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                      )
                                    ],
                                    color: Clr().white,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(Dim().d12),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            STM().redirect2page(
                                              ctx,
                                              SubCatDetails(
                                                data: details['similar_shops']
                                                    [index],
                                              ),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Clr().black,
                                                width: 0.5,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(Dim().d12),
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(Dim().d12),
                                              ),
                                              child: details['similar_shops']
                                                              [index]
                                                          ['shop_logo'] ==
                                                      null
                                                  ? Image.network(
                                                      'https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg',
                                                      width: Dim().d100,
                                                      height: Dim().d100,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.network(
                                                      details['similar_shops']
                                                          [index]['shop_logo'],
                                                      width: Dim().d100,
                                                      height: Dim().d100,
                                                      fit: BoxFit.cover,
                                                      loadingBuilder: (context,
                                                          child,
                                                          loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) {
                                                          // Image is done loading
                                                          return child;
                                                        } else {
                                                          // Show a loading indicator
                                                          return CircularProgressIndicator(
                                                            color: Clr()
                                                                .primaryColor,
                                                          );
                                                        }
                                                      },
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return Image.network(
                                                          'https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg',
                                                          height: Dim().d36,
                                                          fit: BoxFit.cover,
                                                        );
                                                      },
                                                    ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: Dim().d12,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 200.0,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      '${details['similar_shops'][index]['shop_name']}',
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Sty()
                                                          .smallText
                                                          .copyWith(
                                                              color: Clr()
                                                                  .textcolor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                  ),
                                                  details['similar_shops']
                                                                  [index][
                                                              'is_favourite'] ==
                                                          true
                                                      ? SvgPicture.asset(
                                                          "assets/like.svg")
                                                      : SvgPicture.asset(
                                                          "assets/unlike.svg"),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              // mainAxisAlignment:
                                              //     MainAxisAlignment
                                              //         .spaceBetween,
                                              children: [
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      right: Dim().d12),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: Dim().d12,
                                                      vertical: Dim().d4),
                                                  decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xffFFB400),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              55)),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        details['similar_shops']
                                                                    [index]
                                                                ['rating']
                                                            .toString(),
                                                        style: Sty()
                                                            .microText
                                                            .copyWith(
                                                                color:
                                                                    Clr().white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800),
                                                      ),
                                                      SizedBox(
                                                        width: Dim().d4,
                                                      ),
                                                      Icon(
                                                        Icons.star,
                                                        size: 14,
                                                        color: Clr().white,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () {
                                                    STM().redirect2page(
                                                      ctx,
                                                      reviewdetailsPage(
                                                        id: details[
                                                                'similar_shops']
                                                            [index]['id'],
                                                      ),
                                                    );
                                                  },
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        '${STM().formatAmount(details['similar_shops'][index]['total_review'])} Reviews',
                                                        style: Sty()
                                                            .microText
                                                            .copyWith(
                                                                fontSize: 12.0,
                                                                color: Color(
                                                                    0xff464646),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                      Text(
                                                        '-----------',
                                                        style: Sty()
                                                            .microText
                                                            .copyWith(
                                                                color: Color(
                                                                    0xff464646),
                                                                height: 0.2,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                details['similar_shops'][index]
                                                            ['is_verified'] ==
                                                        true
                                                    ? Container(
                                                        margin: EdgeInsets.only(
                                                            left: Dim().d12),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    Dim().d12,
                                                                vertical:
                                                                    Dim().d4),
                                                        decoration: BoxDecoration(
                                                            color: const Color(
                                                                0xff2AC0D4),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        55)),
                                                        child: Center(
                                                          child: Wrap(
                                                            crossAxisAlignment:
                                                                WrapCrossAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Icons.verified,
                                                                size: 14,
                                                                color:
                                                                    Clr().white,
                                                              ),
                                                              SizedBox(
                                                                width: Dim().d4,
                                                              ),
                                                              Text(
                                                                'Verified',
                                                                style: Sty().microText.copyWith(
                                                                    color: Clr()
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w800),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        width: 100.0,
                                                      ),
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }

  ///SliderLayout
  Widget sliderLayout(ctx) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        viewportFraction: 1,
        height: 300,
        initialPage: 0,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        onPageChanged: (index, reason) {
          setState(() {
            selectedSlider = index;
          });
        },
      ),
      items: (details['shop_images'] as List).map((url) {
        return Builder(
          builder: (BuildContext context) {
            return Image.network(
              url['image'],
              fit: BoxFit.fitWidth,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  // Image is done loading
                  return child;
                } else {
                  // Show a loading indicator
                  return CircularProgressIndicator(
                    color: Clr().primaryColor,
                  );
                }
              },
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  'https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg',
                  height: Dim().d36,
                  fit: BoxFit.cover,
                );
              },
            );
          },
        );
      }).toList(),
    );
  }

  ///Offer Layout Code
  Widget offerLayout(ctx, v) {
    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Clr().shimmerColor.withOpacity(0.1),
              blurRadius: 12,
              spreadRadius: 1)
        ],
      ),
      child: Card(
        color: Clr().white,
        elevation: 0,
        shape: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(18)),
            borderSide: BorderSide(
              color: Clr().borderColor,
            )),
        child: Padding(
          padding: EdgeInsets.all(Dim().d12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/gift.svg"),
              SizedBox(
                width: Dim().d12,
              ),
              Text(
                v['offer'],
                style: Sty().smallText.copyWith(
                    color: Clr().textcolor, fontWeight: FontWeight.w600),
              )
            ],
          ),
        ),
      ),
    );
  }

  ///Similar Business Layout
  Widget similarLayout(ctx, index) {
    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Clr().shimmerColor.withOpacity(0.1),
              blurRadius: 12,
              spreadRadius: 1)
        ],
      ),
      child: Card(
        color: Clr().white,
        elevation: 0,
        shape: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(18)),
            borderSide: BorderSide(
              color: Clr().borderColor,
            )),
        child: Padding(
          padding: EdgeInsets.all(Dim().d12),
          child: Column(
            children: [
              SizedBox(
                height: Dim().d4,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      STM().redirect2page(ctx, SubCatDetails());
                    },
                    child: Image.asset(
                      "assets/dummy.png",
                      width: 80,
                    ),
                  ),
                  SizedBox(
                    width: Dim().d12,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Text(
                              'Jiva Ayurveda Clinic and Panchkarma Center',
                              style: Sty().smallText.copyWith(
                                  color: Clr().textcolor,
                                  fontWeight: FontWeight.w600),
                            )),
                            SvgPicture.asset("assets/like.svg")
                          ],
                        ),
                        SizedBox(
                          height: Dim().d12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xffFFB400),
                                  borderRadius: BorderRadius.circular(55)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4),
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Text(
                                      '4.6',
                                      style: Sty().microText.copyWith(
                                          color: Clr().white,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    SizedBox(
                                      width: Dim().d4,
                                    ),
                                    Icon(
                                      Icons.star,
                                      size: 14,
                                      color: Clr().white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '1.4k Reviews',
                                  style: Sty().microText.copyWith(
                                      color: Color(0xff464646),
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  '-----------------',
                                  style: Sty().microText.copyWith(
                                      color: Color(0xff464646),
                                      height: 0.2,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xff2AC0D4),
                                  borderRadius: BorderRadius.circular(55)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.verified,
                                      size: 14,
                                      color: Clr().white,
                                    ),
                                    SizedBox(
                                      width: Dim().d4,
                                    ),
                                    Text(
                                      'Verified',
                                      style: Sty().microText.copyWith(
                                          color: Clr().white,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: Dim().d16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 35,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(55),
                                side: BorderSide(
                                  color: Clr().primaryColor,
                                )),
                            padding: EdgeInsets.zero,
                            elevation: 0,
                            backgroundColor: Clr().white,
                          ),
                          onPressed: () {
                            // STM().redirect2page(ctx, Home());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.phone,
                                size: 16,
                                color: Clr().primaryColor,
                              ),
                              SizedBox(
                                width: Dim().d4,
                              ),
                              Text(
                                'Direction',
                                style: Sty()
                                    .microText
                                    .copyWith(color: Clr().primaryColor),
                              ),
                            ],
                          )),
                    ),
                  ),
                  SizedBox(
                    width: Dim().d12,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 35,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              elevation: 0,
                              backgroundColor: Clr().green),
                          onPressed: () {
                            // STM().redirect2page(ctx, Home());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset("assets/whatsapp.svg"),
                              SizedBox(
                                width: Dim().d6,
                              ),
                              Text(
                                'Chat',
                                style: Sty()
                                    .microText
                                    .copyWith(color: Clr().white),
                              ),
                            ],
                          )),
                    ),
                  ),
                  SizedBox(
                    width: Dim().d12,
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 35,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              elevation: 0,
                              backgroundColor: Clr().primaryColor),
                          onPressed: () {
                            // STM().redirect2page(ctx, Home());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.phone,
                                size: 16,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: Dim().d4,
                              ),
                              Text(
                                'Call Now',
                                style: Sty()
                                    .microText
                                    .copyWith(color: Clr().white),
                              ),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Dim().d4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
