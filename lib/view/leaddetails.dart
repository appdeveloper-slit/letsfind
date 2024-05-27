// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:letsfind/bottomnavigation/bottomnavigationPage.dart';
import 'package:letsfind/values/styles.dart';

import '../data/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';

class leadDetailsPage extends StatefulWidget {
  final data, type;
  const leadDetailsPage({super.key, this.data, this.type});

  @override
  State<leadDetailsPage> createState() => _leadDetailsPageState();
}

class _leadDetailsPageState extends State<leadDetailsPage> {
  late BuildContext ctx;
  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: () async {
        STM().back2Previous(ctx);
        return false;
      },
      child: Scaffold(
        backgroundColor: Clr().background,
        bottomNavigationBar: bottomBarLayout(ctx, 0),
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
                  padding: EdgeInsets.all(Dim().d8),
                  child: SvgPicture.asset(
                    "assets/back.svg",
                    color: Clr().primaryColor,
                  ),
                ),
              ),
            ),
          ),
          title: Text(
            'My Leads',
            style: Sty().mediumText,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  padding: EdgeInsets.all(Dim().d12),
                  decoration: BoxDecoration(
                    color: Clr().white,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 5,
                        spreadRadius: 3,
                        color: Colors.black12,
                      )
                    ],
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dim().d12),
                    ),
                  ),
                  child: ListView.builder(
                    itemCount: widget.data.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var v = widget.data[index];
                      return Column(
                        children: [
                          SizedBox(
                            height: Dim().d16,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Lead Name',
                                      style: Sty().microText.copyWith(
                                          color: Clr().hintColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: Dim().d4,
                                    ),
                                    Text(
                                      // 'Dilip Khanna',
                                      widget.type == 'estate'
                                          ? v['lead_name']
                                          : v['user']['name'].toString(),
                                      style: Sty().smallText.copyWith(
                                          color: Clr().textcolor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Enquiry Date',
                                      style: Sty().microText.copyWith(
                                          color: Clr().hintColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: Dim().d4,
                                    ),
                                    Text(
                                      // '27th March 2024'
                                      widget.type == 'estate'
                                          ? v['enquiry_date']
                                          : DateFormat('dd MMMM yyyy').format(
                                              DateTime.parse(v['user']
                                                      ['updated_at']
                                                  .toString()),
                                            ),
                                      style: Sty().smallText.copyWith(
                                            color: Clr().textcolor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Dim().d20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Mobile Number',
                                    style: Sty().microText.copyWith(
                                        color: Clr().hintColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: Dim().d4,
                                  ),
                                  Text(
                                    widget.type == 'estate'
                                        ? v['mobile']
                                        : "+91 ${v['user']['mobile'].toString()}",
                                    style: Sty().smallText.copyWith(
                                        color: Clr().textcolor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: ElevatedButton(
                                  onPressed: () {
                                    STM().openDialer(
                                      widget.type == 'estate'
                                          ? v['mobile']
                                          : "+91 ${v['user']['mobile'].toString()}",
                                    );
                                  },
                                  child: Icon(
                                    Icons.phone,
                                    color: Clr().white,
                                    size: 18.0,
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(55),
                                      ),
                                      backgroundColor: Clr().primaryColor),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: Dim().d16,
                          ),
                          widget.data.length > 1
                              ? Divider(
                                  color: Clr().hintColor,
                                )
                              : Container(),
                        ],
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
