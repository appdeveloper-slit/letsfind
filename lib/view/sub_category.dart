import 'package:auto_size_widget/auto_size_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:letsfind/bottomnavigation/bottomnavigationPage.dart';
import 'package:letsfind/view/subcat_details.dart';
import 'package:letsfind/values/dimens.dart';
import 'package:letsfind/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controller/subcategorycontroller.dart';
import '../data/static_method.dart';
import '../values/colors.dart';
import '../values/strings.dart';
import 'reviewdetails.dart';

class SubCategoryPage extends StatefulWidget {
  final data;
  const SubCategoryPage({super.key, this.data});

  @override
  State<SubCategoryPage> createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage> {
  late BuildContext ctx;
  int selectedSlider = 0;
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      subCategoryController()
          .getShops(ctx, setState, widget.data['id'].toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;

    print("Data :: ${widget.data}");

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
          widget.data['name'],
          style: Sty().largeText.copyWith(
                color: Clr().primaryColor,
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(Dim().d16),
        child: Column(
          children: [
            if (Shopbannerlist.isNotEmpty) sliderLayout(ctx),
            if (shopList.isEmpty)
              Column(
                children: [
                  SizedBox(
                    height: Dim().d140,
                  ),
                  SvgPicture.asset(
                    "assets/no_product.svg",
                    width: 320,
                  ),
                  SizedBox(
                    height: Dim().d32,
                  ),
                  Center(
                    child: Text(
                      'No Shops Found',
                      style: Sty().mediumText.copyWith(
                          fontSize: 20,
                          color: Clr().primaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            if (shopList.isNotEmpty)
              ListView.separated(
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: Dim().d6,
                  );
                },
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: shopList.length,
                itemBuilder: (context, index) {
                  return detailsLayout(ctx, shopList[index]);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget sliderLayout(ctx) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        viewportFraction: 0.9,
        height: 180,
        initialPage: 0,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        onPageChanged: (index, reason) {
          setState(() {
            selectedSlider = index;
          });
        },
      ),
      items: Shopbannerlist.map((url) {
        return Padding(
          padding: EdgeInsets.only(bottom: Dim().d12),
          child: Builder(
            builder: (BuildContext context) {
              return InkWell(
                onTap: () {
                  STM().getLink(
                    link: url['link'],
                    linktype: url['link_type'],
                    moduleid: url['module_id'],
                    productid: url['product_id'],
                    ctx: ctx,
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    url['image'],
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        );
      }).toList(),
    );
  }

  Widget detailsLayout(ctx, v) {
    return Container(
      margin: EdgeInsets.only(top: Dim().d12),
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    STM().redirect2page(
                      ctx,
                      SubCatDetails(
                        data: v,
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
                      child: v['shop_logo'] == null
                          ? Image.network(
                              'https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg',
                              width: Dim().d100,
                              height: 90.0,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              v['shop_logo'],
                              width: Dim().d100,
                              height: 90.0,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
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
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  width: Dim().d12,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                STM().redirect2page(
                                  ctx,
                                  SubCatDetails(
                                    data: v,
                                  ),
                                );
                              },
                              child: Text(
                                '${v['shop_name']}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Sty().smallText.copyWith(
                                    color: Clr().textcolor,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: Dim().d12,
                          ),
                          v['is_favourite'] == true
                              ? InkWell(
                                  onTap: () {
                                    subCategoryController()
                                        .addFav(ctx, setState, v['id']);
                                    setState(() {
                                      v['is_favourite'] = false;
                                    });
                                  },
                                  child: SvgPicture.asset("assets/like.svg"))
                              : InkWell(
                                  onTap: () {
                                    subCategoryController()
                                        .addFav(ctx, setState, v['id']);
                                    setState(() {
                                      v['is_favourite'] = true;
                                    });
                                  },
                                  child: SvgPicture.asset("assets/unlike.svg")),
                        ],
                      ),
                      SizedBox(
                        height: Dim().d20,
                      ),
                      SizedBox(
                        width: MediaQuery.of(ctx).size.width / 1.9,
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dim().d12, vertical: Dim().d8),
                                decoration: BoxDecoration(
                                    color: const Color(0xffFFB400),
                                    borderRadius: BorderRadius.circular(55)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      v['rating'].toString(),
                                      style: Sty().smallText.copyWith(
                                          color: Clr().white,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      width: Dim().d4,
                                    ),
                                    Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Clr().white,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: Dim().d20,
                              ),
                              InkWell(
                                onTap: () {
                                  STM().redirect2page(
                                    ctx,
                                    reviewdetailsPage(
                                      id: v['id'].toString(),
                                      data: widget.data.toString(),
                                    ),
                                  );
                                },
                                child: SizedBox(
                                  height: 32.0,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        child: Text(
                                          '${STM().formatAmount(v['total_review'])} Reviews',
                                          maxLines: 2,
                                          style: Sty().smallText.copyWith(
                                              color: const Color(0xff464646),
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                      Text(
                                        '----------------',
                                        style: Sty().smallText.copyWith(
                                            color: const Color(0xff464646),
                                            height: 0.2,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: Dim().d20,
                              ),
                              v['is_verified'] == true
                                  ? Container(
                                      margin: EdgeInsets.only(
                                          left: Dim().d12, top: Dim().d12),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Dim().d12,
                                          vertical: Dim().d8),
                                      decoration: BoxDecoration(
                                          color: const Color(0xff2AC0D4),
                                          borderRadius:
                                              BorderRadius.circular(55)),
                                      child: Center(
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
                                              style: Sty().microText.copyWith(
                                                  color: Clr().white,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: Dim().d100,
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: Dim().d8,
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
                        onPressed: () async {
                          await launchUrl(
                            Uri.parse(
                                'geo:${v['latitude']},${v['longitude']}?q=${v['latitude']},${v['longitude']}'),
                          );
                          subCategoryController()
                              .addleads(ctx, setState, v['id']);
                          // STM().redirect2page(ctx, Home());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/location.png',
                              height: Dim().d16,
                            ),
                            // Icon(
                            //   Icons.location,
                            //   size: 16,
                            //   color: Clr().primaryColor,
                            // ),
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
                        onPressed: () async {
                          await STM().openWhatsApp(v['wp_mobile']);
                          subCategoryController()
                              .addleads(ctx, setState, v['id']);
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
                              style:
                                  Sty().microText.copyWith(color: Clr().white),
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
                        onPressed: () async {
                          // STM().redirect2page(ctx, Home());
                          await STM().openDialer(v['mobile']);
                          subCategoryController()
                              .addleads(ctx, setState, v['id']);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.phone,
                              size: 16,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: Dim().d4,
                            ),
                            Text(
                              'Call Now',
                              style:
                                  Sty().microText.copyWith(color: Clr().white),
                            ),
                          ],
                        )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
