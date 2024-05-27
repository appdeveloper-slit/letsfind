// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/custom_switch.dart';
import '../../data/static_method.dart';
import '../../values/colors.dart';
import '../../values/dimens.dart';
import '../../values/strings.dart';
import '../../values/styles.dart';
import '../shop_listing.dart';
import 'contact_details.dart';

// Map<int, List<BusinessHour>> businessHours = {
//   1: [BusinessHour(isOpen: true, startTime: TimeOfDay(hour: 12, minute: 13), endTime: TimeOfDay(hour: 17, minute: 18))],
//   2: [BusinessHour(isOpen: true, startTime: TimeOfDay(hour: 9, minute: 0), endTime: TimeOfDay(hour: 17, minute: 0))],
//   3: [BusinessHour(isOpen: true, startTime: TimeOfDay(hour: 9, minute: 0), endTime: TimeOfDay(hour: 17, minute: 0))],
//   4: [BusinessHour(isOpen: true, startTime: TimeOfDay(hour: 9, minute: 0), endTime: TimeOfDay(hour: 17, minute: 0))],
//   5: [BusinessHour(isOpen: true, startTime: TimeOfDay(hour: 9, minute: 0), endTime: TimeOfDay(hour: 17, minute: 0))],
// };

Map<int, List<BusinessHour>> businessHours = {};

class BusinessHour {
  bool isOpen;
  TimeOfDay startTime;
  TimeOfDay endTime;

  BusinessHour({
    required this.isOpen,
    required this.startTime,
    required this.endTime,
  });

  @override
  String toString() {
    return 'BusinessHour{isOpen: $isOpen, startTime: $startTime, endTime: $endTime}';
  }
}

class SelectTiming extends StatefulWidget {
  final data;
  const SelectTiming({super.key, this.data});

  @override
  _SelectTimingState createState() => _SelectTimingState();
}

class _SelectTimingState extends State<SelectTiming> {
  late BuildContext ctx;
  List<Map<String, String>> formattedList = [];

  var formattedBusinessHours;
  String? sShopID, sToken;

  List<Map<String, dynamic>> scheduleList = [
    {
      'day_id': 1,
      'time': [
        {
          "from": '${DateFormat('hh:mm a').format(DateTime.now())}',
          "to": '${DateFormat('hh:mm a').format(DateTime.now())}'
        },
        {
          "from": '${DateFormat('hh:mm a').format(DateTime.now())}',
          "to": '${DateFormat('hh:mm a').format(DateTime.now())}'
        }
      ],
      "show": false,
      "name": "Sunday"
    },
    {
      'day_id': 2,
      'time': [
        {
          "from": '${DateFormat('hh:mm a').format(DateTime.now())}',
          "to": '${DateFormat('hh:mm a').format(DateTime.now())}'
        },
        {
          "from": '${DateFormat('hh:mm a').format(DateTime.now())}',
          "to": '${DateFormat('hh:mm a').format(DateTime.now())}'
        }
      ],
      "show": false,
      "name": "Monday"
    },
    {
      'day_id': 3,
      'time': [
        {
          "from": '${DateFormat('hh:mm a').format(DateTime.now())}',
          "to": '${DateFormat('hh:mm a').format(DateTime.now())}'
        },
        {
          "from": '${DateFormat('hh:mm a').format(DateTime.now())}',
          "to": '${DateFormat('hh:mm a').format(DateTime.now())}'
        }
      ],
      "show": false,
      "name": "Tuesday"
    },
    {
      'day_id': 4,
      'time': [
        {
          "from": '${DateFormat('hh:mm a').format(DateTime.now())}',
          "to": '${DateFormat('hh:mm a').format(DateTime.now())}'
        },
        {
          "from": '${DateFormat('hh:mm a').format(DateTime.now())}',
          "to": '${DateFormat('hh:mm a').format(DateTime.now())}'
        }
      ],
      "show": false,
      "name": "Wednesday"
    },
    {
      'day_id': 5,
      'time': [
        {
          "from": '${DateFormat('hh:mm a').format(DateTime.now())}',
          "to": '${DateFormat('hh:mm a').format(DateTime.now())}'
        },
        {
          "from": '${DateFormat('hh:mm a').format(DateTime.now())}',
          "to": '${DateFormat('hh:mm a').format(DateTime.now())}'
        }
      ],
      "show": false,
      "name": "Thursday"
    },
    {
      'day_id': 6,
      'time': [
        {
          "from": '${DateFormat('hh:mm a').format(DateTime.now())}',
          "to": '${DateFormat('hh:mm a').format(DateTime.now())}'
        },
        {
          "from": '${DateFormat('hh:mm a').format(DateTime.now())}',
          "to": '${DateFormat('hh:mm a').format(DateTime.now())}'
        }
      ],
      "show": false,
      "name": "Friday"
    },
    {
      'day_id': 7,
      'time': [
        {
          "from": '${DateFormat('hh:mm a').format(DateTime.now())}',
          "to": '${DateFormat('hh:mm a').format(DateTime.now())}'
        },
        {
          "from": '${DateFormat('hh:mm a').format(DateTime.now())}',
          "to": '${DateFormat('hh:mm a').format(DateTime.now())}'
        }
      ],
      "show": false,
      "name": "Saturday"
    },
  ];

  getDays(val) {
    var data;
    switch (val) {
      case 1:
        data = 'Sunday';
        break;
      case 2:
        data = 'Monday';
        break;
      case 3:
        data = 'Tuesday';
        break;
      case 4:
        data = 'Wednesday';
        break;
      case 5:
        data = 'Thursday';
        break;
      case 6:
        data = 'Friday';
        break;
      case 7:
        data = 'Saturday';
        break;
      default:
    }
    return data;
  }

  getsessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sShopID = sp.getString("shop_id") ?? "";
    sToken = sp.getString("token") ?? "";
    print("Shop ID :: $sShopID");
    if (widget.data != null) {
      for (int a = 0; a < widget.data['shop_schedule'].length; a++) {
        setState(() {
          int pos = scheduleList.indexWhere((e) =>
              e['day_id'].toString() ==
              widget.data['shop_schedule'][a]['day_id'].toString());
          scheduleList.removeAt(pos);
          scheduleList.insert(pos, {
            'day_id': widget.data['shop_schedule'][a]['day_id'],
            'time': [
              {
                "from": widget.data['shop_schedule'][a]['time'][0]['from'],
                "to": widget.data['shop_schedule'][a]['time'][0]['to'],
              },
              if (widget.data['shop_schedule'][a]['time'].length > 1)
                {
                  "from": widget.data['shop_schedule'][a]['time'][1]['from'],
                  "to": widget.data['shop_schedule'][a]['time'][1]['to'],
                }
            ],
            "show": true,
            "name": getDays(
                int.parse(widget.data['shop_schedule'][a]['day_id'].toString()))
          });
        });
      }
    }
  }

  @override
  void initState() {
    getsessionData();
    super.initState();
  }

  List<Map<String, dynamic>> convertBusinessHours(
      Map<int, List<BusinessHour>> businessHours) {
    return businessHours.entries.map((entry) {
      final day = entry.key.toString();
      final timeRanges = entry.value.map((businessHour) {
        return {
          "from": formatTimeOfDay(businessHour.startTime),
          "to": formatTimeOfDay(businessHour.endTime),
        };
      }).toList();
      return {"day_id": day, "time": timeRanges};
    }).toList();
  }

  String formatTimeOfDay(TimeOfDay time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;

    print("Business Hours :: $businessHours");

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
                  text: '4 ',
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
          padding:
              EdgeInsets.symmetric(vertical: Dim().d16, horizontal: Dim().d24),
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
                            'Select Timings',
                            style: Sty().largeText.copyWith(
                                color: Clr().primaryColor,
                                fontSize: 38,
                                fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            'Let people know when you’re available',
                            textAlign: TextAlign.center,
                            style: Sty().mediumText.copyWith(
                                  color: Clr().textcolor,
                                  fontFamily: 'SP',
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          SizedBox(
                            height: Dim().d32,
                          ),
                          ListView.builder(
                            itemCount: scheduleList.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: Dim().d28),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            scheduleList[index]['name'],
                                            style: Sty().mediumText.copyWith(
                                                  color: Clr().primaryColor,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          scheduleList[index]['show'] == true
                                              ? ListView.builder(
                                                  itemCount: scheduleList[index]
                                                          ['time']
                                                      .length,
                                                  shrinkWrap: true,
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  itemBuilder:
                                                      (context, index2) {
                                                    return Padding(
                                                      padding: EdgeInsets.only(
                                                          bottom: Dim().d12),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              InkWell(
                                                                onTap:
                                                                    () async {
                                                                  TimeOfDay?
                                                                      picked =
                                                                      await showTimePicker(
                                                                    context:
                                                                        context,
                                                                    initialTime:
                                                                        TimeOfDay
                                                                            .now(),
                                                                  );
                                                                  if (picked !=
                                                                      null) {
                                                                    setState(
                                                                        () {
                                                                      print(picked
                                                                          .toString()
                                                                          .replaceAll(
                                                                              'TimeOfDay(',
                                                                              '')
                                                                          .replaceAll(
                                                                              ')',
                                                                              ''));
                                                                      print(picked
                                                                          .minute);
                                                                      scheduleList[index]['time'][index2]['from'] = picked
                                                                          .toString()
                                                                          .replaceAll(
                                                                              'TimeOfDay(',
                                                                              '')
                                                                          .replaceAll(
                                                                              ')',
                                                                              '');
                                                                    });
                                                                  } else {
                                                                    setState(
                                                                        () {
                                                                      scheduleList[index]['time'][index2]
                                                                              [
                                                                              'from'] =
                                                                          '${DateFormat('hh:mm a').format(DateTime.now())}';
                                                                    });
                                                                  }
                                                                },
                                                                child:
                                                                    Container(
                                                                  height:
                                                                      Dim().d20,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border:
                                                                        Border(
                                                                      bottom:
                                                                          BorderSide(
                                                                        color: Clr()
                                                                            .black,
                                                                        // You can set the border color here
                                                                        width:
                                                                            1.0, // You can set the border width here
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  child: Text(
                                                                    scheduleList[index]['time']
                                                                            [
                                                                            index2]
                                                                        [
                                                                        'from'],
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        8.0),
                                                                child: Icon(
                                                                    CupertinoIcons
                                                                        .equal,
                                                                    size: 10),
                                                              ),
                                                              InkWell(
                                                                onTap:
                                                                    () async {
                                                                  TimeOfDay?
                                                                      picked =
                                                                      await showTimePicker(
                                                                    context:
                                                                        context,
                                                                    initialTime:
                                                                        TimeOfDay
                                                                            .now(),
                                                                  );
                                                                  if (picked !=
                                                                      null) {
                                                                    setState(
                                                                        () {
                                                                      print(picked
                                                                          .format(
                                                                              ctx));
                                                                      scheduleList[index]['time'][index2]['to'] = picked
                                                                          .toString()
                                                                          .replaceAll(
                                                                              'TimeOfDay(',
                                                                              '')
                                                                          .replaceAll(
                                                                              ')',
                                                                              '');
                                                                    });
                                                                  } else {
                                                                    scheduleList[index]['time'][index2]
                                                                            [
                                                                            'to'] =
                                                                        '${DateFormat('hh:mm a').format(DateTime.now())}';
                                                                  }
                                                                },
                                                                child:
                                                                    Container(
                                                                  height:
                                                                      Dim().d20,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    border:
                                                                        Border(
                                                                      bottom:
                                                                          BorderSide(
                                                                        color: Clr()
                                                                            .black,
                                                                        // You can set the border color here
                                                                        width:
                                                                            1.0, // You can set the border width here
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  child: Text(
                                                                    scheduleList[index]
                                                                            [
                                                                            'time']
                                                                        [
                                                                        index2]['to'],
                                                                  ),
                                                                ),
                                                              ),
                                                              InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      scheduleList[index]
                                                                              [
                                                                              'time']
                                                                          .removeAt(
                                                                              index2);
                                                                    });
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            4.0),
                                                                    child: Icon(
                                                                        CupertinoIcons
                                                                            .multiply,
                                                                        color: Clr()
                                                                            .primaryColor,
                                                                        size:
                                                                            16),
                                                                  ))
                                                            ],
                                                          ),
                                                          if (scheduleList[
                                                                          index]
                                                                      ['time']
                                                                  .length ==
                                                              1)
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: Dim()
                                                                          .d8),
                                                              child: InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    scheduleList[index]
                                                                            [
                                                                            'time']
                                                                        .add({
                                                                      "from":
                                                                          '${DateFormat('hh:mm a').format(DateTime.now())}',
                                                                      "to":
                                                                          '${DateFormat('hh:mm a').format(DateTime.now())}'
                                                                    });
                                                                  });
                                                                },
                                                                child: Text(
                                                                  '+ Add a set hours',
                                                                  style: Sty()
                                                                      .smallText
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.orange),
                                                                ),
                                                              ),
                                                            )
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: Dim().d24,
                                      width: Dim().d48,
                                      child: CustomSwitch(
                                        value: scheduleList[index]['show'],
                                        onChanged: (v) {
                                          if (scheduleList[index]['show'] ==
                                              false) {
                                            setState(() {
                                              scheduleList[index]['show'] =
                                                  true;
                                            });
                                          } else {
                                            setState(() {
                                              scheduleList[index]['show'] =
                                                  false;
                                            });
                                          }
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: Dim().d8,
                          ),
                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.stretch,
                          //   children: [
                          //     for (int day = DateTime.monday;
                          //         day <= DateTime.sunday;
                          //         day++)
                          //       Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           Row(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.spaceBetween,
                          //             children: [
                          //               Padding(
                          //                 padding: EdgeInsets.symmetric(
                          //                     vertical: 8.0),
                          //                 child: Text('${dayToText(day)}',
                          //                     style: Sty().mediumText.copyWith(
                          //                         color: Clr().primaryColor,
                          //                         fontWeight: FontWeight.w500,
                          //                         fontSize: 18)),
                          //               ),
                          //               CustomSwitch(
                          //                 value:
                          //                     businessHours[day]?.isNotEmpty ??
                          //                         false,
                          //                 onChanged: (value) {
                          //                   setState(
                          //                     () {
                          //                       businessHours[day] ??= [];
                          //                       if (value &&
                          //                           businessHours[day]!.length <
                          //                               2) {
                          //                         businessHours[day]!.add(
                          //                           BusinessHour(
                          //                             isOpen: true,
                          //                             startTime:
                          //                                 TimeOfDay.now(),
                          //                             endTime: TimeOfDay.now(),
                          //                           ),
                          //                         );
                          //                       } else if (!value) {
                          //                         businessHours[day]!.clear();
                          //                       }
                          //                     },
                          //                   );
                          //                 },
                          //                 thumbSize: 24.0,
                          //               ),
                          //               // Theme(
                          //               //   data: ThemeData(
                          //               //     cupertinoOverrideTheme: CupertinoThemeData(
                          //               //       primaryColor: Colors.red,
                          //               //         // primarySize: 30.0, // Change this value to adjust the thumb size
                          //               //     ),
                          //               //   ),
                          //               //   child: CupertinoSwitch(
                          //               //
                          //               //     activeColor: Clr().primaryColor,
                          //               //
                          //               //     value: businessHours[day]?.isNotEmpty ?? false,
                          //               //     onChanged: (value) {
                          //               //       setState(() {
                          //               //         businessHours[day] ??= [];
                          //               //         if (value && businessHours[day]!.length < 2) {
                          //               //           businessHours[day]!.add(
                          //               //             BusinessHour(
                          //               //               isOpen: true,
                          //               //               startTime: TimeOfDay.now(),
                          //               //               endTime: TimeOfDay.now(),
                          //               //             ),
                          //               //           );
                          //               //         } else if (!value) {
                          //               //           businessHours[day]!.clear();
                          //               //         }
                          //               //       });
                          //               //     },
                          //               //   ),
                          //               // ),
                          //             ],
                          //           ),
                          //           if (businessHours[day]?.isNotEmpty ?? false)
                          //             for (int index = 0;
                          //                 index < businessHours[day]!.length;
                          //                 index++)
                          //               BusinessHourWidget(
                          //                 businessHour:
                          //                     businessHours[day]![index],
                          //                 onRemove: () {
                          //                   setState(() {
                          //                     businessHours[day]!
                          //                         .removeAt(index);
                          //                   });
                          //                 },
                          //                 onEditTime: (bool isStartTime) async {
                          //                   TimeOfDay? selectedTime =
                          //                       await showTimePicker(
                          //                     context: context,
                          //                     initialTime: isStartTime
                          //                         ? businessHours[day]![index]
                          //                             .startTime
                          //                         : businessHours[day]![index]
                          //                             .endTime,
                          //                   );
                          //                   if (selectedTime != null) {
                          //                     setState(() {
                          //                       if (isStartTime) {
                          //                         businessHours[day]![index]
                          //                             .startTime = selectedTime;
                          //                       } else {
                          //                         businessHours[day]![index]
                          //                             .endTime = selectedTime;
                          //                       }
                          //                     });
                          //                   }
                          //                 },
                          //               ),
                          //           businessHours[day]?.length == 2
                          //               ? Container()
                          //               : businessHours[day]?.isEmpty ??
                          //                       false ||
                          //                           businessHours[day] == null
                          //                   ? Container()
                          //                   : Container(
                          //                       child: TextButton(
                          //                         style: TextButton.styleFrom(
                          //                           padding: EdgeInsets.zero,
                          //                           minimumSize: Size(50, 30),
                          //                           tapTargetSize:
                          //                               MaterialTapTargetSize
                          //                                   .shrinkWrap,
                          //                         ),
                          //                         onPressed: () {
                          //                           setState(() {
                          //                             businessHours[day] ??= [];
                          //                             businessHours[day]!.add(
                          //                               BusinessHour(
                          //                                 isOpen: true,
                          //                                 startTime:
                          //                                     TimeOfDay.now(),
                          //                                 endTime:
                          //                                     TimeOfDay.now(),
                          //                               ),
                          //                             );
                          //                           });
                          //                         },
                          //                         child: Text(
                          //                           '+ Add a set of hours',
                          //                           style: Sty()
                          //                               .mediumText
                          //                               .copyWith(
                          //                                   color:
                          //                                       Clr().secondary,
                          //                                   fontWeight:
                          //                                       FontWeight.w500,
                          //                                   fontSize: 14),
                          //                         ),
                          //                       ),
                          //                     ),
                          //           SizedBox(height: 12),
                          //         ],
                          //       ),
                          //     // SizedBox(
                          //     //   width: double.infinity,
                          //     //   height: Dim().d48,
                          //     //   child: ElevatedButton(
                          //     //       onPressed: () {
                          //     //         // if (formKey.currentState!.validate()) {
                          //     //         // STM().redirect2page(
                          //     //         //     context,
                          //     //         //     OtpVerification(
                          //     //         //       mobile: mobileCtrl.text,
                          //     //         //     ));
                          //     //         // SendOtp();
                          //     //         // }
                          //     //         STM().checkInternet(context, widget).then((value) {
                          //     //           if (value) {
                          //     //             print('kkkk$businessHours');
                          //     //             // convertBusinessHours(businessHours);
                          //     //             List<Map<String, dynamic>> formattedBusinessHours = convertBusinessHours(businessHours);
                          //     //             print(formattedBusinessHours);
                          //     //
                          //     //             Navigator.pop(context, {
                          //     //               'time': formattedBusinessHours,
                          //     //             });
                          //     //           }
                          //     //         });
                          //     //       },
                          //     //       style: ElevatedButton.styleFrom(
                          //     //           backgroundColor: Clr().primaryColor,
                          //     //           elevation: 0,
                          //     //           shape: RoundedRectangleBorder(
                          //     //               borderRadius: BorderRadius.circular(8))),
                          //     //       child: Text(
                          //     //         'Submit',
                          //     //         style: TextStyle(
                          //     //           fontWeight: FontWeight.w400,
                          //     //           fontSize: 16,
                          //     //           color: Clr().white
                          //     //         ),
                          //     //       )),
                          //     // ),
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: Dim().d60,
              ),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0, backgroundColor: Clr().primaryColor),
                    onPressed: () {
                      // if (formKey.currentState!.validate()) {
                      // STM().redirect2page(
                      //     context,
                      //     OtpVerification(
                      //       mobile: mobileCtrl.text,
                      //     ));
                      // SendOtp();
                      // }
                      STM().checkInternet(context, widget).then((value) {
                        if (value) {
                          print('kkkk$businessHours');
                          // convertBusinessHours(businessHours);
                          formattedBusinessHours =
                              convertBusinessHours(businessHours);
                          print(formattedBusinessHours);
                          submitStep7();

                          // Navigator.pop(context, {
                          //   'time': formattedBusinessHours,
                          // });
                        }
                      });
                    },
                    child: Text(
                      'Submit',
                      style: Sty().mediumText.copyWith(color: Clr().white),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///Submit Step 7
  void submitStep7() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> finalList = [];
    for (int a = 0; a < scheduleList.length; a++) {
      if (scheduleList[a]['show'] == true) {
        setState(() {
          finalList.add({
            "day_id": scheduleList[a]['day_id'],
            "time": scheduleList[a]['time']
          });
        });
      }
    }
    var body = {
      "shop_id": widget.data != null ? widget.data['id'] : sShopID,
      "schedules": finalList,
    };
    print(body);
    var result = await STM().allApi(
        apiname: 'step7',
        ctx: ctx,
        body: body,
        load: true,
        loadtitle: 'Processing',
        type: 'post',
        token: sp.getString('token'));
    var success = result['success'];
    var message = result['message'];
    if (success) {
      if (widget.data != null) {
        STM().successDialogWithReplace(ctx, result['message'], ShopListing());
      } else {
        setState(
          () {
            STM().displayToast(message);
            STM().redirect2page(
              context,
              ContactDetails(),
            );
          },
        );
      }
    } else {
      STM().errorDialog(context, message);
    }
  }

  String dayToText(int day) {
    switch ((day + 6) % 7) {
      case 0:
        return 'Sunday';
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      default:
        return '';
    }
  }
}

class BusinessHourWidget extends StatefulWidget {
  final BusinessHour businessHour;
  final VoidCallback onRemove;
  final Function(bool isStartTime) onEditTime;

  BusinessHourWidget({
    required this.businessHour,
    required this.onRemove,
    required this.onEditTime,
  });

  @override
  _BusinessHourWidgetState createState() => _BusinessHourWidgetState();
}

class _BusinessHourWidgetState extends State<BusinessHourWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.businessHour.isOpen)
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    widget.onEditTime(true);
                  },
                  child: Container(
                    height: Dim().d20,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Clr().black,
                          // You can set the border color here
                          width: 1.0, // You can set the border width here
                        ),
                      ),
                    ),
                    child: Text(
                      '${widget.businessHour.startTime.format(context)}',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Icon(CupertinoIcons.equal, size: 10),
                ),
                InkWell(
                  onTap: () {
                    widget.onEditTime(false);
                  },
                  child: Container(
                    height: Dim().d20,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Clr().black,
                          // You can set the border color here
                          width: 1.0, // You can set the border width here
                        ),
                      ),
                    ),
                    child:
                        Text('${widget.businessHour.endTime.format(context)}'),
                  ),
                ),
                InkWell(
                    onTap: widget.onRemove,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(CupertinoIcons.multiply,
                          color: Clr().primaryColor, size: 16),
                    ))
              ],
            ),

          // SizedBox(height: 10),
        ],
      ),
    );
  }
}
