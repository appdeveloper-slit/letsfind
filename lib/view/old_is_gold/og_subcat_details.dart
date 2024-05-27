import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:letsfind/values/colors.dart';
import 'package:letsfind/values/dimens.dart';
import 'package:letsfind/values/strings.dart';
import 'package:letsfind/values/styles.dart';
import 'package:letsfind/view/imageview.dart';
import 'package:letsfind/view/old_is_gold/zoomable_page.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/static_method.dart';
import 'og_subcat_productlist.dart';

class OGSubCatDetails extends StatefulWidget {
  final sID, sCatID, sSubCatID, sName;

  const OGSubCatDetails(
      {Key? key, this.sID, this.sCatID, this.sSubCatID, this.sName})
      : super(key: key);

  @override
  State<OGSubCatDetails> createState() => _OGSubCatDetailsState();
}

class _OGSubCatDetailsState extends State<OGSubCatDetails> {
  late BuildContext ctx;

  String? sToken;
  dynamic pDetails;
  int pageIndex = 0;
  List<dynamic> imageList = [];
  List<dynamic> amenitiesList = [];
  List<dynamic> similarPropList = [];
  bool isLoaded = false;

  getsessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sToken = sp.getString('token') ?? '';
    // sToken = "m8MNGv6SOBuDjzBzEusjFJQJrvHr8YvetsDVYnQm27b029c0";
    print("Token :: $sToken");
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        productDetails();
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
        STM().replacePage(
            ctx,
            OGSubCatList(
              sCatID: widget.sCatID,
              sSubCatID: widget.sSubCatID,
              sName: widget.sName,
            ));
        return false;
      },
      child: Scaffold(
        backgroundColor: Clr().background,
        appBar: AppBar(
          forceMaterialTransparency: true,
          backgroundColor: Clr().background,
          leading: InkWell(
            onTap: () {
              // STM().back2Previous(ctx);
              setState(() {
                STM().replacePage(
                    ctx,
                    OGSubCatList(
                      sCatID: widget.sCatID,
                      sSubCatID: widget.sSubCatID,
                      sName: widget.sName,
                    ));
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
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset("assets/back.svg"),
                ),
              ),
            ),
          ),
          centerTitle: true,
          actions: [
            isLoaded
                ? InkWell(
                    onTap: () {
                      setState(() {
                        favourite(id: widget.sID);
                        print("favourite :: ${pDetails['is_favourite']}");
                      });
                    },
                    child: pDetails['is_favourite'] == true
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SvgPicture.asset(
                              "assets/like.svg",
                              color: const Color(0xffFF8000),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SvgPicture.asset("assets/unlike.svg"),
                          ),
                  )
                : Container(),
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
                            height: 230,
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
                                      List<dynamic> imagePaths = imageList
                                          .map((e) => e['image'].toString())
                                          .toList();
                                      print("Page Index :: $pageIndex");
                                      print("Image Path :: $imagePaths");
                                      STM().redirect2page(
                                          context,
                                          ZoomPage(
                                            // img: imagePaths,
                                            // type: pageIndex,
                                            imageUrls: imagePaths,
                                            initialIndex: pageIndex,
                                          ));
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
                                        pDetails['category'].toString(),
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
                                        pDetails['subcategory'].toString(),
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
                              SizedBox(
                                height: Dim().d12,
                              ),
                              Text(
                                // '₹ 500',
                                '₹ ${pDetails['price'].toString()}',
                                style: Sty().mediumText.copyWith(
                                    color: Clr().primaryColor,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: Dim().d8,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Posted On: ${pDetails['posted_on'].toString()}',
                                  style: Sty().microText.copyWith(
                                      color: Color(0xff949494),
                                      fontWeight: FontWeight.w600),
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
                                      onPressed: () {
                                        launchMap(
                                            pDetails['address'].toString());
                                      },
                                      child: SvgPicture.asset(
                                        "assets/location.svg",
                                        width: 35,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(55),
                                          ),
                                          backgroundColor: Clr().primaryColor),
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
                                      child: SvgPicture.asset(
                                        "assets/call.svg",
                                        width: 18,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(55),
                                          ),
                                          backgroundColor: Clr().primaryColor),
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
                    similarPropList.isEmpty
                        ? Container()
                        : Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dim().d16,
                            ),
                            child: Text(
                              "Similar Products",
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
                            height: 110,
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
        ),
      ),
    );
  }

  /// Similar Properties Card Layout
  Widget similarCardLayout(ctx, index, list) {
    var v = list[index];

    return Container(
      width: MediaQuery.of(context).size.width / 1.2,
      decoration: BoxDecoration(
        color: Clr().white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Clr().hintColor.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
          ),
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
                InkWell(
                  onTap: () {
                    STM().replacePage(
                      ctx,
                      OGSubCatDetails(
                        sID: v['id'],
                        sName: widget.sName,
                        sCatID: widget.sCatID,
                        sSubCatID: widget.sSubCatID,
                      ),
                    );
                  },
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Clr().borderColor)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        v['image'].toString(),
                        fit: BoxFit.fill,
                        // "assets/fridge.png",
                        width: 80,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: Dim().d20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            v['name'].toString(),
                            // 'Whirlpool 184 L 2 Star Direct Cool Single Door Refrigerator',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Sty().mediumText.copyWith(
                                color: Clr().textcolor,
                                fontWeight: FontWeight.w500),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                favourite(id: v['id'].toString());
                                print("favourite :: ${v['is_favourite']}");
                              });
                            },
                            child: v['is_favourite'] == true
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: SvgPicture.asset(
                                      "assets/like.svg",
                                      color: const Color(0xffFF8000),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child:
                                        SvgPicture.asset("assets/unlike.svg"),
                                  ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: Dim().d8,
                      ),
                      Text(
                        '₹ ${v['price'].toString()}/-',
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
                          'Posted On: ${v['posted_on'].toString()}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
    );
  }

  ///property Details Api
  void productDetails() async {
    FormData body = FormData.fromMap({
      "product_id": widget.sID,
    });
    var result = await STM()
        .postWithToken(ctx, Str().loading, 'product_details', body, sToken);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(() {
        isLoaded = true;
        pDetails = result['data'];
        imageList = pDetails['images'];
        similarPropList = pDetails['similar_products'];
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  Future<void> launchMap(String address) async {
    String encodedAddress = Uri.encodeFull(address);
    String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$encodedAddress';
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not launch $googleMapsUrl';
    }
  }

  /// favourite products
  void favourite({id}) async {
    FormData body = FormData.fromMap({
      "product_id": id,
    });
    //Output
    var result = await STM().postWithToken(
        context, Str().loading, "favourite_product", body, sToken);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(
        () {
          STM().replacePage(
              ctx,
              OGSubCatDetails(
                sID: widget.sID,
                sName: widget.sName,
                sCatID: widget.sCatID,
                sSubCatID: widget.sSubCatID,
              ));
          STM().displayToast(message);
        },
      );
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
