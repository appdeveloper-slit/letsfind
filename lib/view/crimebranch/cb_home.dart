// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:letsfind/values/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/static_method.dart';
import '../../values/colors.dart';
import '../../values/dimens.dart';
import '../../values/strings.dart';
import '../../values/styles.dart';
import '../imageview.dart';
import 'cb_sign_in.dart';
import 'informants_list.dart';

class CBHome extends StatefulWidget {
  const CBHome({Key? key}) : super(key: key);

  @override
  State<CBHome> createState() => _CBHomeState();
}

class _CBHomeState extends State<CBHome> {
  late BuildContext ctx;

  String? sToken;
  List<dynamic> caseList = [];

  getsessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      sToken = sp.getString("token") ?? "";
      print("Token :: ${sToken}");
      STM().checkInternet(context, widget).then((value) {
        if (value) {
          crimeCases();
        }
      });
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

    return Scaffold(
      backgroundColor: Clr().background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        forceMaterialTransparency: true,
        backgroundColor: Clr().background,
        title: Image.asset(
          "assets/home_logo.png",
          width: 100,
        ),
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {
              setState(() async {
                SharedPreferences sp = await SharedPreferences.getInstance();
                sp.setBool('login', false);
                sp.clear();
                STM().finishAffinity(ctx, const CBSignIn());
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(55),
                  color: Clr().primaryLightColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset("assets/log_out.svg"),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (caseList.isEmpty)
              SizedBox(
                height: MediaQuery.of(ctx).size.height / 1.3,
                child: Center(
                  child: Text(
                    'No Cases Found',
                    style: Sty().mediumText,
                  ),
                ),
              ),
            ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: Dim().d20,
                );
              },
              shrinkWrap: true,
              padding: EdgeInsets.all(Dim().d16),
              physics: const BouncingScrollPhysics(),
              itemCount: caseList.length,
              itemBuilder: (context, index) {
                return cardLayout(ctx, index, caseList);
              },
            ),
          ],
        ),
      ),
    );
  }

  ///Crime Branch List Layout
  Widget cardLayout(ctx, index, list) {
    var v = caseList[index];

    return Container(
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
        padding: EdgeInsets.all(Dim().d16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Case ID',
                      style: Sty().microText.copyWith(
                          color: Clr().hintColor, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: Dim().d4,
                    ),
                    Text(
                      // '894239',
                      v['case_id'].toString(),
                      style: Sty().smallText.copyWith(
                          color: Clr().textcolor, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Date Posted',
                      style: Sty().microText.copyWith(
                          color: Clr().hintColor, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: Dim().d4,
                    ),
                    Text(
                      // '21st March 2024',
                      v['created_at'].toString(),
                      style: Sty().smallText.copyWith(
                          color: Clr().textcolor, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: Dim().d12,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Title',
                      style: Sty().microText.copyWith(
                          color: Clr().hintColor, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: Dim().d4,
                    ),
                    Text(
                      // 'Vijay Malya is Missing',
                      v['title'].toString(),
                      style: Sty().smallText.copyWith(
                          color: Clr().textcolor, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: Dim().d20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Report Overview',
                        style: Sty().microText.copyWith(
                            color: Clr().hintColor,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: Dim().d4,
                      ),
                      Text(
                        // 'Lorem ipsum dolor sit amet consectetur. Cum at in varius suscipit ac vestibulum velit. Lorem eget interdum eleifend dolor fames.',
                        v['report_overview'].toString(),
                        style: Sty().smallText.copyWith(
                              color: Clr().textcolor,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      SizedBox(
                        height: Dim().d20,
                      ),
                      Text(
                        'Images',
                        style: Sty().microText.copyWith(
                            color: Clr().hintColor,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: Dim().d12,
                      ),
                      SizedBox(
                        height: 64,
                        child: ListView.separated(
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              width: Dim().d12,
                            );
                          },
                          itemCount: v['image'].length,
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                List<String> imagePaths = caseList
                                    .map((e) => e['image'][index]['image_path']
                                        .toString())
                                    .toList();
                                STM().redirect2page(
                                    ctx,
                                    ImageViewPage(
                                      img: imagePaths,
                                    ));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Clr().borderColor,
                                    ),
                                    borderRadius: BorderRadius.circular(5)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: CachedNetworkImage(
                                    height: 64,
                                    width: 64,
                                    fit: BoxFit.cover,
                                    imageUrl: v['image'][index]['image_path']
                                        .toString(),
                                    // imageUrl: "https://www.famunews.com/wp-content/themes/newsgamer/images/dummy.png",
                                    placeholder: (context, url) =>
                                        STM().loadingPlaceHolder(),
                                    errorWidget: (context, url, error) =>
                                        Image.network(
                                      fit: BoxFit.cover,
                                      'https://www.famunews.com/wp-content/themes/newsgamer/images/dummy.png',
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: Dim().d12,
                      ),
                      const Divider(
                        color: Color(0xffDCDCDC),
                      ),
                      SizedBox(
                        height: Dim().d8,
                      ),
                      InkWell(
                        onTap: () {
                          STM().redirect2page(
                              ctx,
                              InformantsList(
                                sCaseID: v['id'].toString(),
                              ));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Informants List",
                              style: Sty().mediumText.copyWith(
                                    color: Clr().primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Clr().primaryColor,
                              size: 14,
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Dim().d4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// crime Cases List Api
  void crimeCases() async {
    //Output
    var result = await STM()
        .getwithToken(context, Str().loading, "crime_branch/get_cases", sToken);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(
        () {
          caseList = result['data'];
          print("Case List $caseList");
        },
      );
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
