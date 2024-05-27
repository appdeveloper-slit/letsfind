import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:letsfind/values/colors.dart';
import 'package:letsfind/values/dimens.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/static_method.dart';
import '../../values/strings.dart';
import '../../values/styles.dart';
import 'add_images.dart';
import 'add_product.dart';
import 'edit_images.dart';
import 'edit_product.dart';
import 'lead_details.dart';
import 'owner_contact_details.dart';

class Subscription extends StatefulWidget {
  const Subscription({Key? key}) : super(key: key);

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription>
    with SingleTickerProviderStateMixin {
  late BuildContext ctx;

  int _selectIndex = -1;

  List<dynamic> productsList = [];

  List<dynamic> myLeadsList = [];

  late TabController _tabController;

  String? sToken;

  getsessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sToken = sp.getString("token") ?? "";
    // sToken = sp.getString("token") ?? "";
    print("Token :: ${sToken}");
    STM().checkInternet(context, widget).then(
      (value) {
        if (value) {
          getLeads();
          myProducts();
        }
      },
    );
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
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

    return Scaffold(
        backgroundColor: Clr().background,
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
          title: InkWell(
            onTap: () {
              // STM().redirect2page(ctx, Demo());
            },
            child: Text(
              'Subscription Plans',
              style: Sty().largeText.copyWith(
                    color: Clr().primaryColor,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              Tab(text: 'Active Plans'),
              Tab(text: 'Other Plans'),
            ],
          ),
          Expanded(
            child: TabBarView(controller: _tabController, children: [
              Padding(
                padding: EdgeInsets.all(Dim().d16),
                child: Expanded(
                  child: ListView.builder(
                    itemCount: myLeadsList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var v = myLeadsList[index];
                      return leadsLayout(ctx, index, v);
                    },
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dim().d16, vertical: Dim().d16),
                    child: InkWell(
                      onTap: () {
                        STM().redirect2page(ctx, AddProduct());
                      },
                      child: DottedBorder(
                        borderType: BorderType.RRect,
                        dashPattern: [8, 10],
                        color: Clr().primaryColor,
                        radius: Radius.circular(55),
                        strokeWidth: 0.8,
                        padding: EdgeInsets.all(6),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          child: Container(
                            height: 30,
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                'Add New  Product',
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
                  productsList.isNotEmpty
                      ? Expanded(
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemCount: productsList.length,
                            padding: EdgeInsets.all(Dim().d12),
                            shrinkWrap: true,
                            itemBuilder: (ctx, index) {
                              return myShopLayout(ctx, index, productsList);
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: Dim().d12,
                              );
                            },
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: Dim().d160,
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
                              "No Products Found",
                              style: Sty().mediumText.copyWith(
                                    color: Clr().primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                            )),
                          ],
                        ),
                  SizedBox(
                    height: Dim().d12,
                  ),
                ],
              ),
            ]),
          )
        ]));
  }

  ///My Shop Layout Code
  Widget myShopLayout(ctx, index, list) {
    var v = list[index];
    return Column(
      children: [
        Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(Dim().d16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          height: 55,
                          width: 55,
                          fit: BoxFit.cover,
                          imageUrl: v['images'][0]['image'].toString(),
                          // imageUrl: "https://www.famunews.com/wp-content/themes/newsgamer/images/dummy.png",
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
                        child: Text(
                          // 'Shree Swami Samarth Jewelers Trust Limited',
                          v['name'].toString(),
                          style: Sty().mediumText.copyWith(
                              color: Clr().textcolor,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                ),
                _selectIndex == index
                    ? Column(
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
                            child: Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: Dim().d16),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectIndex = index;
                                    // _isExpanded = !_isExpanded;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 16.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Wrap(
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          Text(
                                            'Services',
                                            style: Sty().mediumText.copyWith(
                                                color: Clr().textcolor,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            width: Dim().d12,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: const Color(0xffDEFFDE),
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 24.0,
                                                  vertical: 4.0),
                                              child: Text(
                                                'Active',
                                                style: Sty().microText.copyWith(
                                                    color: Clr().green,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SvgPicture.asset(
                                        "assets/dropdown_arrow_up.svg",
                                        color: Clr().textcolor,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          serviceLayout(
                            ctx,
                            list: v,
                            id: v['id'].toString(),
                          ),
                        ],
                      )
                    : Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(24),
                            bottomLeft: Radius.circular(24),
                          ),
                          color: Color(0xffF5F5F5),
                        ),
                        width: MediaQuery.of(ctx).size.width,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dim().d16, vertical: Dim().d8),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectIndex = index;
                                  });
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        Text(
                                          'Services',
                                          style: Sty().mediumText.copyWith(
                                              color: Clr().textcolor,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          width: Dim().d12,
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xffDEFFDE),
                                            borderRadius:
                                                BorderRadius.circular(18),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 24.0,
                                                vertical: 4.0),
                                            child: Text(
                                              'Active',
                                              style: Sty().microText.copyWith(
                                                  color: Clr().green,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SvgPicture.asset(
                                      "assets/dropdown_arrow.svg",
                                      color: Clr().textcolor,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Services dropdown under MyShops Tab
  Widget serviceLayout(ctx, {id, list}) {
    return Column(
      children: [
        const Divider(height: 0),
        InkWell(
          onTap: () {
            STM().redirect2page(
                ctx,
                EditProduct(
                  sProductList: list,
                ));
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
                      Container(
                        width: 20,
                        child: SvgPicture.asset(
                          "assets/pro_details.svg",
                          color: Clr().textcolor,
                        ),
                      ),
                      SizedBox(
                        width: Dim().d12,
                      ),
                      Text(
                        'Product Details',
                        style: Sty().smallText.copyWith(
                            color: Clr().textcolor,
                            fontWeight: FontWeight.w500),
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
              EditImages(
                sProductList: list['images'],
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
                      Container(child: SvgPicture.asset("assets/photos.svg")),
                      SizedBox(
                        width: Dim().d12,
                      ),
                      Text(
                        'Product Photos',
                        style: Sty().smallText.copyWith(
                            color: Clr().textcolor,
                            fontWeight: FontWeight.w500),
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
              OwnerContact(
                sContact: list['contact'],
                sType: "edit",
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
                      Container(
                          width: 20,
                          child: SvgPicture.asset("assets/contact.svg")),
                      SizedBox(
                        width: Dim().d12,
                      ),
                      Text(
                        'Contact Details',
                        style: Sty().smallText.copyWith(
                            color: Clr().textcolor,
                            fontWeight: FontWeight.w500),
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
            STM().redirect2page(ctx, OwnerContact());
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
                      Container(
                          width: 20,
                          child: SvgPicture.asset("assets/subscription.svg")),
                      SizedBox(
                        width: Dim().d12,
                      ),
                      Text(
                        'Subscription',
                        style: Sty().smallText.copyWith(
                            color: Clr().textcolor,
                            fontWeight: FontWeight.w500),
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
      ],
    );
  }

  /// My Products Api
  void myProducts() async {
    var result =
        await STM().getwithToken(ctx, Str().loading, 'my_products', sToken);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(() {
        productsList = result['data'];
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  ///LeadsLayout Code
  Widget leadsLayout(ctx, index, list) {
    var v = list;
    return Container(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
              color: Clr().borderColor.withOpacity(0.1),
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
              Text(
                'Free',
                style: Sty().smallText.copyWith(
                    color: Clr().primaryColor, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: Dim().d4,
              ),
              Text(
                '₹0',
                style: Sty().smallText.copyWith(
                    color: Clr().primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: Dim().d8,
              ),
              Divider(),
              SizedBox(
                height: Dim().d12,
              ),
              Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: 10,
                    color: Clr().grey,
                  ),

                ],
              ),
              SizedBox(
                height: Dim().d20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// getLeads List Api
  void getLeads() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var result = await STM()
        .getwithToken(ctx, Str().loading, "my_product_leads", sToken);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(
        () {
          myLeadsList = result['data'];
          print("ooooo $myLeadsList");
        },
      );
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
