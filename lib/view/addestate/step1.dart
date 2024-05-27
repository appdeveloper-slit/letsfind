// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:letsfind/values/colors.dart';
import 'package:letsfind/view/addestate/esatelist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/static_method.dart';
import '../../values/dimens.dart';
import '../../values/strings.dart';
import '../../values/styles.dart';
import '../imageview.dart';
import 'step2.dart';

class propertyOverviewPage extends StatefulWidget {
  final data;
  const propertyOverviewPage({super.key, this.data});

  @override
  State<propertyOverviewPage> createState() => _propertyOverviewPageState();
}

class _propertyOverviewPageState extends State<propertyOverviewPage> {
  late BuildContext ctx;
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController descCtrl = TextEditingController();
  TextEditingController mobileCtrl = TextEditingController();
  TextEditingController locationCtrl = TextEditingController();
  TextEditingController addCtrl = TextEditingController();
  String? sCity, sCityId, sLocation, slat, slng;
  String? sCityCheck, slocationCheck;
  List<dynamic> cityList = [];
  List<File> _selectedFileImages = [];
  List b64File = [];
  List imagesList = [];

  getsessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getCities();
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
    return WillPopScope(
      onWillPop: () async {
        widget.data != null
            ? STM().replacePage(ctx, const estateList())
            : STM().back2Previous(ctx);
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
                  ? STM().replacePage(ctx, const estateList())
                  : STM().back2Previous(ctx);
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
                  text: '1 ',
                  style: Sty().smallText.copyWith(
                        color: Color(0xffFF8000),
                        fontFamily: 'SP',
                        fontWeight: FontWeight.w600,
                      ),
                ),
                TextSpan(
                  text: 'of 4',
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
          padding:
              EdgeInsets.symmetric(vertical: Dim().d16, horizontal: Dim().d16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dim().d20, vertical: Dim().d20),
                    decoration: BoxDecoration(
                        color: Clr().white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(Dim().d16),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 5,
                            spreadRadius: 1,
                            color: Colors.black12,
                          )
                        ]),
                    child: Column(
                      children: [
                        Text(
                          'Property Overview',
                          style: Sty().largeText.copyWith(
                              color: Clr().primaryColor,
                              fontSize: 32,
                              fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          "Your property, your details - let's get started.",
                          style: Sty().smallText.copyWith(
                                color: Clr().primaryColor,
                                fontFamily: 'SP',
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        SizedBox(
                          height: Dim().d20,
                        ),
                        firstThreeLayout(
                          controller: nameCtrl,
                          hintext: 'Enter Property Name',
                          text: 'Property Name',
                          data: {
                            'maxlines': 1,
                            'keyboardtype': TextInputType.name,
                          },
                          validator: (v) {
                            if (v!.isEmpty) {
                              return 'Property name is required';
                            }
                            return null;
                          },
                        ),
                        firstThreeLayout(
                          controller: descCtrl,
                          hintext: 'Enter Property Description',
                          text: 'Property Description',
                          data: {
                            'maxlines': 3,
                            'keyboardtype': TextInputType.name,
                          },
                          validator: (v) {
                            if (v!.isEmpty) {
                              return 'Property description is required';
                            }
                            return null;
                          },
                        ),
                        firstThreeLayout(
                          controller: mobileCtrl,
                          hintext: 'Enter Mobile Number',
                          text: 'Mobile Number',
                          data: {
                            'maxlines': 1,
                            'keyboardtype': TextInputType.number,
                            'maxlength': 10,
                          },
                          validator: (v) {
                            if (v!.isEmpty ||
                                !RegExp(r'([5-9]{1}[0-9]{9})').hasMatch(v)) {
                              return 'Enter valid Mobile Number';
                            } else {
                              return null;
                            }
                          },
                        ),
                        cityPage(),
                        locationPage(),
                        firstThreeLayout(
                          controller: addCtrl,
                          hintext: 'Enter Property Full Address',
                          text: 'Property Address',
                          data: {
                            'maxlines': 3,
                            'keyboardtype': TextInputType.text,
                          },
                          validator: (v) {
                            if (v!.isEmpty) {
                              return 'Address is required';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: Dim().d20,
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Clr().white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(Dim().d16),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 5,
                            spreadRadius: 1,
                            color: Colors.black12,
                          )
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add Property Photos :',
                            style: Sty().mediumText,
                          ),
                          SizedBox(
                            height: Dim().d12,
                          ),
                          InkWell(
                            onTap: () {
                              pickImages();
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black26,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(Dim().d20),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Center(
                                  child: Text(
                                    'Add Images',
                                    style: Sty().smallText,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Dim().d12,
                          ),
                          imageLayout(),
                          SizedBox(
                            height: Dim().d12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: Dim().d20,
                ),
                SizedBox(
                  height: Dim().d48,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        validator();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Clr().primaryColor,
                    ),
                    child: Center(
                      child: Text(
                        widget.data != null ? 'Update' : 'Next',
                        style: Sty().mediumText.copyWith(color: Clr().white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  validator() async {
    bool check = _formKey.currentState!.validate();
    if (sCity == null) {
      setState(() {
        sCityCheck = 'Please select a city';
        check = false;
      });
    } else if (locationCtrl.text.isEmpty) {
      setState(() {
        slocationCheck = 'Please enter a shop location';
        check = false;
      });
    } else if (_selectedFileImages.isEmpty && widget.data == null) {
      setState(() {
        STM().displayToast('Please add a images');
        check = false;
      });
    } else {
      setState(() {
        check = true;
      });
    }
    if (check) {
      updateAndAddstep1();
    }
  }

  Widget firstThreeLayout({text, controller, validator, hintext, data}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: Dim().d20,
        ),
        Text(
          text,
          style: Sty().smallText.copyWith(
                fontSize: Dim().d12,
                fontWeight: FontWeight.w500,
                color: const Color(0xff606060),
              ),
        ),
        SizedBox(
          height: Dim().d12,
        ),
        TextFormField(
          controller: controller,
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
          },
          cursorColor: Clr().textcolorsgray,
          style: Sty().smallText,
          keyboardType: data['keyboardtype'],
          textInputAction: TextInputAction.done,
          obscureText: false,
          maxLines: data['maxlines'],
          maxLength: data['maxlength'],
          decoration: Sty().textFieldOutlineStyle.copyWith(
                border: OutlineInputBorder(
                    borderSide: const BorderSide(width: 0.1),
                    borderRadius: BorderRadius.circular(24)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: controller.text.isNotEmpty
                        ? Clr().primaryColor
                        : Clr().hintColor,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(
                    color: controller.text.isNotEmpty
                        ? Clr().primaryColor
                        : Clr().hintColor,
                  ),
                ),
                hintStyle: Sty()
                    .smallText
                    .copyWith(color: Clr().grey, fontFamily: "SF"),
                hintText: hintext,
                counterText: "",
                contentPadding: EdgeInsets.symmetric(
                  horizontal: Dim().d20,
                  vertical: Dim().d14,
                ),
              ),
          validator: (value) => validator(value),
        ),
        SizedBox(
          height: Dim().d12,
        ),
      ],
    );
  }

  Widget cityPage() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16, top: Dim().d16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'City',
              style: Sty().microText.copyWith(
                  color: Clr().textcolor, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        SizedBox(
          height: Dim().d8,
        ),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(55),
              border: Border.all(color: Colors.black26, width: 0.5)),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              borderRadius: BorderRadius.circular(10),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Clr().white,
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black26, width: 0.5),
                      borderRadius: BorderRadius.circular(55)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black26, width: 0.5),
                      borderRadius: BorderRadius.circular(55)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(55),
                      borderSide:
                          const BorderSide(color: Colors.black26, width: 0.5)),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: Dim().d20,
                    vertical: Dim().d12,
                  )),
              // value: sCity,
              isExpanded: true,
              hint: Text(
                sCity ?? 'Select City',
                style: Sty().smallText.copyWith(
                      fontWeight: FontWeight.w400,
                      color: sCity != null ? Clr().black : Clr().hintColor,
                    ),
              ),
              icon: SvgPicture.asset(
                "assets/down_arrow.svg",
                color: Clr().textcolor,
              ),
              // style: TextStyle(color: Color(0xff2D2D2D)),
              items: cityList.map((string) {
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
                  sCityId = v;
                  sCity = cityList[int.parse(v.toString())]['name'];
                  sCityCheck = null;
                });
              },
            ),
          ),
        ),
        if (sCityCheck != null)
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: Dim().d12, vertical: Dim().d4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '$sCityCheck',
                style: Sty().smallText.copyWith(color: Clr().errorRed),
              ),
            ),
          )
      ],
    );
  }

  Widget locationPage() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: 16, top: Dim().d16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Property Location',
              style: Sty().microText.copyWith(
                  color: Clr().textcolor, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        SizedBox(
          height: Dim().d8,
        ),

        /// Google Places API
        GooglePlaceAutoCompleteTextField(
          showError: true,
          textEditingController: locationCtrl,
          googleAPIKey: "AIzaSyAkOzCph93Hg4lejvCvndXXf_VdHANLaD4",
          inputDecoration: InputDecoration(
            hintText: sLocation ?? "Enter Shop Location",
            border: InputBorder.none,
            hintStyle: Sty().smallText.copyWith(
                color: sLocation != null ? Clr().black : Clr().grey,
                fontWeight: FontWeight.w400,
                fontFamily: "SF"),
            enabledBorder: InputBorder.none,
          ),
          textStyle: Sty()
              .smallText
              .copyWith(color: Clr().textcolor, fontFamily: "SF"),
          debounceTime: 400,
          countries: ["in", "fr"],
          boxDecoration: BoxDecoration(
            color: Clr().white,
            borderRadius: BorderRadius.circular(55),
            border: Border.all(
              color: locationCtrl.text.isNotEmpty
                  ? Clr().primaryColor
                  : Clr().hintColor,
            ),
          ),
          isLatLngRequired: true,
          getPlaceDetailWithLatLng: (Prediction prediction) {
            slng = prediction.lng.toString();
            slat = prediction.lat.toString();
            print("Longitude + $slng");
            print("Latitude + $slat");
          },
          itemClick: (Prediction prediction) {
            locationCtrl.text = prediction.description ?? "";
            locationCtrl.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description?.length ?? 0),
            );
            slocationCheck = null;
          },
          seperatedBuilder: Divider(color: Clr().white),
          containerHorizontalPadding: 10,
          // OPTIONAL// If you want to customize list view item builder
          itemBuilder: (context, index, Prediction prediction) {
            return Container(
              decoration: BoxDecoration(
                  // color: Clr().white,
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: Clr().primaryColor),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(
                      "${prediction.description ?? ""}",
                      style: Sty().smallText.copyWith(color: Clr().textcolor),
                    ),
                  )
                ],
              ),
            );
          },
          isCrossBtnShown: true,

          // default 600 ms ,
        ),
        if (slocationCheck != null)
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: Dim().d12, vertical: Dim().d4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '$slocationCheck',
                style: Sty().smallText.copyWith(color: Clr().errorRed),
              ),
            ),
          )
      ],
    );
  }

  Widget imageLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_selectedFileImages.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: Dim().d8),
            child: Text(
              'Images Selected :',
              style: Sty().smallText,
            ),
          ),
        if (_selectedFileImages.isNotEmpty)
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 12 / 7,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
            ),
            itemCount: _selectedFileImages.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  InkWell(
                    onTap: () {
                      STM().redirect2page(
                          ctx,
                          ImageViewPage(
                            img: _selectedFileImages[index],
                            type: 'file',
                          ));
                    },
                    child: SizedBox(
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.all(Radius.circular(Dim().d20)),
                        child: Image.file(
                          _selectedFileImages[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      top: 10,
                      right: 10,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedFileImages.removeAt(index);
                          });
                        },
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Clr().white,
                            border: Border.all(color: Clr().red),
                          ),
                          child: Icon(
                            Icons.close,
                            color: Clr().red,
                            size: 14,
                          ),
                        ),
                      ))
                ],
              );
            },
          ),
        if (_selectedFileImages.isNotEmpty)
          SizedBox(
            height: Dim().d20,
          ),
        if (imagesList.isNotEmpty)
          Padding(
            padding: EdgeInsets.only(bottom: Dim().d8),
            child: Text(
              'property_images :',
              style: Sty().smallText,
            ),
          ),
        if (imagesList.isNotEmpty)
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 12 / 7,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
            ),
            itemCount: imagesList.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  InkWell(
                    onTap: () {
                      STM().redirect2page(
                        ctx,
                        ImageViewPage(
                          img: imagesList[index]['image'],
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.all(Radius.circular(Dim().d20)),
                        border: Border.all(
                          color: Colors.black26,
                          width: 1.0,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.all(Radius.circular(Dim().d20)),
                        child: CachedNetworkImage(
                          width: double.infinity,
                          height: Dim().d120,
                          fit: BoxFit.cover,
                          imageUrl: imagesList[index]['image'].toString(),
                          placeholder: (context, url) =>
                              STM().loadingPlaceHolder(),
                          errorWidget: (context, url, error) => Image.network(
                              fit: BoxFit.cover,
                              'https://www.famunews.com/wp-content/themes/newsgamer/images/dummy.png'),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      top: 10,
                      right: 10,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            deleteImage(imagesList[index]['id']);
                            imagesList.removeAt(index);
                          });
                        },
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Clr().white,
                            border: Border.all(color: Clr().red),
                          ),
                          child: Icon(
                            Icons.close,
                            color: Clr().red,
                            size: 14,
                          ),
                        ),
                      ))
                ],
              );
            },
          ),
      ],
    );
  }

  void pickImages() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      allowMultiple: true,
    );
    if (result != null) {
      setState(() {
        _selectedFileImages = result.paths.map((path) => File(path!)).toList();
      });
    } else {}
  }

  /// getCities List Api
  void getCities() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    //Output
    var result = await STM().getwithToken(
      context,
      Str().loading,
      "get_cities",
      sp.getString('token'),
    );
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(() {
        cityList = result['data'];
      });
      if (widget.data != null) {
        setState(() {
          nameCtrl = TextEditingController(text: widget.data['name']);
          descCtrl = TextEditingController(text: widget.data['description']);
          mobileCtrl = TextEditingController(text: widget.data['mobile']);
          addCtrl = TextEditingController(text: widget.data['address']);
          sCityId = widget.data['city_id'].toString();
          int pos = cityList.indexWhere((element) =>
              element['id'].toString() == widget.data['city_id'].toString());
          sCity = cityList[pos]['name'];
          slat = widget.data['latitude'];
          slng = widget.data['longitude'];
          getLatLng(
            double.parse(slat.toString()),
            double.parse(
              slng.toString(),
            ),
          );
          imagesList = widget.data['property_images'];
        });
      }
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  void updateAndAddstep1() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    b64File.clear();
    for (int a = 0; a < _selectedFileImages.length; a++) {
      setState(() {
        var image = _selectedFileImages[a].readAsBytesSync();
        b64File.add(base64Encode(image));
      });
    }
    var result = await STM().allApi(
      apiname: 're/step1',
      ctx: ctx,
      load: true,
      loadtitle: Str().processing,
      token: sp.getString('token'),
      type: 'post',
      body: {
        "id": widget.data != null ? widget.data['id'] : null,
        "name": nameCtrl.text,
        "description": descCtrl.text,
        "mobile": mobileCtrl.text,
        "city_id": sCityId,
        "latitude": slat,
        "longitude": slng,
        "address": addCtrl.text,
        "property_images": b64File,
      },
    );
    if (result['success'] == true) {
      if (widget.data != null) {
        STM().successDialogWithReplace(
            ctx, result['message'], const estateList());
      } else {
        STM().redirect2page(
            ctx,
            propertyDetailsPage(
              property_id: result['data']['property_id'],
            ));
        STM().displayToast(result['message']);
      }
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }

  getLatLng(lat, lng) async {
    List<Placemark> list = await placemarkFromCoordinates(lat, lng);
    setState(() {
      locationCtrl = TextEditingController(
          text:
              '${list[0].locality} ${list[0].subLocality} ${list[0].street} ${list[0].subAdministrativeArea}');
    });
  }

  void deleteImage(id) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var result = await STM().allApi(
      apiname: 'delete_property_image',
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
