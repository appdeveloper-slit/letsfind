import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:letsfind/values/colors.dart';
import 'package:letsfind/values/dimens.dart';
import 'package:letsfind/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/static_method.dart';
import '../../values/strings.dart';
import 'og_subcat_productlist.dart';

class OGCategory extends StatefulWidget {
  final slist, sName, sID;

  const OGCategory({super.key, this.slist, this.sName, required this.sID});

  @override
  State<OGCategory> createState() => _OGCategoryState();
}

class _OGCategoryState extends State<OGCategory> {
  late BuildContext ctx;

  String? sToken;

  List<dynamic> subCatList = [];
  bool isLoaded = false;
  int selectedSlider = 0;
  List sliderlist = [];

  getSessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sToken = sp.getString("token" ?? "");
    STM().checkInternet(context, widget).then(
      (value) {
        if (value) {
          getSubCategory();
        }
      },
    );
  }

  @override
  void initState() {
    getSessionData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;

    print("Cat ID :: ${widget.sID}");

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
        title: Text(
          // 'Cars',
          widget.sName,
          style: Sty().largeText.copyWith(
                color: Clr().primaryColor,
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(Dim().d16),
        child: isLoaded
            ? Column(
                children: [
                  if (sliderlist.isNotEmpty) sliderLayout(ctx),
                  subCatList.isNotEmpty
                      ? Card(
                          elevation: 0,
                          surfaceTintColor: Clr().white,
                          color: Clr().white,
                          shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(Dim().d16),
                            borderSide: BorderSide(
                              color: Clr().borderColor,
                            ),
                          ),
                          child: ListView.separated(
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                child: Divider(
                                  color: Clr().borderColor,
                                ),
                                height: Dim().d6,
                              );
                            },
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: subCatList.length,
                            itemBuilder: (context, index) {
                              return cardLayout(ctx, index, subCatList);
                            },
                          ),
                        )
                      : Column(
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
                                'No Sub-Categories Found',
                                style: Sty().mediumText.copyWith(
                                    fontSize: 20,
                                    color: Clr().primaryColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        ),
                ],
              )
            : Container(),
      ),
    );
  }

  Widget cardLayout(ctx, index, list) {
    var v = list[index];

    return Column(
      children: [
        InkWell(
          onTap: () {
            STM().redirect2page(
                ctx,
                OGSubCatList(
                    sCatID: widget.sID,
                    sSubCatID: v['id'].toString(),
                    sName: v['name'].toString()));
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  // 'BMW',
                  v['name'].toString(),
                  style: Sty().smallText.copyWith(
                      fontWeight: FontWeight.w500, color: Clr().textcolor),
                ),
                Icon(
                  Icons.arrow_forward_ios_sharp,
                  size: 14,
                )
              ],
            ),
          ),
        ),
      ],
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
      items: sliderlist.map((url) {
        return Builder(
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
        );
      }).toList(),
    );
  }

  /// get Sub Categories List Api
  void getSubCategory() async {
    FormData body = FormData.fromMap({
      "category_id": widget.sID,
    });
    //Output
    var result = await STM().postWithToken(
        ctx, Str().loading, "old_gold_get_subcategories", body, sToken);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(
        () {
          isLoaded = true;
          subCatList = result['data']['subcategories'];
          sliderlist = result['data']['banners'];
        },
      );
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
