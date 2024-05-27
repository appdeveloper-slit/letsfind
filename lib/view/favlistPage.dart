import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:letsfind/view/subcat_details.dart';
import 'package:letsfind/values/dimens.dart';
import 'package:letsfind/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bottomnavigation/bottomnavigationPage.dart';
import '../controller/subcategorycontroller.dart';
import '../data/static_method.dart';
import '../values/colors.dart';
import '../values/strings.dart';
import 'homelayout/home.dart';
import 'reviewdetails.dart';

class favListPage extends StatefulWidget {
  const favListPage({super.key});

  @override
  State<favListPage> createState() => _favListPageState();
}

class _favListPageState extends State<favListPage> {
  late BuildContext ctx;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      subCategoryController().favList(ctx, setState);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;

    return WillPopScope(
      onWillPop: () async {
        STM().finishAffinity(ctx, Home());
        return false;
      },
      child: Scaffold(
        backgroundColor: Clr().background,
        bottomNavigationBar: bottomBarLayout(ctx, 2),
        appBar: AppBar(
          forceMaterialTransparency: true,
          backgroundColor: Clr().background,
          leading: InkWell(
            onTap: () {
              STM().finishAffinity(ctx, Home());
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
            'Favourites',
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
              ListView.separated(
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: Dim().d6,
                  );
                },
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: favlist.length,
                itemBuilder: (context, index) {
                  return detailsLayout(ctx, favlist[index], index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget detailsLayout(ctx, v, index) {
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
        child: Row(
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
                          height: Dim().d100,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          v['shop_logo'],
                          width: Dim().d100,
                          height: Dim().d100,
                          fit: BoxFit.cover,
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
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${v['shop_name']}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Sty().smallText.copyWith(
                              color: Clr().textcolor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        width: Dim().d20,
                      ),
                      // v['is_favourite'] == true
                      //     ?
                      InkWell(
                          onTap: () {
                            setState(() {
                              subCategoryController()
                                  .addFav(ctx, setState, v['id']);
                              favlist.removeAt(index);
                            });
                          },
                          child: SvgPicture.asset("assets/like.svg")),
                      // : InkWell(
                      //     onTap: () {
                      //       subCategoryController()
                      //           .addFav(ctx, setState, v['id']);
                      //       setState(() {
                      //         v['is_favourite'] = true;
                      //       });
                      //     },
                      //     child: SvgPicture.asset("assets/unlike.svg")),
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
                                  id: v['id'],
                                ),
                              );
                            },
                            child: SizedBox(
                              height: Dim().d32,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
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
                                      borderRadius: BorderRadius.circular(55)),
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
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     v['rating'] != 0
                  //         ? Container(
                  //             margin: EdgeInsets.only(right: Dim().d12),
                  //             padding: EdgeInsets.symmetric(
                  //                 horizontal: Dim().d12, vertical: Dim().d4),
                  //             decoration: BoxDecoration(
                  //                 color: const Color(0xffFFB400),
                  //                 borderRadius: BorderRadius.circular(55)),
                  //             child: Row(
                  //               children: [
                  //                 Text(
                  //                   v['rating'].toString(),
                  //                   style: Sty().microText.copyWith(
                  //                       color: Clr().white,
                  //                       fontWeight: FontWeight.w800),
                  //                 ),
                  //                 SizedBox(
                  //                   width: Dim().d4,
                  //                 ),
                  //                 Icon(
                  //                   Icons.star,
                  //                   size: 14,
                  //                   color: Clr().white,
                  //                 )
                  //               ],
                  //             ),
                  //           )
                  //         : Container(),
                  //     v['total_review'] != 0
                  //         ? Expanded(
                  //             child: InkWell(
                  //               onTap: () {
                  //                 STM().redirect2page(
                  //                   ctx,
                  //                   reviewdetailsPage(
                  //                     id: v['id'],
                  //                   ),
                  //                 );
                  //               },
                  //               child: Column(
                  //                 crossAxisAlignment: CrossAxisAlignment.center,
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: [
                  //                   Text(
                  //                     '${STM().formatAmount(v['total_review'])} Reviews',
                  //                     style: Sty().microText.copyWith(
                  //                         color: Color(0xff464646),
                  //                         fontWeight: FontWeight.w600),
                  //                   ),
                  //                   Text(
                  //                     '-----------',
                  //                     style: Sty().microText.copyWith(
                  //                         color: Color(0xff464646),
                  //                         height: 0.2,
                  //                         fontWeight: FontWeight.w600),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           )
                  //         : Container(),
                  //     v['is_verified'] == true
                  //         ? Container(
                  //             margin: EdgeInsets.only(left: Dim().d12),
                  //             padding: EdgeInsets.symmetric(
                  //                 horizontal: Dim().d12, vertical: Dim().d4),
                  //             decoration: BoxDecoration(
                  //                 color: const Color(0xff2AC0D4),
                  //                 borderRadius: BorderRadius.circular(55)),
                  //             child: Center(
                  //               child: Wrap(
                  //                 crossAxisAlignment: WrapCrossAlignment.center,
                  //                 children: [
                  //                   Icon(
                  //                     Icons.verified,
                  //                     size: 14,
                  //                     color: Clr().white,
                  //                   ),
                  //                   SizedBox(
                  //                     width: Dim().d4,
                  //                   ),
                  //                   Text(
                  //                     'Verified',
                  //                     style: Sty().microText.copyWith(
                  //                         color: Clr().white,
                  //                         fontWeight: FontWeight.w800),
                  //                   ),
                  //                 ],
                  //               ),
                  //             ),
                  //           )
                  //         : Container(),
                  //   ],
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
