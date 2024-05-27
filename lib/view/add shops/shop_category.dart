// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letsfind/values/colors.dart';
import 'package:letsfind/values/dimens.dart';
import 'package:letsfind/values/styles.dart';
import 'package:letsfind/view/imageview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/static_method.dart';
import '../../values/colors.dart';
import '../../values/dimens.dart';
import '../../values/strings.dart';
import '../../values/styles.dart';
import '../shop_listing.dart';
import 'select_timmings.dart';

class ShopCategory extends StatefulWidget {
  final data;

  const ShopCategory({super.key, this.data});

  @override
  State<ShopCategory> createState() => _ShopCategoryState();
}

class _ShopCategoryState extends State<ShopCategory> {
  late BuildContext ctx;

  File? imageFile;
  String? productImage;
  bool isFocused = false;

  List<File> _selectedImages = []; // List of local images
  List<dynamic> _imageUrlList = []; // List of URL images
  List<dynamic> base64List = []; // List of URL images

  Future<void> _pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      allowMultiple: true,
      // type: FileType.image,
      // allowMultiple: true,
    );

    if (result != null) {
      List<File> pickedImages =
          result.files.map((file) => File(file.path!)).toList();

      setState(() {
        _selectedImages.addAll(pickedImages);
      });
    } else {
      // User canceled the file picking
    }
  }

  void _removeImageUrl(int index) {
    setState(() {
      _imageUrlList.removeAt(index);
      // _imageUrlList.removeAt(index - _selectedImages.length);
    });
  }

  String fileToBase64(File file) {
    List<int> imageBytes = file.readAsBytesSync();
    return base64Encode(imageBytes);
  }

// Function to convert a list of Files to base64
  List<String> filesToBase64(List<File> files) {
    return files.map((file) => fileToBase64(file)).toList();
  }

  var editState, editCity;

  List categoryList = [];

  List subCategoryList = [];

  String? sCategory, sCategoryID, sSubCategory, sSubCategoryID, sShopID, sToken;

  getsessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sShopID = sp.getString("shop_id") ?? "";
    sToken = sp.getString("token") ?? "";
    print("Shop ID :: $sShopID");
    STM().checkInternet(context, widget).then(
      (value) {
        if (value) {
          getCategories();
        }
      },
    );
  }

  @override
  void initState() {
    getsessionData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;

    print("Data :: ${widget.data}");

    Uint8List ProductImages = base64Decode(productImage.toString());

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
                  text: '3 ',
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
          child: Column(
            children: [
              Column(
                children: [
                  Center(
                    child: Container(
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
                                'Shop Category',
                                style: Sty().largeText.copyWith(
                                    color: Clr().primaryColor,
                                    fontSize: 38,
                                    fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              Text(
                                'Select category of your shop and add images',
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
                                    'Category',
                                    style: Sty().microText.copyWith(
                                        color: Clr().textcolor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: Dim().d8,
                              ),
                              DropdownButtonHideUnderline(
                                child: DropdownButtonFormField<String>(
                                  borderRadius: BorderRadius.circular(10),
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Clr().white,
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Clr().primaryColor),
                                          borderRadius:
                                              BorderRadius.circular(55)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(55),
                                          borderSide: BorderSide(
                                              color: Clr().borderColor,
                                              width: 0.5)),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: Dim().d12,
                                        vertical: Dim().d12,
                                      )),
                                  // value: sState,
                                  isExpanded: true,
                                  hint: Text(
                                    sCategory ?? 'Select Category',
                                    style: Sty().smallText.copyWith(
                                          color: Clr().textcolor,
                                        ),
                                  ),
                                  icon: SvgPicture.asset(
                                    "assets/down_arrow.svg",
                                    color: Clr().textcolor,
                                  ),
                                  style: TextStyle(color: Color(0xff2D2D2D)),
                                  items: categoryList.map((string) {
                                    return DropdownMenuItem<String>(
                                      value: string['id'].toString(),
                                      child: Text(
                                          string['name'],
                                          style: Sty().mediumText.copyWith(
                                                color: Clr().black,
                                              )),
                                    );
                                  }).toList(),
                                  onChanged: (v) {
                                    setState(() {
                                      int pos = categoryList.indexWhere((e) =>
                                          e['id'].toString() == v.toString());
                                      sCategoryID = v;
                                      sCategory = categoryList[pos]['name'];
                                      print(categoryList[pos]);
                                      sSubCategory = null;
                                      subCategoryList = categoryList[pos]['subcategories'];
                                    });
                                  },
                                ),
                              ),
                              if (sCategory != null)
                                SizedBox(
                                  height: Dim().d20,
                                ),
                              if (sCategory != null)
                                Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Sub-Category',
                                      style: Sty().microText.copyWith(
                                          color: Clr().textcolor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ),
                              if (sCategory != null)
                                SizedBox(
                                  height: Dim().d8,
                                ),
                              if (sCategory != null)
                                DropdownButtonFormField<dynamic>(
                                  value: sSubCategory,
                                  style: Sty()
                                      .mediumText
                                      .copyWith(fontWeight: FontWeight.w400),
                                  items: subCategoryList
                                      .map<DropdownMenuItem<dynamic>>(
                                          (subcategory) {
                                    return DropdownMenuItem(
                                      value: subcategory['name'],
                                      child: Text(subcategory['name']),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      sSubCategory = value.toString();
                                      int pos = subCategoryList.indexWhere(
                                          (e) => e['name'] == value);
                                      sSubCategoryID =
                                          subCategoryList[pos]['id'].toString();
                                    });
                                  },
                                  hint: Text(
                                    'Select Sub-category (Food / IT / ....)',
                                    style: Sty().smallText.copyWith(
                                          color: Clr().hintColor,
                                        ),
                                  ),
                                  icon: SvgPicture.asset(
                                    "assets/down_arrow.svg",
                                    color: Clr().textcolor,
                                  ),
                                  decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Clr().white,
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Clr().primaryColor),
                                          borderRadius:
                                              BorderRadius.circular(55)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(55),
                                          borderSide: BorderSide(
                                              color: Clr().borderColor,
                                              width: 0.5)),
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: Dim().d12,
                                        vertical: Dim().d12,
                                      )),
                                ),
                              // DropdownButtonHideUnderline(
                              //   child: DropdownButtonFormField<dynamic>(
                              //     borderRadius: BorderRadius.circular(10),
                              //     decoration: InputDecoration(
                              // filled: true,
                              // fillColor: Clr().white,
                              // focusedBorder: OutlineInputBorder(
                              //     borderSide: BorderSide(
                              //         color: Clr().primaryColor),
                              //     borderRadius:
                              //         BorderRadius.circular(55)),
                              // border: OutlineInputBorder(
                              //     borderRadius: BorderRadius.circular(55),
                              //     borderSide: BorderSide(
                              //         color: Clr().borderColor,
                              //         width: 0.5)),
                              // contentPadding: EdgeInsets.symmetric(
                              //   horizontal: Dim().d12,
                              //   vertical: Dim().d12,
                              // )),
                              //     isExpanded: true,
                              // hint: Text(
                              //   'Select Sub-category (Food / IT / ....)',
                              //   style: Sty().smallText.copyWith(
                              //         color: Clr().textcolor,
                              //       ),
                              // ),
                              // icon: SvgPicture.asset(
                              //   "assets/down_arrow.svg",
                              //   color: Clr().textcolor,
                              // ),
                              //     style:
                              //         const TextStyle(color: Color(0xff595959)),
                              //     items: categoryList
                              //         .firstWhere((category) =>
                              //             category['name'] ==
                              //             sCategory)['subcategory']
                              //         .map<DropdownMenuItem<dynamic>>(
                              //             (subcategory) {
                              //       return DropdownMenuItem(
                              //         value: subcategory['name'],
                              //         child: Text(subcategory['name']),
                              //       );
                              //     }).toList(),
                              //     onChanged: (v) {
                              //       setState(() {
                              //         int pos = subCategoryList.indexWhere((e) =>
                              //             e['id'].toString() == v.toString());
                              //         sSubCategoryID = v.toString();
                              //         sSubCategory = subCategoryList[pos]['name'];
                              //       });
                              //     },
                              //   ),
                              // ),
                              SizedBox(
                                height: Dim().d20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dim().d20,
                  ),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Add Service / products Photos :',
                              style: Sty().largeText.copyWith(
                                  color: Clr().textcolor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800),
                            ),
                            SizedBox(
                              height: Dim().d12,
                            ),
                            productImage != null
                                ? SizedBox(
                                    height: Dim().d20,
                                  )
                                : SizedBox(
                                    height: Dim().d0,
                                  ),
                            productImage != null
                                ? Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        height: 180,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.5,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image.memory(
                                            ProductImages,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          top: 10,
                                          right: 10,
                                          child: Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Clr().white,
                                              border:
                                                  Border.all(color: Clr().red),
                                            ),
                                            child: Icon(
                                              Icons.close,
                                              color: Clr().red,
                                              size: 14,
                                            ),
                                          ))
                                    ],
                                  )
                                : Container(),
                            TextFormField(
                              onTap: _pickImages,
                              readOnly: true,
                              // controller: sampleImagesCtrl,
                              cursorColor: Clr().textcolorsgray,
                              style: Sty().mediumText,
                              maxLines: 1,
                              // keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              obscureText: false,
                              decoration: Sty().textFieldOutlineStyle2.copyWith(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(width: 0.3),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    hintStyle: Sty().smallText.copyWith(
                                          color: Clr().textcolor,
                                        ),
                                    filled: true,
                                    fillColor: Clr().background,
                                    hintText: "Add Images",
                                    counterText: "",
                                    // suffixIcon: Icon(Icons.navigate_next)
                                  ),
                            ),
                            SizedBox(
                              height: Dim().d12,
                            ),
                            // if (widget.data != null)
                            //   widget.data['shop_images'].length > 4
                            //       ? Padding(
                            //           padding: const EdgeInsets.all(8.0),
                            //           child: InkWell(
                            //             onTap: () {
                            //               getFullImage(
                            //                   widget.data['shop_images']);
                            //             },
                            //             child: Align(
                            //               alignment: Alignment.centerRight,
                            //               child: Text(
                            //                 'View Images',
                            //                 style: Sty().smallText,
                            //               ),
                            //             ),
                            //           ),
                            //         )
                            //       : Container(),
                            // if (widget.data != null)
                            //   widget.data['shop_images'].length > 4
                            //       ? SizedBox(
                            //           height: Dim().d12,
                            //         )
                            //       : Container(),
                            if (widget.data != null)
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent: 120,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                ),
                                itemCount: widget.data['shop_images'].length,
                                itemBuilder: (context, index) {
                                  var z = widget.data['shop_images'][index];
                                  return Center(
                                    child: Stack(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            STM().redirect2page(
                                              ctx,
                                              ImageViewPage(
                                                img: z['image'],
                                              ),
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.network(
                                              z['image'],
                                              width: 160,
                                              height: 120,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                deleteImage(z['id']);
                                                widget.data['shop_images']
                                                    .removeAt(index);
                                              });
                                            },
                                            child: Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                  color: Clr().primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  border: Border.all(
                                                      color:
                                                          Clr().borderColor)),
                                              child: Icon(
                                                Icons.close,
                                                size: 18,
                                                color: Clr().white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            if (_selectedImages.length >= 1)
                              SizedBox(
                                height: Dim().d20,
                              ),
                            if (_selectedImages.length >= 1)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Current Image",
                                    style: Sty().mediumText.copyWith(
                                          fontSize: 14,
                                        ),
                                  ),
                                  // _selectedImages.length > 4
                                  //     ? TextButton(
                                  //         style: TextButton.styleFrom(
                                  //             padding: EdgeInsets.zero,
                                  //             minimumSize: Size(50, 30),
                                  //             tapTargetSize:
                                  //                 MaterialTapTargetSize
                                  //                     .shrinkWrap,
                                  //             alignment: Alignment.centerLeft),
                                  //         onPressed: () {
                                  //           showModalBottomSheet(
                                  //             context: context,
                                  //             useSafeArea: true,
                                  //             isScrollControlled: true,
                                  //             // Set this to true for a full-page bottom sheet
                                  //             builder: (context) {
                                  //               return StatefulBuilder(builder:
                                  //                   (BuildContext context,
                                  //                       setState) {
                                  //                 return SingleChildScrollView(
                                  //                   physics:
                                  //                       BouncingScrollPhysics(),
                                  //                   child: Padding(
                                  //                     padding:
                                  //                         const EdgeInsets.all(
                                  //                             8.0),
                                  //                     child: Column(
                                  //                       children: [
                                  //                         GridView.builder(
                                  //                           shrinkWrap: true,
                                  //                           physics:
                                  //                               NeverScrollableScrollPhysics(),
                                  //                           gridDelegate:
                                  //                               const SliverGridDelegateWithFixedCrossAxisCount(
                                  //                             crossAxisCount: 2,
                                  //                             mainAxisExtent:
                                  //                                 145,
                                  //                             mainAxisSpacing:
                                  //                                 4,
                                  //                             crossAxisSpacing:
                                  //                                 4,
                                  //                           ),
                                  //                           itemCount:
                                  //                               _selectedImages
                                  //                                   .length,
                                  //                           itemBuilder:
                                  //                               (context,
                                  //                                   index) {
                                  //                             var z =
                                  //                                 _selectedImages[
                                  //                                     index];
                                  //                             return Center(
                                  //                               child: Stack(
                                  //                                 children: [
                                  //                                   InkWell(
                                  //                                     onTap:
                                  //                                         () {
                                  //                                       STM()
                                  //                                           .redirect2page(
                                  //                                         ctx,
                                  //                                         ImageViewPage(
                                  //                                           img:
                                  //                                               z,
                                  //                                           type:
                                  //                                               'file',
                                  //                                         ),
                                  //                                       );
                                  //                                     },
                                  //                                     child:
                                  //                                         ClipRRect(
                                  //                                       borderRadius:
                                  //                                           BorderRadius.circular(8),
                                  //                                       child: Image
                                  //                                           .file(
                                  //                                         z,
                                  //                                         width:
                                  //                                             160,
                                  //                                         // height:
                                  //                                         //     120,
                                  //                                         fit: BoxFit
                                  //                                             .cover,
                                  //                                       ),
                                  //                                     ),
                                  //                                   ),
                                  //                                   Positioned(
                                  //                                     top: 0,
                                  //                                     right: 0,
                                  //                                     child:
                                  //                                         GestureDetector(
                                  //                                       onTap:
                                  //                                           () {
                                  //                                         setState(
                                  //                                             () {
                                  //                                           _selectedImages.removeAt(index);
                                  //                                         });
                                  //                                       },
                                  //                                       child:
                                  //                                           Container(
                                  //                                         height:
                                  //                                             20,
                                  //                                         width:
                                  //                                             20,
                                  //                                         decoration: BoxDecoration(
                                  //                                             color: Clr().primaryColor,
                                  //                                             borderRadius: BorderRadius.circular(50),
                                  //                                             border: Border.all(color: Clr().borderColor)),
                                  //                                         child:
                                  //                                             Icon(
                                  //                                           Icons.close,
                                  //                                           size:
                                  //                                               18,
                                  //                                           color:
                                  //                                               Clr().white,
                                  //                                         ),
                                  //                                       ),
                                  //                                     ),
                                  //                                   ),
                                  //                                 ],
                                  //                               ),
                                  //                             );
                                  //                           },
                                  //                         ),
                                  //                         TextButton(
                                  //                           onPressed: () {
                                  //                             Navigator.of(
                                  //                                     context)
                                  //                                 .pop(); // Close the bottom sheet
                                  //                           },
                                  //                           child: Text('Close',
                                  //                               style: Sty()
                                  //                                   .mediumText
                                  //                                   .copyWith(
                                  //                                       decoration:
                                  //                                           TextDecoration.underline)),
                                  //                         ),
                                  //                       ],
                                  //                     ),
                                  //                   ),
                                  //                 );
                                  //               });
                                  //             },
                                  //           );
                                  //         },
                                  //         child: Align(
                                  //           alignment: Alignment.centerRight,
                                  //           child: Text(
                                  //             'view more',
                                  //             style: Sty().mediumText.copyWith(
                                  //                   color: Clr().primaryColor,
                                  //                   fontSize: 14,
                                  //                   height: 1.2,
                                  //                   decoration: TextDecoration
                                  //                       .underline,
                                  //                 ),
                                  //           ),
                                  //         ),
                                  //       )
                                  //     : Container(),
                                ],
                              ),
                            if (_selectedImages.length >= 1)
                              SizedBox(
                                height: Dim().d12,
                              ),
                            if (_selectedImages.length >= 1)
                              GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisExtent: 120,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                ),
                                itemCount: _selectedImages.length,
                                itemBuilder: (context, index) {
                                  var z = _selectedImages[index];
                                  return Center(
                                    child: Stack(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            STM().redirect2page(
                                              ctx,
                                              ImageViewPage(
                                                img: z,
                                                type: 'file',
                                              ),
                                            );
                                          },
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Image.file(
                                              z,
                                              width: 160,
                                              height: 120,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _selectedImages.removeAt(index);
                                              });
                                            },
                                            child: Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                  color: Clr().primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  border: Border.all(
                                                      color:
                                                          Clr().borderColor)),
                                              child: Icon(
                                                Icons.close,
                                                size: 18,
                                                color: Clr().white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            if (_imageUrlList.length >= 1)
                              SizedBox(
                                height: Dim().d12,
                              ),
                            if (_imageUrlList.length >= 1)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Previous Image",
                                    style: Sty().mediumText.copyWith(
                                          fontSize: 14,
                                        ),
                                  ),
                                  _imageUrlList.length > 4
                                      ? TextButton(
                                          style: TextButton.styleFrom(
                                              padding: EdgeInsets.zero,
                                              minimumSize: Size(50, 30),
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              alignment: Alignment.centerLeft),
                                          onPressed: () {
                                            showModalBottomSheet(
                                              context: context,
                                              useSafeArea: true,
                                              isScrollControlled: true,
                                              // Set this to true for a full-page bottom sheet
                                              builder: (context) {
                                                return StatefulBuilder(builder:
                                                    (BuildContext context,
                                                        setState) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child:
                                                        SingleChildScrollView(
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      child: Column(
                                                        children: [
                                                          GridView.builder(
                                                            shrinkWrap: true,
                                                            physics:
                                                                NeverScrollableScrollPhysics(),
                                                            gridDelegate:
                                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount: 2,
                                                              mainAxisExtent:
                                                                  145,
                                                              mainAxisSpacing:
                                                                  4,
                                                              crossAxisSpacing:
                                                                  4,
                                                            ),
                                                            itemCount:
                                                                _imageUrlList
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index2) {
                                                              var z =
                                                                  _imageUrlList[
                                                                      index2];
                                                              return Center(
                                                                child: Stack(
                                                                  children: [
                                                                    ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8),
                                                                      child:
                                                                          CachedNetworkImage(
                                                                        width:
                                                                            160,
                                                                        height:
                                                                            120,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        imageUrl:
                                                                            z['image'] ??
                                                                                'https://www.famunews.com/wp-content/themes/newsgamer/images/dummy.png',
                                                                        // imageUrl:v['user']['profile']!=null ?v['user']:'',
                                                                        placeholder:
                                                                            (context, url) =>
                                                                                STM().loadingPlaceHolder(),
                                                                        errorWidget: (context, url, error) => Image.network(
                                                                            'https://www.famunews.com/wp-content/themes/newsgamer/images/dummy.png',
                                                                            height:
                                                                                120,
                                                                            width:
                                                                                160,
                                                                            fit:
                                                                                BoxFit.cover),
                                                                      ),
                                                                      // Image.network('${z['image'].toString()}', height: 120, width: 160, fit: BoxFit.fill),
                                                                    ),
                                                                    Positioned(
                                                                      top: -14,
                                                                      right:
                                                                          -14,
                                                                      child:
                                                                          IconButton(
                                                                        icon:
                                                                            Container(
                                                                          height:
                                                                              20,
                                                                          width:
                                                                              20,
                                                                          decoration: BoxDecoration(
                                                                              color: Clr().primaryColor,
                                                                              borderRadius: BorderRadius.circular(50),
                                                                              border: Border.all(color: Clr().borderColor)),
                                                                          child:
                                                                              Icon(
                                                                            Icons.close,
                                                                            size:
                                                                                18,
                                                                            color:
                                                                                Clr().white,
                                                                          ),
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          // deleteImage(z['id'].toString());
                                                                          setState(
                                                                              () {
                                                                            _removeImageUrl(index2);
                                                                            // deleteProjects(
                                                                            //     z['id']);
                                                                            // v['images'].removeAt(index2);
                                                                          });
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(); // Close the bottom sheet
                                                            },
                                                            child: Text('Close',
                                                                style: Sty()
                                                                    .mediumText
                                                                    .copyWith(
                                                                        decoration:
                                                                            TextDecoration.underline)),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                              },
                                            );
                                          },
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              'view more',
                                              style: Sty().mediumText.copyWith(
                                                    color: Clr().primaryColor,
                                                    fontSize: 14,
                                                    height: 1.2,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            if (_imageUrlList.length >= 1)
                              const SizedBox(
                                height: 10,
                              ),
                            if (_imageUrlList.length >= 1)
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4,
                                  mainAxisExtent: 80,
                                  mainAxisSpacing: 12,
                                  crossAxisSpacing: 12,
                                ),
                                itemCount: _imageUrlList.length > 4
                                    ? 4
                                    : _imageUrlList.length,
                                itemBuilder: (context, index2) {
                                  var z = _imageUrlList[index2];

                                  return Center(
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: CachedNetworkImage(
                                            width: 160,
                                            height: 120,
                                            fit: BoxFit.fill,
                                            imageUrl: z['image'] ??
                                                'https://www.famunews.com/wp-content/themes/newsgamer/images/dummy.png',
                                            // imageUrl:v['user']['profile']!=null ?v['user']:'',
                                            placeholder: (context, url) =>
                                                STM().loadingPlaceHolder(),
                                            errorWidget: (context, url,
                                                    error) =>
                                                Image.network(
                                                    'https://www.famunews.com/wp-content/themes/newsgamer/images/dummy.png',
                                                    height: 120,
                                                    width: 160,
                                                    fit: BoxFit.fill),
                                          ),
                                          // Image.network('${z['image'].toString()}', height: 120, width: 160, fit: BoxFit.fill),
                                        ),
                                        Positioned(
                                          top: -14,
                                          right: -14,
                                          child: IconButton(
                                            icon: Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                  color: Clr().primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  border: Border.all(
                                                      color:
                                                          Clr().borderColor)),
                                              child: Icon(
                                                Icons.close,
                                                size: 18,
                                                color: Clr().white,
                                              ),
                                            ),
                                            onPressed: () {
                                              // deleteImage(z['id'].toString());
                                              setState(() {
                                                _removeImageUrl(index2);
                                                // deleteProjects(z['id']);
                                                // v['images'].removeAt(index2);
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
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
                            elevation: 0, backgroundColor: Clr().primaryColor),
                        onPressed: () {
                          if (_selectedImages.isNotEmpty) {
                            setState(() {
                              // Convert the list of images to base64
                              base64List = filesToBase64(_selectedImages);
                              // Print the base64-encoded images
                              for (String base64List in base64List) {
                                print('shhdgd $base64List');
                              }
                              submitStep3();
                            });
                          } else {
                            widget.data != null
                                ? submitStep3()
                                : STM().displayToast(
                                    'The service images is required');
                          }
                        },
                        child: Text(
                          widget.data != null ? 'Update' : 'Next',
                          style: Sty().mediumText.copyWith(color: Clr().white),
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
    );
  }

  getFullImage(list) async {
    return showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      // Set this to true for a full-page bottom sheet
      builder: (context) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 145,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                    ),
                    itemCount: list.length,
                    itemBuilder: (context, index2) {
                      var z = list[index2];
                      return Center(
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                width: 160,
                                height: 120,
                                fit: BoxFit.cover,
                                imageUrl: z['image'] ??
                                    'https://www.famunews.com/wp-content/themes/newsgamer/images/dummy.png',
                                // imageUrl:v['user']['profile']!=null ?v['user']:'',
                                placeholder: (context, url) =>
                                    STM().loadingPlaceHolder(),
                                errorWidget: (context, url, error) => Image.network(
                                    'https://www.famunews.com/wp-content/themes/newsgamer/images/dummy.png',
                                    height: 120,
                                    width: 160,
                                    fit: BoxFit.cover),
                              ),
                              // Image.network('${z['image'].toString()}', height: 120, width: 160, fit: BoxFit.fill),
                            ),
                            Positioned(
                              top: -14,
                              right: -14,
                              child: IconButton(
                                icon: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      color: Clr().primaryColor,
                                      borderRadius: BorderRadius.circular(50),
                                      border:
                                          Border.all(color: Clr().borderColor)),
                                  child: Icon(
                                    Icons.close,
                                    size: 18,
                                    color: Clr().white,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    deleteImage(widget.data['shop_images']
                                        [index2]['id']);
                                    list.removeAt(index2);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the bottom sheet
                    },
                    child: Text('Close',
                        style: Sty()
                            .mediumText
                            .copyWith(decoration: TextDecoration.underline)),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  /////////////////////////////////////////////////
  // _getCamera(ImageSource source, type) async {
  //   XFile? pickedFile = await ImagePicker().pickImage(
  //     source: source,
  //     maxHeight: 1800,
  //     maxWidth: 1800,
  //   );
  //
  //   if (pickedFile != null) {
  //     setState(() {
  //       imageFile = File(pickedFile.path);
  //       print("Image File :: $imageFile");
  //       var image = imageFile!.readAsBytesSync();
  //       log("Image :: $image");
  //
  //       switch (type) {
  //         case "Image":
  //           productImage = base64Encode(image);
  //           break;
  //       }
  //       ;
  //     });
  //   }
  // }

  ///Submit Step 3
  void submitStep3() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var body = {
      "shop_id": widget.data != null ? widget.data['id'] : sShopID,
      "category_id": sCategoryID,
      "subcategory_id": sSubCategoryID,
      "service_images": base64List,
    };
    var result = await STM().allApi(
        apiname: 'step3',
        ctx: ctx,
        body: body,
        load: true,
        loadtitle: 'Processing',
        type: 'post',
        token: sp.getString('token'));
    var success = result['success'];
    var message = result['message'];
    if (success) {
      if (widget.data != null) {
        STM().successDialogWithReplace(ctx, message, const ShopListing());
      } else {
        setState(
          () {
            STM().displayToast(message);
            STM().redirect2page(
              ctx,
              SelectTiming(),
            );
          },
        );
      }
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  void getalwaysCat(id) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var result = await STM().allApi(
      ctx: context,
      apiname: "get_categories",
      token: sp.getString('token'),
      type: 'get',
    );
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(() {
        categoryList = result['data'];
        setState(() {
          int pos = categoryList.indexWhere(
              (element) => element['id'].toString() == id.toString());
          subCategoryList = categoryList[pos]['subcategory'];
        });
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  /// getCities List Api
  void getCategories() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    //Output
    var result = await STM().getwithToken(
        context, Str().loading, "get_categories", sp.getString('token'));
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(() {
        categoryList = result['data'];
        print("Category List :: ${categoryList}");
      });
      if (widget.data != null) {
        setState(() {
          sCategoryID =
              widget.data['shop_information']['category_id'].toString();
          sSubCategoryID =
              widget.data['shop_information']['subcategory_id'].toString();
          int pos = categoryList.indexWhere(
              (element) => element['id'].toString() == sCategoryID.toString());
          subCategoryList = categoryList[pos]['subcategory'];
          int pos1 = subCategoryList.indexWhere((element) =>
              element['id'].toString() == sSubCategoryID.toString());
          sCategory = categoryList[pos]['name'];
          sSubCategory = subCategoryList[pos1]['name'];
        });
      }
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  void deleteImage(id) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var result = await STM().allApi(
      apiname: 'delete_shop_image',
      ctx: ctx,
      body: {
        "image_id": id,
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
