// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:letsfind/controller/subcategorycontroller.dart';
import 'package:letsfind/values/colors.dart';
import 'package:letsfind/values/dimens.dart';
import 'package:letsfind/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/static_method.dart';
import '../../values/colors.dart';
import '../../values/dimens.dart';
import '../../values/strings.dart';
import '../../values/styles.dart';
import '../shop_listing.dart';

class ShopServices extends StatefulWidget {
  final data;
  const ShopServices({super.key, this.data});
  @override
  State<ShopServices> createState() => _ShopServicesState();
}

class _ShopServicesState extends State<ShopServices> {
  late BuildContext ctx;

  bool isFocused = false;

  List<dynamic> serviceList = [];

  String? sShopID, sToken;

  final _formKey = GlobalKey<FormState>();
  TextEditingController serviceCtrl = TextEditingController();

  List<Map<String, dynamic>> servicesWidgetList = [];

  getsessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sShopID = sp.getString("shop_id") ?? "";
    sToken = sp.getString("token") ?? "";
    print("Shop ID :: $sShopID");
    if (widget.data != null) {
      servicesWidgetList.clear();
      for (int a = 0; a < widget.data['shop_service'].length; a++) {
        setState(() {
          servicesWidgetList.add({
            'id': widget.data['shop_service'][a]['id'],
            'shop_id': widget.data['shop_service'][a]['shop_id'],
            'service': TextEditingController(
                text: widget.data['shop_service'][a]['name'].toString()),
          });
        });
      }
    }
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
        widget.data != null
            ? STM().replacePage(ctx, const ShopListing())
            : showDialog(
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
                        Text('Cancel Process?',
                            style: Sty().largeText.copyWith(
                                color: Clr().primaryColor,
                                fontWeight: FontWeight.w800)),
                        SizedBox(
                          height: Dim().d12,
                        ),
                        Text('Are you sure want to cancel this process ?',
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
                                  child: Text('Cancel',
                                      style: Sty().mediumText.copyWith(
                                          color: Clr()
                                              .textcolor
                                              .withOpacity(0.8))),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: Dim().d12,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                  onPressed: () async {
                                    STM().replacePage(ctx, const ShopListing());
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
                                    child: Text('Back',
                                        style: Sty()
                                            .mediumText
                                            .copyWith(color: Clr().white)),
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                });
        return false;
      },
      child: Scaffold(
        backgroundColor: Clr().background,
        appBar: AppBar(
          forceMaterialTransparency: true,
          surfaceTintColor: Clr().white,
          backgroundColor: Clr().white,
          leading: InkWell(
            onTap: () {
              widget.data != null
                  ? STM().replacePage(ctx, const ShopListing())
                  : showDialog(
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
                              Text('Cancel Process?',
                                  style: Sty().largeText.copyWith(
                                      color: Clr().primaryColor,
                                      fontWeight: FontWeight.w800)),
                              SizedBox(
                                height: Dim().d12,
                              ),
                              Text('Are you sure want to cancel this process ?',
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
                                        child: Text('Cancel',
                                            style: Sty().mediumText.copyWith(
                                                color: Clr()
                                                    .textcolor
                                                    .withOpacity(0.8))),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Dim().d12,
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          STM().replacePage(
                                              ctx, const ShopListing());
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
                                          child: Text('Back',
                                              style: Sty().mediumText.copyWith(
                                                  color: Clr().white)),
                                        )),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
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
                  padding: EdgeInsets.all(Dim().d8),
                  child: SvgPicture.asset(
                    "assets/back.svg",
                  ),
                ),
              ),
            ),
          ),
          title: RichText(
            text: TextSpan(
              text: "Step ",
              // text: '₹10,000 ',
              style: Sty().smallText.copyWith(
                    color: Clr().textcolor,
                    fontFamily: 'SP',
                    fontWeight: FontWeight.w400,
                  ),
              children: [
                TextSpan(
                  text: '6 ',
                  style: Sty().smallText.copyWith(
                        color: Color(0xffFF8000),
                        fontFamily: 'SP',
                        fontWeight: FontWeight.w600,
                      ),
                ),
                TextSpan(
                  text: 'of 6',
                  style: Sty().smallText.copyWith(
                        color: Clr().textcolor,
                        fontFamily: 'SP',
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ],
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Dim().d16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                              color: Clr().borderColor.withOpacity(0.3),
                              blurRadius: 5,
                              spreadRadius: 0)
                        ],
                      ),
                      child: Card(
                        elevation: 0,
                        shape: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Clr().borderColor.withOpacity(0.8)),
                            borderRadius: BorderRadius.circular(18)),
                        color: Clr().white,
                        surfaceTintColor: Clr().white,
                        child: Padding(
                          padding: EdgeInsets.all(Dim().d16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Shop Services',
                                style: Sty().largeText.copyWith(
                                    color: Clr().primaryColor,
                                    fontSize: 38,
                                    fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                'Add Shop Services',
                                textAlign: TextAlign.center,
                                style: Sty().mediumText.copyWith(
                                    color: Clr().textcolor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              SizedBox(
                                height: Dim().d20,
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    servicesWidgetList.add({
                                      'id': null,
                                      'shop_id': sShopID,
                                      'service':
                                          TextEditingController(text: ''),
                                    });
                                  });
                                },
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  dashPattern: [8, 10],
                                  color: Clr().textcolor,
                                  radius: Radius.circular(55),
                                  strokeWidth: 0.8,
                                  padding: EdgeInsets.all(6),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                    child: Container(
                                      height: 30,
                                      width: double.infinity,
                                      child: Center(
                                        child: Text(
                                          'Add Service',
                                          style: Sty().smallText.copyWith(
                                              color: Color(0xff464646),
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                ListView.separated(
                  itemCount: servicesWidgetList.length,
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (ctx, index) {
                    return addService(
                        ctx: ctx, index: index, list: servicesWidgetList);
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: Dim().d12,
                    );
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Clr().primaryColor),
                          onPressed: () {
                            submitStep6();
                          },
                          child: Text(
                            widget.data != null ? 'Update' : 'Submit',
                            style:
                                Sty().mediumText.copyWith(color: Clr().white),
                          )),
                    ),
                    SizedBox(
                      height: Dim().d32,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addService({ctx, index, list}) {
    var v = list;
    return Container(
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
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    widget.data != null
                        ? deleteShopService(list[index]['id'])
                        : null;
                    setState(() {
                      list.removeAt(index);
                    });
                  },
                  child: Container(
                    height: 18,
                    width: 18,
                    decoration: BoxDecoration(
                      color: Clr().white,
                      border: Border.all(color: Clr().red),
                      borderRadius: BorderRadius.circular(55),
                    ),
                    child: Icon(Icons.close, size: 12, color: Clr().red),
                  ),
                ),
              ),
              Text(
                'Services ${index + 1}',
                style: Sty()
                    .largeText
                    .copyWith(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: Dim().d8,
              ),
              Focus(
                onFocusChange: (hasFocus) {
                  setState(() {
                    isFocused = hasFocus;
                  });
                },
                child: TextFormField(
                  controller: list[index]['service'],
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  cursorColor: Clr().textcolorsgray,
                  style: Sty().smallText,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  obscureText: false,
                  maxLines: 2,
                  decoration: Sty().textFieldOutlineStyle.copyWith(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 0.1),
                            borderRadius: BorderRadius.circular(16)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: serviceCtrl.text.isNotEmpty || isFocused
                                ? Clr().primaryColor
                                : Clr().hintColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color:
                                // mobileCtrl
                                //     .text.isNotEmpty ||
                                isFocused
                                    ? Clr().primaryColor
                                    : Clr().hintColor,
                          ),
                        ),
                        hintStyle: Sty()
                            .smallText
                            .copyWith(color: Clr().grey, fontFamily: "SF"),
                        hintText: "Enter Your Services",
                        counterText: "",
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: Dim().d20,
                          vertical: Dim().d14,
                        ),
                      ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return Str().invalidEmpty;
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///Submit Step 6
  void submitStep6() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    // FormData body = FormData.fromMap({
    //   "shop_id": sShopID,
    //   "category_id": sCategory,
    //   "subcategory_id": sSubCategory,
    //   "service_images": productImage,
    // });
    List servicesList = [];
    for (int a = 0; a < servicesWidgetList.length; a++) {
      setState(() {
        servicesList.add({
          'id': servicesWidgetList[a]['id'],
          'shop_id': servicesWidgetList[a]['shop_id'],
          'service': servicesWidgetList[a]['service'].text.toString(),
        });
      });
    }
    var body = {
      "shop_id": widget.data != null ? widget.data['id'] : sShopID,
      "services": servicesList,
    };
    print(body);
    var result = await STM().allApi(
        ctx: ctx,
        loadtitle: Str().loading,
        apiname: 'step6',
        body: body,
        token: sp.getString('token'),
        load: true,
        type: 'post');
    var success = result['success'];
    var message = result['message'];
    if (success) {
      if (widget.data != null) {
        STM().successDialogWithReplace(ctx, message, const ShopListing());
      } else {
        setState(() {
          STM().displayToast(message);
          STM().successDialogWithReplace(ctx, message, const ShopListing());
        });
      }
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  void deleteShopService(id) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var result = await STM().allApi(
      apiname: 'delete_shop_service',
      ctx: ctx,
      body: {
        "shop_service_id": id,
      },
      token: sp.getString('token'),
      type: 'post',
    );
    if (result['success'] == true) {
      STM().displayToast(result['message']);
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }
}
