// ignore_for_file: use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:letsfind/values/dimens.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bottomnavigation/bottomnavigationPage.dart';
import '../../data/static_method.dart';
import '../../values/colors.dart';
import '../../values/styles.dart';
import 'matrimony_details.dart';

class MatrimonyListing extends StatefulWidget {
  final sPropertyList, sPropertyData;

  const MatrimonyListing({Key? key, this.sPropertyList, this.sPropertyData})
      : super(key: key);

  @override
  State<MatrimonyListing> createState() => _MatrimonyListingState();
}

class _MatrimonyListingState extends State<MatrimonyListing> {
  late BuildContext ctx;

  int isSelected = -1;
  int selectedSlider = 0;
  var propertyData;
  List<dynamic> propertyList = [];

  List<dynamic> sliderList = [
    "assets/detail_slider.png",
    "assets/detail_slider.png",
    "assets/detail_slider.png"
  ];
  bool isLoading = false;

  getsessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    STM().checkInternet(context, widget).then((value) {
      if (value) {
        setState(() {
          isLoading = true;
          // propertyList = widget.sPropertyList;
          // propertyData = widget.sPropertyData;
          // print("Property List :: $propertyList");
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
              // STM().replacePage(context, SearchRealEstate());
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
          'Search Results',
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
                        flex: 1,
                        child: RichText(
                          text: TextSpan(
                            text: "Gender:",
                            // text: '₹10,000 ',
                            style: Sty().microText.copyWith(
                                  color: Clr().textGrey,
                                  fontFamily: 'SP',
                                  fontWeight: FontWeight.w400,
                                ),
                            children: [
                              TextSpan(
                                // text: propertyData['property_type'].toString(),
                                text: " Male",
                                style: Sty().microText.copyWith(
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
                        width: Dim().d8,
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: RichText(
                            text: TextSpan(
                              text: "Marital Status: ",
                              // text: '₹10,000 ',
                              style: Sty().microText.copyWith(
                                    color: Clr().textGrey,
                                    fontFamily: 'SP',
                                    fontWeight: FontWeight.w400,
                                  ),
                              children: [
                                TextSpan(
                                  // text: propertyData['city'].toString(),
                                  text: "Single",
                                  style: Sty().microText.copyWith(
                                        color: Clr().textcolor,
                                        fontFamily: 'SP',
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Dim().d8,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            text: TextSpan(
                              text: "State: ",
                              // text: '₹10,000 ',
                              style: Sty().microText.copyWith(
                                    color: Clr().textGrey,
                                    fontFamily: 'SP',
                                    fontWeight: FontWeight.w400,
                                  ),
                              children: [
                                TextSpan(
                                  // text: propertyData['city'].toString(),
                                  text: "Maharashtra",
                                  style: Sty().microText.copyWith(
                                        color: Clr().textcolor,
                                        fontFamily: 'SP',
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Dim().d8,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: RichText(
                          text: TextSpan(
                            text: "City:",
                            // text: '₹10,000 ',
                            style: Sty().microText.copyWith(
                                  color: Clr().textGrey,
                                  fontFamily: 'SP',
                                  fontWeight: FontWeight.w400,
                                ),
                            children: [
                              TextSpan(
                                // text: propertyData['property_type'].toString(),
                                text: " Mumbai",
                                style: Sty().microText.copyWith(
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
                        width: Dim().d8,
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                          child: RichText(
                            text: TextSpan(
                              text: "Religion:",
                              // text: '₹10,000 ',
                              style: Sty().microText.copyWith(
                                    color: Clr().textGrey,
                                    fontFamily: 'SP',
                                    fontWeight: FontWeight.w400,
                                  ),
                              children: [
                                TextSpan(
                                  // text: propertyData['city'].toString(),
                                  text: " Hindu",
                                  style: Sty().microText.copyWith(
                                        color: Clr().textcolor,
                                        fontFamily: 'SP',
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Dim().d8,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: RichText(
                            text: TextSpan(
                              text: "Caste: ",
                              // text: '₹10,000 ',
                              style: Sty().microText.copyWith(
                                    color: Clr().textGrey,
                                    fontFamily: 'SP',
                                    fontWeight: FontWeight.w400,
                                  ),
                              children: [
                                TextSpan(
                                  // text: propertyData['city'].toString(),
                                  text: "Open",
                                  style: Sty().microText.copyWith(
                                        color: Clr().textcolor,
                                        fontFamily: 'SP',
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
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
                      text: "Age:",
                      // text: '₹10,000 ',
                      style: Sty().microText.copyWith(
                            color: Clr().textGrey,
                            fontFamily: 'SP',
                            fontWeight: FontWeight.w400,
                          ),
                      children: [
                        TextSpan(
                          text:
                              // '${propertyData['min_value']} - ${propertyData['max_value']} ',
                              "18 -26 yrs",
                          style: Sty().microText.copyWith(
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
                  propertyList.isEmpty
                      ? ListView.separated(
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: Dim().d20,
                            );
                          },
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return cardLayout(ctx, index);
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

  Widget cardLayout(ctx, index, {list}) {
    // var v = propertyList[index];

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
        padding:
            EdgeInsets.symmetric(horizontal: Dim().d16, vertical: Dim().d16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () {
                    STM().redirect2page(ctx, MatrimonyDetails());
                    // STM().redirect2page(ctx, MatrimonyDetails(sID: v['id'].toString()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Clr().borderColor,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          "assets/girl_img.png",
                          // v['image'],
                          width: 90,
                          height: 110,
                          fit: BoxFit.cover,
                        )),
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
                            'Aniket A. Banote',
                            // v['name'].toString(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Sty().mediumText.copyWith(
                                color: Clr().textcolor,
                                fontWeight: FontWeight.w500),
                          ),
                          InkWell(
                              onTap: () {
                                setState(() {
                                  isSelected = index;
                                });
                              },
                              child: SvgPicture.asset(
                                  isSelected == index
                                  ? "assets/heart_filled.svg"
                                  : "assets/heart_outlined.svg"))
                        ],
                      ),
                      SizedBox(
                        height: Dim().d8,
                      ),
                      Text(
                        '27 years',
                        // v['name'].toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Sty().microText.copyWith(
                            color: const Color(0xff949494),
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: Dim().d8,
                      ),
                      Text(
                        'Lorem ipsum dolor sit amet consectet ur.Vitae at blandit Senectus amet...',
                        // "₹ ${v['price'].toString()}/-",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Sty().smallText.copyWith(
                            color: Clr().textcolor,
                            fontWeight: FontWeight.w400),
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
      items: sliderList.map((url) {
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
}
