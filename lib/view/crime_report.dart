// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:letsfind/bottomnavigation/bottomnavigationPage.dart';
import 'package:letsfind/values/dimens.dart';
import 'package:letsfind/view/imageview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/static_method.dart';
import '../values/colors.dart';
import '../values/strings.dart';
import '../values/styles.dart';

class CrimeReport extends StatefulWidget {
  const CrimeReport({Key? key}) : super(key: key);

  @override
  State<CrimeReport> createState() => _CrimeReportState();
}

class _CrimeReportState extends State<CrimeReport> {
  late BuildContext ctx;

  String? sToken;
  List<dynamic> caseList = [];
  bool isLoading = false;

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
          'Crime Report',
          style: Sty().largeText.copyWith(
                color: Clr().primaryColor,
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dim().d16),
        child: isLoading
            ? Column(
                children: [
                  caseList.isNotEmpty
                      ? ListView.separated(
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
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: Dim().d280,
                            ),
                            InkWell(
                              onTap: () {},
                              child: Text(
                                'No Cases Found',
                                style: Sty().largeText,
                              ),
                            ),
                          ],
                        ),
                ],
              )
            : Container(),
      ),
    );
  }

  ///Crime Branch List Layout
  Widget cardLayout(ctx, index2, list) {
    var v = caseList[index2];
    final imageList = v['image'];

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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Title',
                        style: Sty().microText.copyWith(
                            color: Clr().hintColor,
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: Dim().d4,
                      ),
                      Text(
                        // 'Vijay Malya is Missing',
                        v['title'].toString(),
                        style: Sty().smallText.copyWith(
                            color: Clr().textcolor,
                            fontWeight: FontWeight.w500),
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
                      if (imageList.isNotEmpty)
                        Text(
                          'Images',
                          style: Sty().microText.copyWith(
                              color: Clr().hintColor,
                              fontWeight: FontWeight.w500),
                        ),
                      if (imageList.isNotEmpty)
                        SizedBox(
                          height: Dim().d12,
                        ),
                      if (imageList.isNotEmpty)
                        SizedBox(
                          height: 64,
                          child: ListView.separated(
                            separatorBuilder: (context, index2) {
                              return SizedBox(
                                width: Dim().d12,
                              );
                            },
                            itemCount: imageList.length,
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (BuildContext context, int index) {
                              return InkWell(
                                onTap: () {
                                  // List<String> imagePaths = caseList
                                  //     .map((e) => e['image'][index]['image_path']
                                  //         .toString())
                                  // .toList();
                                  STM().redirect2page(
                                      ctx,
                                      ImageViewPage(
                                          img: imageList[index]['image_path']
                                              .toString()));
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
                        height: Dim().d20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: Clr().primaryColor),
                            onPressed: () {
                              notifyCase(id: v['id'].toString());
                            },
                            child: Text(
                              'Notify Authorities',
                              style:
                                  Sty().mediumText.copyWith(color: Clr().white),
                            )),
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
    SharedPreferences sp = await SharedPreferences.getInstance();
    //Output
    var result = await STM().getwithToken(
        context, Str().loading, "user/get_cases", sp.getString('token'));
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(
        () {
          isLoading = true;
          caseList = result['data'];
          print("Case List $caseList");
        },
      );
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  /// Notify case Api
  void notifyCase({id}) async {
    FormData body = FormData.fromMap({
      "case_id": id,
    });

    //Output
    var result = await STM().postWithToken(
        context, Str().loading, "user/notify_authority", body, sToken);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(
        () {
          STM().displayToast(message);
        },
      );
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
