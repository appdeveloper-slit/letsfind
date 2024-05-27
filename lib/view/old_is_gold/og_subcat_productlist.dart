import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:letsfind/data/static_method.dart';
import 'package:letsfind/values/dimens.dart';
import 'package:letsfind/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:letsfind/values/colors.dart';
import 'package:letsfind/values/strings.dart';

import 'og_subcat_details.dart';

class OGSubCatList extends StatefulWidget {
  final sCatID, sSubCatID, sName;

  const OGSubCatList(
      {super.key, required this.sCatID, required this.sSubCatID, this.sName});

  @override
  State<OGSubCatList> createState() => _OGSubCatListState();
}

class _OGSubCatListState extends State<OGSubCatList> {
  late BuildContext ctx;

  List<dynamic> productList = [];
  bool isLoading = false;
  String? sToken;

  int isSelected = -1;

  getsessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sToken = sp.getString("token" ?? "");
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getProducts();
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

    print("Cat ID :: ${widget.sCatID}");
    print("SubCat ID :: ${widget.sSubCatID}");
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
          isLoading
              ?
              // 'Fridge',
              widget.sName
              : "",
          style: Sty().largeText.copyWith(
                color: Clr().primaryColor,
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(Dim().d16),
        child: isLoading
            ? Column(
                children: [
                  productList.isNotEmpty
                      ? ListView.separated(
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: Dim().d6,
                            );
                          },
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: productList.length,
                          itemBuilder: (context, index) {
                            return cardLayout(ctx, index, productList);
                          },
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
                                  fontSize: 20,
                                  color: Clr().primaryColor,
                                  fontWeight: FontWeight.w600),
                            )),
                          ],
                        ),
                ],
              )
            : Container(),
      ),
    );
  }

  Widget cardLayout(ctx, index, list) {
    var v = productList[index];
    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Clr().shimmerColor.withOpacity(0.1),
            blurRadius: 12,
            spreadRadius: 1,
          )
        ],
      ),
      child: Card(
        color: Clr().white,
        elevation: 0,
        shape: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(18)),
            borderSide: BorderSide(
              color: Clr().borderColor,
            )),
        child: Padding(
          padding: EdgeInsets.all(Dim().d12),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      STM().replacePage(
                        ctx,
                        OGSubCatDetails(
                          sID: v['id'].toString(),
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
                        border: Border.all(
                          color: Clr().borderColor,
                        ),
                      ),
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
                    width: Dim().d12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              // 'Whirlpool 184 L 2 Star Direct Cool Single Door Refrigerator',
                              v['name'].toString(),
                              style: Sty().smallText.copyWith(
                                  color: Clr().textcolor,
                                  fontWeight: FontWeight.w500),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  favourite(id: v['id']);
                                });
                              },
                              child: v['is_favourite'] == true
                                  ? SvgPicture.asset(
                                      "assets/like.svg",
                                      color: const Color(0xffFF8000),
                                    )
                                  : SvgPicture.asset("assets/unlike.svg"),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Dim().d12,
                        ),
                        Text(
                          // '₹ 500',
                          '₹ ${v['price']}',
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
                            // 'Posted On: 21 April 2024',
                            'Posted On: ${v['posted_on']}',
                            style: Sty().microText.copyWith(
                                color: Color(0xff949494),
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     setState(() {
                  //       isSelected = index;
                  //     });
                  //   },
                  //   child: SvgPicture.asset(
                  //       isSelected == index
                  //           ? "assets/heart_filled.svg"
                  //           : "assets/heart_outlined.svg"),),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get Product List Api
  void getProducts() async {
    FormData body = FormData.fromMap({
      "category_id": widget.sCatID,
      "subcategory_id": widget.sSubCatID,
    });
    //Output
    var result = await STM()
        .postWithToken(context, Str().loading, "get_products", body, sToken);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(
        () {
          isLoading = true;
          productList = result['data']['products'];
          print("Product List :: ${productList}");
        },
      );
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  /// Get Product List Api
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
              OGSubCatList(
                sCatID: widget.sCatID,
                sSubCatID: widget.sSubCatID,
                sName: widget.sName.toString(),
              ));
          STM().displayToast(message);
        },
      );
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
