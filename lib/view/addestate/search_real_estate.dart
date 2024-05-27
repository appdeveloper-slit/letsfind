// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:letsfind/values/dimens.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../bottomnavigation/bottomnavigationPage.dart';
import '../../data/static_method.dart';
import '../../values/colors.dart';
import '../../values/dimens.dart';
import '../../values/strings.dart';
import '../../values/styles.dart';
import '../homelayout/home.dart';
import 'real_estate.dart';

class SearchRealEstate extends StatefulWidget {
  const SearchRealEstate({Key? key}) : super(key: key);

  @override
  State<SearchRealEstate> createState() => _SearchRealEstateState();
}

class _SearchRealEstateState extends State<SearchRealEstate> {
  late BuildContext ctx;

  String? sType, sCity, sTypeOfProperty, sOwnership;

  final _formKey = GlobalKey<FormState>();
  TextEditingController areaCtrl = TextEditingController();
  TextEditingController minCtrl = TextEditingController();
  TextEditingController maxCtrl = TextEditingController();

  var propertyData;

  List<dynamic> propertyTypeList = [
    {'name': 'Resendential', "id": "1"},
    {'name': 'Commercial', "id": "2"},
  ];
  List<dynamic> ownershipList = [
    {'name': 'Buy', "id": "1"},
    {'name': 'Rent', "id": "2"},
  ];
  List<dynamic> cityList = [];
  List<dynamic> propertiesList = [];
  List<dynamic> typeOfPropertyList = [];
  List<dynamic> filteredCity = [];

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

  /// Code for City search list locally
  void filterCitySearch(String query) {
    List<dynamic> citySearchResults = [];
    if (query.isNotEmpty) {
      cityList.forEach((item) {
        if (item['name'].toLowerCase().contains(query.toLowerCase())) {
          citySearchResults.add(item);
        }
      });
      setState(() {
        filteredCity = citySearchResults;
      });
    } else {
      setState(() {
        filteredCity = cityList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;

    print("Type == $sType");

    return WillPopScope(
      onWillPop: () async {
        STM().finishAffinity(ctx, Home());
        return false;
      },
      child: Scaffold(
        backgroundColor: Clr().background,
        bottomNavigationBar: bottomBarLayout(ctx, 0),
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
            'Real Estate',
            style: Sty().largeText.copyWith(
                  color: Clr().primaryColor,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(Dim().d16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Clr().white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                          color: Clr().hintColor.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 0)
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dim().d16, vertical: Dim().d24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text(
                                      'Property Type',
                                      style: Sty().microText.copyWith(
                                          color: Clr().textGrey,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  SizedBox(
                                    height: Dim().d4,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(55),
                                        border: Border.all(
                                            color: Clr().borderColor)),
                                    child: DropdownButtonHideUnderline(
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
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              horizontal: Dim().d20,
                                              vertical: Dim().d12,
                                            )),
                                        // value: sCity,
                                        isExpanded: true,
                                        hint: Text(
                                          sType ?? 'Select Type',
                                          style: Sty().smallText.copyWith(
                                                color: Clr().hintColor,
                                              ),
                                        ),
                                        icon: SvgPicture.asset(
                                          "assets/down_arrow.svg",
                                          color: Clr().textcolor,
                                        ),
                                        // style: TextStyle(color: Color(0xff2D2D2D)),
                                        items: propertyTypeList.map((string) {
                                          return DropdownMenuItem<String>(
                                            value: string['id'].toString(),
                                            child: Text(
                                                string['name'].toString(),
                                                style: Sty().smallText.copyWith(
                                                      color: Clr().black,
                                                    )),
                                          );
                                        }).toList(),
                                        onChanged: (v) {
                                          setState(() {
                                            sType = v;
                                            print("City :: $sType");
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: Dim().d20,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0),
                                    child: Text(
                                      'City',
                                      style: Sty().microText.copyWith(
                                          color: Clr().textGrey,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  SizedBox(
                                    height: Dim().d4,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(55),
                                        border: Border.all(
                                            color: Clr().borderColor)),
                                    child: DropdownButtonHideUnderline(
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
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              horizontal: Dim().d20,
                                              vertical: Dim().d12,
                                            )),
                                        // value: sCity,
                                        isExpanded: true,
                                        hint: Text(
                                          sCity ?? 'Select City',
                                          style: Sty().smallText.copyWith(
                                                color: Clr().hintColor,
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
                                            child: Text(
                                                string['name'].toString(),
                                                style: Sty().smallText.copyWith(
                                                      color: Clr().black,
                                                    )),
                                          );
                                        }).toList(),
                                        onChanged: (v) {
                                          setState(() {
                                            sCity = v;
                                          });
                                        },
                                      ),
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
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'Type of Property',
                            style: Sty().microText.copyWith(
                                color: Clr().textGrey,
                                fontWeight: FontWeight.w600),
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
                                sTypeOfProperty ?? 'Select Type of Property',
                                style: Sty().smallText.copyWith(
                                      color: Clr().hintColor,
                                    ),
                              ),
                              icon: SvgPicture.asset(
                                "assets/down_arrow.svg",
                                color: Clr().textcolor,
                              ),
                              // style: TextStyle(color: Color(0xff2D2D2D)),
                              items: typeOfPropertyList.map((string) {
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
                                  sTypeOfProperty = v;
                                  print("Type Of Property :: $sTypeOfProperty");
                                });
                              },
                            ),
                          ),
                        ),
                        sType == null
                            ? Container()
                            : Container(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: Dim().d20,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16.0),
                                                child: Text(
                                                  'Ownership',
                                                  style: Sty()
                                                      .microText
                                                      .copyWith(
                                                          color: Clr().textGrey,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                              ),
                                              SizedBox(
                                                height: Dim().d4,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            55),
                                                    border: Border.all(
                                                        color:
                                                            Clr().borderColor)),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child:
                                                      DropdownButtonFormField<
                                                          String>(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    decoration: InputDecoration(
                                                        filled: true,
                                                        fillColor: Clr().white,
                                                        focusedBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: Clr()
                                                                    .primaryColor),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        55)),
                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        55),
                                                            borderSide: BorderSide(
                                                                color: Clr()
                                                                    .borderColor,
                                                                width: 0.5)),
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                          horizontal: Dim().d20,
                                                          vertical: Dim().d12,
                                                        )),
                                                    // value: sCity,
                                                    isExpanded: true,
                                                    hint: Text(
                                                      sOwnership ??
                                                          'Select Buy/Rent',
                                                      style: Sty()
                                                          .smallText
                                                          .copyWith(
                                                            color:
                                                                Clr().hintColor,
                                                          ),
                                                    ),
                                                    icon: SvgPicture.asset(
                                                      "assets/down_arrow.svg",
                                                      color: Clr().textcolor,
                                                    ),
                                                    // style: TextStyle(color: Color(0xff2D2D2D)),
                                                    items: ownershipList
                                                        .map((string) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: string['id']
                                                            .toString(),
                                                        child: Text(
                                                            string['name']
                                                                .toString(),
                                                            style: Sty()
                                                                .smallText
                                                                .copyWith(
                                                                  color: Clr()
                                                                      .black,
                                                                )),
                                                      );
                                                    }).toList(),
                                                    onChanged: (v) {
                                                      setState(() {
                                                        sOwnership = v;
                                                        print(
                                                            "sOwnership :: $sOwnership");
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: Dim().d12,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16.0),
                                                child: Text(
                                                  'Area (sqft onwards)',
                                                  style: Sty()
                                                      .microText
                                                      .copyWith(
                                                          color: Clr().textGrey,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                              ),
                                              SizedBox(
                                                height: Dim().d4,
                                              ),
                                              TextFormField(
                                                controller: areaCtrl,
                                                onTapOutside: (event) {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                },
                                                cursorColor:
                                                    Clr().textcolorsgray,
                                                style: Sty().smallText.copyWith(
                                                    color: Clr().textcolor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                keyboardType:
                                                    TextInputType.number,
                                                textInputAction:
                                                    TextInputAction.done,
                                                obscureText: false,
                                                decoration: Sty()
                                                    .textFieldOutlineStyle
                                                    .copyWith(
                                                      border:
                                                          OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      width:
                                                                          0.1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          55)),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(55),
                                                        borderSide: BorderSide(
                                                          color:
                                                              // whatsappCtrl.text.isNotEmpty ||
                                                              //     isFocused
                                                              //     ? Clr().primaryColor
                                                              //     :
                                                              Clr().hintColor,
                                                        ),
                                                      ),
                                                      hintStyle: Sty()
                                                          .smallText
                                                          .copyWith(
                                                              color: Clr().grey,
                                                              fontFamily: "SF"),
                                                      hintText: "Min. sqft",
                                                      counterText: "",
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
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
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: Dim().d20,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16.0),
                                                child: Text(
                                                  'Budget Range (in ₹)',
                                                  style: Sty()
                                                      .microText
                                                      .copyWith(
                                                          color: Clr().textGrey,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                              ),
                                              SizedBox(
                                                height: Dim().d4,
                                              ),
                                              TextFormField(
                                                onTapOutside: (event) {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                },
                                                controller: minCtrl,
                                                cursorColor:
                                                    Clr().textcolorsgray,
                                                style: Sty().smallText.copyWith(
                                                    color: Clr().textcolor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                keyboardType:
                                                    TextInputType.number,
                                                textInputAction:
                                                    TextInputAction.done,
                                                decoration: Sty()
                                                    .textFieldOutlineStyle
                                                    .copyWith(
                                                      border:
                                                          OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      width:
                                                                          0.1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          55)),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(55),
                                                        borderSide: BorderSide(
                                                          color:
                                                              Clr().hintColor,
                                                        ),
                                                      ),
                                                      hintStyle: Sty()
                                                          .smallText
                                                          .copyWith(
                                                              color: Clr().grey,
                                                              fontFamily: "SF"),
                                                      hintText: "Min Value",
                                                      counterText: "",
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
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
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: Dim().d12,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: Dim().d4,
                                              ),
                                              TextFormField(
                                                controller: maxCtrl,
                                                onTapOutside: (event) {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                },
                                                cursorColor:
                                                    Clr().textcolorsgray,
                                                style: Sty().smallText.copyWith(
                                                    color: Clr().textcolor,
                                                    fontWeight:
                                                        FontWeight.w500),
                                                keyboardType:
                                                    TextInputType.number,
                                                textInputAction:
                                                    TextInputAction.done,
                                                obscureText: false,
                                                decoration: Sty()
                                                    .textFieldOutlineStyle
                                                    .copyWith(
                                                      border:
                                                          OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                      width:
                                                                          0.1),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          55)),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(55),
                                                        borderSide: BorderSide(
                                                          color:
                                                              // whatsappCtrl.text.isNotEmpty ||
                                                              //     isFocused
                                                              //     ? Clr().primaryColor
                                                              //     :
                                                              Clr().hintColor,
                                                        ),
                                                      ),
                                                      hintStyle: Sty()
                                                          .smallText
                                                          .copyWith(
                                                              color: Clr().grey,
                                                              fontFamily: "SF"),
                                                      hintText: "Max Value",
                                                      counterText: "",
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
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
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                      ],
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
                          elevation: 0,
                          backgroundColor: sType == null
                              ? Clr().borderColor
                              : Clr().primaryColor),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          STM().checkInternet(context, widget).then(
                            (value) {
                              if (value) {
                                setState(() {
                                  sType == null ? null : searchProperty();
                                });
                              }
                            },
                          );
                        }
                        ;
                        // submitStep6();
                      },
                      child: Text(
                        'Search',
                        style: Sty().mediumText.copyWith(
                            color: sType == null
                                ? Clr().primaryColor.withOpacity(0.4)
                                : Clr().white),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// getCities List Api
  void getCities() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    //Output
    var result = await STM().getwithToken(
        context, Str().loading, "get_cities", sp.getString('token'));
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(() {
        cityList = result['data'];
        getTypeOfProperty();
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  /// get type of property List Api
  void getTypeOfProperty() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    //Output
    var result = await STM().getwithToken(
        context, Str().loading, "get_type_of_property", sp.getString('token'));
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(() {
        typeOfPropertyList = result['data'];
        print("T O P :: $typeOfPropertyList");
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  ///searchProperty Api
  void searchProperty() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      "property_type": sType,
      "city_id": sCity,
      "property_type_id": sTypeOfProperty,
      "area": areaCtrl.text.toString(),
      "min_value": minCtrl.text.toString(),
      "max_value": maxCtrl.text.toString(),
      "ownership": sOwnership,
    });
    var result = await STM().postWithToken(
        ctx, Str().loading, 'get_properties', body, sp.getString('token'));
    var success = result['success'];
    var message = result['message'];
    if (success) {
      propertyData = result['data'];
      propertiesList = result['data']['properties'];
      STM().redirect2page(
        ctx,
        RealEstate(sPropertyList: propertiesList, sPropertyData: propertyData),
      );
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
