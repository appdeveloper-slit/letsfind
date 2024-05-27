import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:letsfind/values/colors.dart';
import 'package:letsfind/values/dimens.dart';
import 'package:letsfind/values/strings.dart';
import 'package:letsfind/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/static_method.dart';
import 'add_images.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  late BuildContext ctx;

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController descriptionCtrl = TextEditingController();
  TextEditingController priceCtrl = TextEditingController();

  List<dynamic> catList = [];
  List<dynamic> subCatList = [];

  bool isFocused = false;
  bool isFocused2 = false;
  bool isFocused3 = false;

  String? sCat, sSubCat;

  var editCat, editSubCat, sProductID, sToken;

  getsessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();

    sToken = sp.getString("token") ?? "";
    print("Token :: ${sToken}");
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getCategory();
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
                text: '1 ',
                style: Sty().smallText.copyWith(
                      color: Color(0xffFF8000),
                      fontFamily: 'SP',
                      fontWeight: FontWeight.w600,
                    ),
              ),
              TextSpan(
                text: 'of 3',
                style: Sty().smallText.copyWith(
                      color: Clr().textcolor,
                      fontFamily: 'SP',
                      fontWeight: FontWeight.w400,
                    ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dim().d16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      borderSide:
                          BorderSide(color: Clr().borderColor.withOpacity(0.8)),
                      borderRadius: BorderRadius.circular(18)),
                  color: Clr().white,
                  surfaceTintColor: Clr().white,
                  child: Padding(
                    padding: EdgeInsets.all(Dim().d16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Product Details',
                          style: Sty().largeText.copyWith(
                              color: Clr().primaryColor,
                              fontSize: 38,
                              fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          'Fill in the fields to showcase your product',
                          textAlign: TextAlign.center,
                          style: Sty().mediumText.copyWith(
                                color: Clr().textcolor,
                                fontFamily: 'SP',
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        SizedBox(
                          height: Dim().d32,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Main Category',
                              style: Sty().microText.copyWith(
                                  color: Clr().textcolor,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Dim().d4,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(55),
                              border: Border.all(color: Clr().borderColor)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButtonFormField<String>(
                              borderRadius: BorderRadius.circular(10),
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Clr().white,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Clr().primaryColor),
                                      borderRadius: BorderRadius.circular(55)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(55),
                                      borderSide: BorderSide(
                                          color: Clr().borderColor,
                                          width: 0.5)),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: Dim().d20,
                                    vertical: Dim().d12,
                                  )),
                              // value: sCity,
                              isExpanded: true,
                              hint: Text(
                                sCat ?? 'Select Category',
                                style: Sty().smallText.copyWith(
                                      color: Clr().hintColor,
                                    ),
                              ),
                              icon: SvgPicture.asset(
                                "assets/down_arrow.svg",
                                color: Clr().textcolor,
                              ),
                              // style: TextStyle(color: Color(0xff2D2D2D)),
                              items: catList.map((string) {
                                return DropdownMenuItem<String>(
                                  value: string['id'].toString(),
                                  child: Text(string['name'].toString(),
                                      style: Sty().smallText.copyWith(
                                            color: Clr().black,
                                          )),
                                );
                              }).toList(),
                              onChanged: (v) {
                                setState(() {
                                  int position = catList.indexWhere(
                                      (e) => e['id'].toString() == v);
                                  sCat = v;
                                  editCat = sCat;
                                  print('State id = ${sCat}');
                                  print('Edit State = ${editCat}');
                                  sSubCat = null;
                                  editSubCat = null;
                                  subCatList =
                                      catList[position]['subcategories'];
                                });
                              },
                              // onChanged: (v) {
                              //   setState(() {
                              //     sType = v;
                              //     print("sType :: $sType");
                              //   });
                              // },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Dim().d20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Sub Category',
                              style: Sty().microText.copyWith(
                                  color: Clr().textcolor,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Dim().d4,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(55),
                              border: Border.all(color: Clr().borderColor)),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButtonFormField<String>(
                              borderRadius: BorderRadius.circular(10),
                              decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Clr().white,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Clr().primaryColor),
                                      borderRadius: BorderRadius.circular(55)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(55),
                                      borderSide: BorderSide(
                                          color: Clr().borderColor,
                                          width: 0.5)),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: Dim().d20,
                                    vertical: Dim().d12,
                                  )),
                              // value: sCity,
                              isExpanded: true,
                              hint: Text(
                                sSubCat ??
                                    'Select Sub-category (Refrigerators, AC,...)',
                                style: Sty().smallText.copyWith(
                                      color: Clr().hintColor,
                                    ),
                              ),
                              icon: SvgPicture.asset(
                                "assets/down_arrow.svg",
                                color: Clr().textcolor,
                              ),
                              // style: TextStyle(color: Color(0xff2D2D2D)),
                              items: subCatList.map((string) {
                                return DropdownMenuItem<String>(
                                  value: string['id'].toString(),
                                  child: Text(string['name'].toString(),
                                      style: Sty().smallText.copyWith(
                                            color: Clr().black,
                                          )),
                                );
                              }).toList(),
                              onChanged: (v) {
                                // STM().redirect2page(ctx, Home());
                                setState(() {
                                  sSubCat = v!;
                                  editSubCat = sSubCat;
                                  print("Edit sSubCat :: $sSubCat");
                                });
                              },
                              // onChanged: (v) {
                              //   setState(() {
                              //     sSubType = v;
                              //     print("sSubType :: $sSubType");
                              //   });
                              // },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Dim().d20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Product Title',
                              style: Sty().microText.copyWith(
                                  color: Clr().textcolor,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Dim().d4,
                        ),
                        Focus(
                          onFocusChange: (hasFocus) {
                            setState(() {
                              isFocused = hasFocus;
                            });
                          },
                          child: TextFormField(
                            controller: nameCtrl,
                            onTapOutside: (event) {
                              FocusScope.of(context).unfocus();
                            },
                            cursorColor: Clr().textcolorsgray,
                            style: Sty().smallText,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.done,
                            obscureText: false,
                            decoration: Sty().textFieldOutlineStyle.copyWith(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(width: 0.1),
                                      borderRadius: BorderRadius.circular(55)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(55),
                                    borderSide: BorderSide(
                                      color:
                                          nameCtrl.text.isNotEmpty || isFocused
                                              ? Clr().primaryColor
                                              : Clr().hintColor,
                                    ),
                                  ),
                                  hintStyle: Sty().smallText.copyWith(
                                      color: Clr().grey, fontFamily: "SF"),
                                  hintText: "Enter Name of Product",
                                  counterText: "",
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: Dim().d20,
                                    vertical: Dim().d14,
                                  ),
                                ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return Str().invalidName;
                              } else {
                                return null;
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: Dim().d20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Product Description',
                              style: Sty().microText.copyWith(
                                  color: Clr().textcolor,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Dim().d4,
                        ),
                        Focus(
                          onFocusChange: (hasFocus) {
                            setState(() {
                              isFocused2 = hasFocus;
                            });
                          },
                          child: TextFormField(
                            controller: descriptionCtrl,
                            onTapOutside: (event) {
                              FocusScope.of(context).unfocus();
                            },
                            cursorColor: Clr().textcolorsgray,
                            style: Sty().smallText,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.done,
                            obscureText: false,
                            maxLines: 3,
                            decoration: Sty().textFieldOutlineStyle.copyWith(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(width: 0.1),
                                      borderRadius: BorderRadius.circular(18)),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: BorderSide(
                                      color: Clr().errorRed,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: BorderSide(
                                      color: Clr().errorRed,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: BorderSide(
                                      color: descriptionCtrl.text.isNotEmpty ||
                                              isFocused2
                                          ? Clr().primaryColor
                                          : Clr().hintColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: BorderSide(
                                      color: Clr().primaryColor,
                                    ),
                                  ),
                                  hintStyle: Sty().smallText.copyWith(
                                      color: Clr().grey, fontFamily: "SF"),
                                  hintText: "Enter Product Description",
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
                        SizedBox(
                          height: Dim().d20,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Product Price',
                              style: Sty().microText.copyWith(
                                  color: Clr().textcolor,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: Dim().d4,
                        ),
                        Focus(
                          onFocusChange: (hasFocus) {
                            setState(() {
                              isFocused3 = hasFocus;
                            });
                          },
                          child: TextFormField(
                            controller: priceCtrl,
                            onTapOutside: (event) {
                              FocusScope.of(context).unfocus();
                            },
                            cursorColor: Clr().textcolorsgray,
                            style: Sty().smallText,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            obscureText: false,
                            decoration: Sty().textFieldOutlineStyle.copyWith(
                                  prefixText: "₹",
                                  prefixStyle: Sty().smallText,
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(width: 0.1),
                                      borderRadius: BorderRadius.circular(55)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(55),
                                    borderSide: BorderSide(
                                      color: priceCtrl.text.isNotEmpty ||
                                              isFocused2
                                          ? Clr().primaryColor
                                          : Clr().hintColor,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(55),
                                    borderSide: BorderSide(
                                      color: Clr().primaryColor,
                                    ),
                                  ),
                                  hintStyle: Sty().smallText.copyWith(
                                      color: Clr().grey, fontFamily: "SF"),
                                  hintText: "Enter Amount of Product",
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
                        SizedBox(
                          height: Dim().d8,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: Dim().d40,
              ),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0, backgroundColor: Clr().primaryColor),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        STM().checkInternet(context, widget).then(
                          (value) {
                            if (value) {
                              addProduct();
                            }
                          },
                        );
                      }
                    },
                    child: Text(
                      'Next',
                      style: Sty().mediumText.copyWith(color: Clr().white),
                    )),
              ),
              SizedBox(
                height: Dim().d32,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// get Categories List Api
  void getCategory() async {
    //Output
    var result = await STM()
        .getwithToken(context, Str().loading, "old_gold_get_categories", sToken);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(
        () {
          catList = result['data']['categories'];
          subCatList = catList[0]['subcategories'];
          print("CatList :: $catList");
        },
      );
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  /// Add Product Api
  void addProduct() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      "category_id": sCat,
      "subcategory_id": sSubCat,
      "name": nameCtrl.text,
      "description": descriptionCtrl.text,
      "price": priceCtrl.text,
    });

    //Output
    var result = await STM().postWithToken(
        context, Str().loading, "add_old_gold_product", body, sToken);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(
        () {
          STM().displayToast(message);
          sp.setString("product_id", result['data']['product_id'].toString());
          sProductID = result['data']['product_id'].toString();
          STM().replacePage(
              ctx,
              AddImages(
                sProductID: sProductID,
              ));
        },
      );
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
