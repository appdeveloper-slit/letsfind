import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:letsfind/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/static_method.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../view/add shops/shop_details.dart';
import '../view/addestate/esatelist.dart';
import '../view/addestate/step1.dart';
import '../view/favlistPage.dart';
import '../view/homelayout/home.dart';
import '../view/old_is_gold/product_list.dart';
import '../view/shop_listing.dart';

Widget bottomBarLayout(ctx, index, {b}) {
  return BottomNavigationBar(
      elevation: 10,
      backgroundColor: Clr().white,
      // unselectedItemColor: Clr().black,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Clr().primaryColor,
      unselectedItemColor: Clr().textGrey,
      showSelectedLabels: true,
      selectedFontSize: 14,
      selectedLabelStyle: TextStyle(color: Clr().textcolor),
      currentIndex: index,
      onTap: (i) async {
        switch (i) {
          case 0:
            STM().finishAffinity(ctx, Home());
            break;
          case 1:
            index == 1
                ? STM().finishAffinity(ctx, Home())
                : STM().finishAffinity(ctx, Home());
            break;
          case 2:
            index == 2
                ? STM().finishAffinity(ctx, favListPage())
                : STM().finishAffinity(ctx, favListPage());
            break;
          case 3:
            showModalBottomSheet(
              context: ctx,
              builder: (context) {
                return BottomSheet(
                  onClosing: () {},
                  builder: (context) {
                    return Container(
                      color: Clr().white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: Dim().d12,
                                left: Dim().d12,
                                right: Dim().d12,
                                bottom: Dim().d12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    SharedPreferences sp =
                                        await SharedPreferences.getInstance();
                                    var result = await STM().allApi(
                                      apiname: "my_shops",
                                      ctx: ctx,
                                      load: true,
                                      loadtitle: 'Checking...',
                                      token: sp.getString('token'),
                                      type: 'get',
                                    );
                                    var success = result['success'];
                                    var message = result['message'];
                                    if (success) {
                                      result['data'].isEmpty
                                          ? STM().redirect2page(
                                              ctx,
                                              const ShopDetails(),
                                            )
                                          : STM().redirect2page(
                                              ctx, const ShopListing());
                                    } else {
                                      STM().errorDialog(ctx, message);
                                    }
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset('assets/shops.svg'),
                                      Text(
                                        'Shops',
                                        style: Sty().smallText.copyWith(
                                              color: const Color(0xff606060),
                                            ),
                                      )
                                    ],
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset('assets/jobs.svg'),
                                    Text(
                                      'Jobs',
                                      style: Sty().smallText.copyWith(
                                            color: Color(0xff606060),
                                          ),
                                    )
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset('assets/matrimonys.svg'),
                                    Text(
                                      'Matrimony',
                                      style: Sty().smallText.copyWith(
                                            color: Color(0xff606060),
                                          ),
                                    )
                                  ],
                                ),
                                InkWell(
                                  onTap: () {
                                    STM()
                                        .redirect2page(ctx, const estateList());
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset('assets/property.svg'),
                                      Text(
                                        'Real Estate',
                                        style: Sty().smallText.copyWith(
                                              color: Color(0xff606060),
                                            ),
                                      )
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    STM().redirect2page(ctx, ProductList());
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset('assets/oldisgolds.svg'),
                                      Text(
                                        'Old is Gold',
                                        style: Sty().smallText.copyWith(
                                              color: Color(0xff606060),
                                            ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            );
            break;
        }
      },
      items: STM().getBottomList(index, b));
}
