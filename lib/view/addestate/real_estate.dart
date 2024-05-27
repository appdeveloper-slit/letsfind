// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:letsfind/values/dimens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bottomnavigation/bottomnavigationPage.dart';
import '../../data/static_method.dart';
import '../../values/colors.dart';
import '../../values/dimens.dart';
import '../../values/strings.dart';
import '../../values/styles.dart';
import 'real_estate_details.dart';
import 'search_real_estate.dart';

class RealEstate extends StatefulWidget {
  final sPropertyList, sPropertyData;

  const RealEstate({Key? key, this.sPropertyList, this.sPropertyData})
      : super(key: key);

  @override
  State<RealEstate> createState() => _RealEstateState();
}

class _RealEstateState extends State<RealEstate> {
  late BuildContext ctx;

  var propertyData;
  List<dynamic> propertyList = [];
  bool isLoading = false;
  String? sToken;

  getsessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sToken = sp.getString('token') ?? '';
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        setState(() {
          isLoading = true;
          propertyList = widget.sPropertyList;
          propertyData = widget.sPropertyData;
          print("Property List :: $propertyList");
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

    print("Property List :: ${widget.sPropertyList}");

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
        actions: [
          InkWell(
            onTap: () {
              STM().replacePage(context, SearchRealEstate());
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Reset All',
                style: Sty().smallText.copyWith(
                    color: const Color(0xffFF8000),
                    fontWeight: FontWeight.w600),
              ),
            ),
          )
        ],
        centerTitle: true,
        title: Text(
          'Real Estate',
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: "Property Type: ",
                            // text: '₹10,000 ',
                            style: Sty().smallText.copyWith(
                                  color: Clr().textGrey,
                                  fontFamily: 'SP',
                                  fontWeight: FontWeight.w400,
                                ),
                            children: [
                              TextSpan(
                                text: propertyData['property_type'].toString(),
                                style: Sty().smallText.copyWith(
                                      color: Clr().textcolor,
                                      fontFamily: 'SP',
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Dim().d12,
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: "City: ",
                            // text: '₹10,000 ',
                            style: Sty().smallText.copyWith(
                                  color: Clr().textGrey,
                                  fontFamily: 'SP',
                                  fontWeight: FontWeight.w400,
                                ),
                            children: [
                              TextSpan(
                                text: propertyData['city'].toString(),
                                style: Sty().smallText.copyWith(
                                      color: Clr().textcolor,
                                      fontFamily: 'SP',
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Dim().d16,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: "Type of Property: ",
                            // text: '₹10,000 ',
                            style: Sty().smallText.copyWith(
                                  color: Clr().textGrey,
                                  fontFamily: 'SP',
                                  fontWeight: FontWeight.w400,
                                ),
                            children: [
                              TextSpan(
                                text: propertyData['type_of_property'],
                                style: Sty().smallText.copyWith(
                                      color: Clr().textcolor,
                                      fontFamily: 'SP',
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Dim().d12,
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: "Area: ",
                            // text: '₹10,000 ',
                            style: Sty().smallText.copyWith(
                                  color: Clr().textGrey,
                                  fontFamily: 'SP',
                                  fontWeight: FontWeight.w400,
                                ),
                            children: [
                              TextSpan(
                                text: "${propertyData['area']} sqft",
                                style: Sty().smallText.copyWith(
                                      color: Clr().textcolor,
                                      fontFamily: 'SP',
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Dim().d16,
                  ),
                  RichText(
                    text: TextSpan(
                      text: "Budget Range: ",
                      // text: '₹10,000 ',
                      style: Sty().smallText.copyWith(
                            color: Clr().textGrey,
                            fontFamily: 'SP',
                            fontWeight: FontWeight.w400,
                          ),
                      children: [
                        TextSpan(
                          text:
                              '${propertyData['min_value']} - ${propertyData['max_value']} ',
                          style: Sty().smallText.copyWith(
                                color: Clr().textcolor,
                                fontFamily: 'SP',
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Dim().d16,
                  ),
                  Divider(
                    color: Clr().lightGrey,
                  ),
                  SizedBox(
                    height: Dim().d12,
                  ),
                  propertyList.isNotEmpty
                      ? ListView.separated(
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: Dim().d20,
                            );
                          },
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: propertyList.length,
                          itemBuilder: (context, index) {
                            return cardLayout(ctx, index, propertyList);
                          },
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: Dim().d120,
                            ),
                            SvgPicture.asset("assets/property_not_found.svg"),
                            Center(
                              child: Text(
                                'No Properties Found',
                                style: Sty().mediumText.copyWith(
                                    fontSize: 20,
                                    color: Clr().primaryColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        ),
                  SizedBox(
                    height: Dim().d20,
                  ),
                ],
              )
            : Container(),
      ),
    );
  }

  Widget cardLayout(ctx, index, list) {
    var v = propertyList[index];

    return InkWell(
      onTap: () {
        STM().redirect2page(ctx, RealEstateDetails(sID: v['id'].toString()));
      },
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
          padding:
              EdgeInsets.symmetric(horizontal: Dim().d16, vertical: Dim().d16),
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
                          // "assets/house.png",
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              // 'Victory Splendeour RESALE 2BHK Flat in Koperkhairan',
                              v['name'].toString(),
                              maxLines: 2,
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
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Dim().d8,
                        ),
                        Text(
                          // '₹ 1.2 Cr',
                          "₹ ${v['price'].toString()}/-",
                          style: Sty().mediumText.copyWith(
                              color: Clr().primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: Dim().d12,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'Posted On: ${v["posted_on"]}',
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
              RealEstateDetails(
                sID: id,
              )
              // OGSubCatDetails(
              //   sID: widget.sID,
              //   sName: widget.sName,
              //   sCatID: widget.sCatID,
              //   sSubCatID: widget.sSubCatID,
              // ),
              );
          STM().displayToast(message);
        },
      );
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
