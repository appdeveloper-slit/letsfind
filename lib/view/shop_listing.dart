// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, sort_child_properties_last

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:letsfind/bottomnavigation/bottomnavigationPage.dart';
import 'package:letsfind/values/colors.dart';
import 'package:letsfind/values/styles.dart';
import 'package:letsfind/view/add%20shops/shop_category.dart';
import 'package:letsfind/view/add%20shops/shop_details.dart';
import 'package:letsfind/view/add%20shops/shop_info.dart';
import 'package:letsfind/view/add%20shops/shop_services.dart';
import 'package:letsfind/view/homelayout/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/static_method.dart';
import '../values/dimens.dart';
import '../values/strings.dart';
import 'add shops/contact_details.dart';
import 'add shops/select_timmings.dart';
import 'add shops/shop_offers.dart';
import 'leaddetails.dart';
import 'reviewdetails.dart';

class ShopListing extends StatefulWidget {
  const ShopListing({Key? key}) : super(key: key);

  @override
  State<ShopListing> createState() => _ShopListingState();
}

class _ShopListingState extends State<ShopListing>
    with SingleTickerProviderStateMixin {
  late BuildContext ctx;

  int _selectIndex = -1;

  List<dynamic> myLeadsList = [];
  bool _isExpanded = false;
  List<dynamic> shopList = [];
  late TabController _tabController;
  bool check = false;

  getsessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getLeads();
      }
    });
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 1);
    getsessionData();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        backgroundColor: Clr().white,
        bottomNavigationBar: bottomBarLayout(ctx, 0),
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
          title: InkWell(
            onTap: () {
              // STM().redirect2page(context, MyWidget());
            },
            child: Text(
              'Shop Listing',
              style: Sty().largeText.copyWith(
                    color: Clr().primaryColor,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
        ),
        body: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabAlignment: TabAlignment.fill,
              physics: BouncingScrollPhysics(),
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: Sty().smallText.copyWith(fontWeight: FontWeight.w500),
              unselectedLabelStyle: Sty().smallText.copyWith(
                    color: Clr().grey,
                  ),
              indicatorColor: Clr().primaryColor,
              labelColor: Clr().primaryColor,
              tabs: const [
                Tab(text: 'Leads'),
                Tab(text: 'My Shops'),
              ],
            ),
            Expanded(
              child: TabBarView(
                  controller: _tabController,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: myLeadsList.length,
                      padding: EdgeInsets.all(Dim().d12),
                      shrinkWrap: true,
                      itemBuilder: (ctx, index) {
                        return leadsLayout(ctx, index, myLeadsList[index]);
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: Dim().d12,
                        );
                      },
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: Dim().d20,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dim().d16,
                            ),
                            child: InkWell(
                              onTap: () {
                                STM().redirect2page(ctx, ShopDetails());
                              },
                              child: DottedBorder(
                                borderType: BorderType.RRect,
                                dashPattern: [8, 10],
                                color: Clr().primaryColor,
                                radius: Radius.circular(55),
                                strokeWidth: 0.8,
                                padding: EdgeInsets.all(6),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  child: SizedBox(
                                    height: 30,
                                    width: double.infinity,
                                    child: Center(
                                      child: Text(
                                        'Add New Shop',
                                        style: Sty().smallText.copyWith(
                                            color: Clr().primaryColor,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: shopList.length,
                            padding: EdgeInsets.all(Dim().d12),
                            shrinkWrap: true,
                            itemBuilder: (ctx, index) {
                              return myShopLayout(ctx, index, shopList[index]);
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: Dim().d12,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  ///LeadsLayout Code
  Widget leadsLayout(ctx, index, list) {
    var v = list;
    return InkWell(
      onTap: () {
        STM().redirect2page(
          ctx,
          leadDetailsPage(
            data: v['leads'],
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
                color: Clr().hintColor.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 0)
          ],
        ),
        child: Card(
          color: Clr().white,
          surfaceTintColor: Clr().white,
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: BorderSide(color: Clr().borderColor)),
          child: Padding(
            padding: EdgeInsets.all(Dim().d16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        height: 55,
                        width: 55,
                        fit: BoxFit.cover,
                        imageUrl: v['shop_logo'].toString(),
                        placeholder: (context, url) =>
                            STM().loadingPlaceHolder(),
                        errorWidget: (context, url, error) => Image.network(
                            fit: BoxFit.cover,
                            'https://www.famunews.com/wp-content/themes/newsgamer/images/dummy.png'),
                      ),
                    ),
                    SizedBox(
                      width: Dim().d12,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Shop Name',
                            style: Sty().microText.copyWith(
                                color: Clr().hintColor,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: Dim().d4,
                          ),
                          Text(
                            // 'Shree Swami Samarth Jewelers Trust Limited',
                            v['shop_name'].toString(),
                            style: Sty().mediumText.copyWith(
                                color: Clr().textcolor,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: Dim().d12,
                ),
                Divider(),
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
                            v['leads'][0]['user']['name'].toString(),
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
                            DateFormat('dd MMMM yyyy').format(
                              DateTime.parse(v['leads'][0]['user']['updated_at']
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
                          // '+91 8384389492',
                          "+91 ${v['leads'][0]['user']['mobile'].toString()}",
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
                            "+91 ${v['leads'][0]['user']['mobile'].toString()}",
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///My Shop Layout Code
  Widget myShopLayout(ctx, index, list) {
    var v = list;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Clr().white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.black26, width: 0.5),
            boxShadow: [
              BoxShadow(
                  color: Clr().hintColor.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 0)
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: CachedNetworkImage(
                        height: 55,
                        width: 55,
                        fit: BoxFit.cover,
                        imageUrl: v['shop_logo'].toString(),
                        placeholder: (context, url) =>
                            STM().loadingPlaceHolder(),
                        errorWidget: (context, url, error) => Image.network(
                            fit: BoxFit.cover,
                            'https://www.famunews.com/wp-content/themes/newsgamer/images/dummy.png'),
                      ),
                    ),
                    SizedBox(
                      width: Dim().d12,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Shop Name',
                            style: Sty().microText.copyWith(
                                color: Clr().hintColor,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: Dim().d4,
                          ),
                          Text(
                            // 'Shree Swami Samarth Jewelers Trust Limited',
                            v['shop_name'].toString(),
                            style: Sty().mediumText.copyWith(
                                color: Clr().textcolor,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(24),
                        bottomLeft: Radius.circular(24),
                      ),
                      color: Clr().white,
                    ),
                    width: MediaQuery.of(ctx).size.width,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            SizedBox(
                              width: Dim().d12,
                            ),
                            Text(
                              'Services',
                              style: Sty().mediumText.copyWith(
                                  color: Clr().textcolor,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              width: Dim().d12,
                            ),
                            // Container(
                            //   decoration: BoxDecoration(
                            //     color: const Color(0xffDEFFDE),
                            //     borderRadius: BorderRadius.circular(18),
                            //   ),
                            //   child: Padding(
                            //     padding: const EdgeInsets.symmetric(
                            //         horizontal: 24.0, vertical: 4.0),
                            //     child: Text(
                            //       'Active',
                            //       style: Sty().microText.copyWith(
                            //           color: Clr().green,
                            //           fontWeight: FontWeight.w500),
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            if (_selectIndex == index) {
                              setState(() {
                                _selectIndex = -1;
                              });
                            } else {
                              setState(() {
                                _selectIndex = index;
                              });
                            }
                          },
                          icon: Icon(_selectIndex == index
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_outlined),
                        ),
                      ],
                    ),
                  ),
                  _selectIndex == index ? serviceLayout(ctx, v) : Container(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// getLeads List Api
  void getLeads() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var result = await STM().allApi(
      apiname: "my_leads",
      ctx: ctx,
      load: true,
      loadtitle: Str().loading,
      token: sp.getString('token'),
      type: 'get',
    );
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(
        () {
          myLeadsList = result['data'];
          getShops();
        },
      );
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  /// getLeads List Api
  void getShops() async {
    //Output
    SharedPreferences sp = await SharedPreferences.getInstance();
    var result = await STM().allApi(
      apiname: "my_shops",
      ctx: ctx,
      token: sp.getString('token'),
      type: 'get',
    );
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(
        () {
          shopList = result['data'];
        },
      );
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  /// Services dropdown under MyShops Tab
  Widget serviceLayout(ctx, v) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            print(v['leads']);
            if (v['leads'].isNotEmpty) {
              STM().redirect2page(
                ctx,
                leadDetailsPage(
                  data: v['leads'],
                ),
              );
            }
          },
          child: Container(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(18),
                color: Color(0xffF5F5F5).withOpacity(0.5)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        child: SvgPicture.asset(
                          "assets/my_leads.svg",
                          color: Clr().textcolor,
                        ),
                      ),
                      SizedBox(
                        width: Dim().d12,
                      ),
                      Text(
                        'My Leads',
                        style: Sty().smallText.copyWith(color: Clr().textcolor),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Clr().grey,
                  )
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 1,
          width: MediaQuery.of(context).size.width,
          color: Color(0xffDCDCDC),
        ),
        InkWell(
          onTap: () {
            STM().redirect2page(
              ctx,
              ShopDetails(
                data: v,
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(18),
                color: Color(0xffF5F5F5).withOpacity(0.5)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                          width: 20,
                          child: SvgPicture.asset("assets/shop_details.svg")),
                      SizedBox(
                        width: Dim().d12,
                      ),
                      Text(
                        'Shop Details',
                        style: Sty().smallText.copyWith(color: Clr().textcolor),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Clr().grey,
                  )
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 1,
          width: MediaQuery.of(context).size.width,
          color: Color(0xffDCDCDC),
        ),
        InkWell(
          onTap: () {
            STM().redirect2page(
              ctx,
              ShopInfo(
                data: v,
              ),
            );
            print("Data :: $v");
          },
          child: Container(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(18),
                color: Color(0xffF5F5F5).withOpacity(0.5)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        child: SvgPicture.asset("assets/shop_information.svg"),
                      ),
                      SizedBox(
                        width: Dim().d12,
                      ),
                      Text(
                        'Shop Information',
                        style: Sty().smallText.copyWith(color: Clr().textcolor),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Clr().grey,
                  )
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 1,
          width: MediaQuery.of(context).size.width,
          color: Color(0xffDCDCDC),
        ),
        InkWell(
          onTap: () {
            STM().redirect2page(
              ctx,
              ShopCategory(
                data: v,
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(18),
                color: Color(0xffF5F5F5).withOpacity(0.5)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                          width: 20,
                          child: SvgPicture.asset("assets/shop_category.svg")),
                      SizedBox(
                        width: Dim().d12,
                      ),
                      Text(
                        'Shop Category',
                        style: Sty().smallText.copyWith(color: Clr().textcolor),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Clr().grey,
                  )
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 1,
          width: MediaQuery.of(context).size.width,
          color: Color(0xffDCDCDC),
        ),
        InkWell(
          onTap: () {
            STM().redirect2page(
              ctx,
              SelectTiming(
                data: v,
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(18),
                color: Color(0xffF5F5F5).withOpacity(0.5)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                          width: 20,
                          child: SvgPicture.asset("assets/shop_category.svg")),
                      SizedBox(
                        width: Dim().d12,
                      ),
                      Text(
                        'Shop Timmings',
                        style: Sty().smallText.copyWith(color: Clr().textcolor),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Clr().grey,
                  )
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 1,
          width: MediaQuery.of(context).size.width,
          color: Color(0xffDCDCDC),
        ),
        InkWell(
          onTap: () {
            STM().redirect2page(
              ctx,
              ContactDetails(
                data: v,
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(18),
                color: Color(0xffF5F5F5).withOpacity(0.5)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                          width: 22,
                          child:
                              SvgPicture.asset("assets/contact_details.svg")),
                      SizedBox(
                        width: Dim().d12,
                      ),
                      Text(
                        'Contact Details',
                        style: Sty().smallText.copyWith(color: Clr().textcolor),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Clr().grey,
                  )
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 1,
          width: MediaQuery.of(context).size.width,
          color: Color(0xffDCDCDC),
        ),
        InkWell(
          onTap: () {
            STM().redirect2page(
              ctx,
              ShopOffers(
                data: v,
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(18),
                color: Color(0xffF5F5F5).withOpacity(0.5)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                          width: 20,
                          child: SvgPicture.asset("assets/shop_offers.svg")),
                      SizedBox(
                        width: Dim().d12,
                      ),
                      Text(
                        'Shop Offers',
                        style: Sty().smallText.copyWith(color: Clr().textcolor),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Clr().grey,
                  )
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 1,
          width: MediaQuery.of(context).size.width,
          color: Color(0xffDCDCDC),
        ),
        InkWell(
          onTap: () {
            STM().redirect2page(
              ctx,
              ShopServices(
                data: v,
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(18),
                color: Color(0xffF5F5F5).withOpacity(0.5)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                          width: 20,
                          child: SvgPicture.asset("assets/shop_services.svg")),
                      SizedBox(
                        width: Dim().d12,
                      ),
                      Text(
                        'Shop Services',
                        style: Sty().smallText.copyWith(color: Clr().textcolor),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Clr().grey,
                  )
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 1,
          width: MediaQuery.of(context).size.width,
          color: Color(0xffDCDCDC),
        ),
        InkWell(
          onTap: () {
            STM().redirect2page(
              ctx,
              reviewdetailsPage(
                id: v['id'],
                type: 'update',
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(18),
                color: Color(0xffF5F5F5).withOpacity(0.5)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        child: SvgPicture.asset("assets/shop_revieews.svg",
                            color: Clr().textcolor),
                      ),
                      SizedBox(
                        width: Dim().d12,
                      ),
                      Text(
                        'Shop Reviews',
                        style: Sty().smallText.copyWith(color: Clr().textcolor),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Clr().grey,
                  )
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 1,
          width: MediaQuery.of(context).size.width,
          color: Color(0xffDCDCDC),
        ),
        InkWell(
          onTap: () {
            showDialog(
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
                        // Text('Remove Shop?',
                        //     style: Sty().largeText.copyWith(
                        //         color: Clr().primaryColor,
                        //         fontWeight: FontWeight.w800)),
                        // SizedBox(
                        //   height: Dim().d12,
                        // ),
                        Text('Are you sure want to remove shop?',
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
                                  child: Text(
                                    'Cancel',
                                    style: Sty().mediumText.copyWith(
                                          color:
                                              Clr().textcolor.withOpacity(0.8),
                                        ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: Dim().d12,
                            ),
                            check == false
                                ? Expanded(
                                    child: ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            check = true;
                                          });
                                          deleteShopService(v['id']);
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
                                          child: Text('Remove',
                                              style: Sty().mediumText.copyWith(
                                                  color: Clr().white)),
                                        )),
                                  )
                                : Container(),
                          ],
                        ),
                      ],
                    ),
                  );
                });
          },
          child: Container(
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                ),
                color: Color(0xffF5F5F5).withOpacity(0.5)),
            child: Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          SizedBox(
                              width: 20,
                              child:
                                  SvgPicture.asset("assets/delete_shop.svg")),
                          SizedBox(
                            width: Dim().d12,
                          ),
                          Text(
                            'Remove Shop',
                            style: Sty().smallText.copyWith(color: Clr().red),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Clr().red,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: Dim().d4,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  void deleteShopService(id) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var result = await STM().allApi(
      apiname: 'delete_shop',
      ctx: ctx,
      body: {
        "shop_id": id,
      },
      token: sp.getString('token'),
      type: 'post',
    );
    if (result['success'] == true) {
      STM().displayToast(result['message']);
      STM().successDialogWithReplace(context, result['message'], ShopListing());
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }
}
