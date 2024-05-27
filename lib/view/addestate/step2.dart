// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:letsfind/values/dimens.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/static_method.dart';
import '../../values/colors.dart';
import '../../values/strings.dart';
import '../../values/styles.dart';
import 'esatelist.dart';
import 'step3.dart';

class propertyDetailsPage extends StatefulWidget {
  final data, property_id;
  const propertyDetailsPage({Key? key, this.data, this.property_id})
      : super(key: key);

  @override
  State<propertyDetailsPage> createState() => _propertyDetailsPageState();
}

class _propertyDetailsPageState extends State<propertyDetailsPage> {
  late BuildContext ctx;

  String? sTypeId,
      sCity,
      sTypeOfProperty,
      sTypeOfPropertyId,
      sOwnership,
      sOwnershipId,
      sPropertyStatus,
      sPropertyStatusId,
      sToken,
      sType,
      sRoms,
      sRomsId,
      sBalconys,
      sBathrooms,
      sBathroomsId,
      sParkings,
      sParkingsId;

  String? sPropertyTypeCheck,
      sTypePropertyCheck,
      sPropertyStatusCheck,
      sOwenershipCheck,
      sRoomsCheck,
      sBalconyCheck,
      sBathroomCheck,
      sPrakingCheck;

  final _formKey = GlobalKey<FormState>();
  TextEditingController areaCtrl = TextEditingController();
  TextEditingController minCtrl = TextEditingController();
  TextEditingController maxCtrl = TextEditingController();

  var propertyData;

  List<dynamic> propertyTypeList = [
    {'name': 'Resendential', "id": "1"},
    {'name': 'Commercial', "id": "2"},
  ];

  List<dynamic> bathroomList = [
    {'name': 'Yes', "id": "1"},
    {'name': 'No', "id": "0"},
  ];

  List<dynamic> parkingList = [
    {'name': 'Yes', "id": "1"},
    {'name': 'No', "id": "0"},
  ];

  List<dynamic> ownershipList = [
    {'name': 'Buy', "id": "1"},
    {'name': 'Rent', "id": "2"},
  ];

  List balconyList = [
    {'id': '1', "name": '1'},
    {'id': '2', "name": '2'},
    {'id': '3', "name": '3'},
    {'id': '4', "name": '4'},
    {'id': '5', "name": '5'},
    {'id': '6', "name": '6'},
  ];
  List<dynamic> cityList = [];
  List<dynamic> propertiesList = [];
  List<dynamic> typeOfPropertyList = [];
  List<dynamic> statusList = [];
  List<dynamic> roomsList = [];

  getsessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    // sToken = sp.getString('token') ?? '';
    sToken = sp.getString("token") ?? "";
    print("Token :: $sToken");
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

    print("Type == $sType");

    return WillPopScope(
      onWillPop: () async {
        widget.data != null
            ? STM().replacePage(ctx, const estateList())
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
                                    STM().replacePage(ctx, const estateList());
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
                  ? STM().replacePage(ctx, const estateList())
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
                                              ctx, const estateList());
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
                  text: '2 ',
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
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Property Details',
                            style: Sty().largeText.copyWith(
                                color: Clr().primaryColor,
                                fontSize: 32,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "Enter details about your property",
                            style: Sty().smallText.copyWith(
                                  color: Clr().primaryColor,
                                  fontFamily: 'SP',
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                        SizedBox(
                          height: Dim().d32,
                        ),
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
                                                color: sType != null
                                                    ? Clr().black
                                                    : Clr().hintColor,
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
                                            sTypeId = v;
                                            int pos = propertyTypeList
                                                .indexWhere((element) =>
                                                    element['id'].toString() ==
                                                    v.toString());
                                            sType =
                                                propertyTypeList[pos]['name'];
                                            sPropertyTypeCheck = null;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  if (sPropertyTypeCheck != null)
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Dim().d12,
                                          vertical: Dim().d4),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '$sPropertyTypeCheck',
                                          style: Sty()
                                              .smallText
                                              .copyWith(color: Clr().errorRed),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Dim().d20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                                      color: sTypeOfProperty != null
                                          ? Clr().black
                                          : Clr().hintColor,
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
                                  sTypeOfPropertyId = v;
                                  int pos = typeOfPropertyList.indexWhere(
                                      (element) =>
                                          element['id'].toString() ==
                                          v.toString());
                                  print(typeOfPropertyList);
                                  sTypeOfProperty =
                                      typeOfPropertyList[pos]['name'];
                                  sTypePropertyCheck = null;
                                });
                              },
                            ),
                          ),
                        ),
                        if (sTypePropertyCheck != null)
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dim().d12, vertical: Dim().d4),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '$sTypePropertyCheck',
                                style: Sty()
                                    .smallText
                                    .copyWith(color: Clr().errorRed),
                              ),
                            ),
                          ),
                        commercialPropertyLayout(ctx),
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
                          validator();
                        }
                        // submitStep6();
                      },
                      child: Text(
                        widget.data != null ? 'Update' : 'Next',
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

  validator() async {
    bool check = _formKey.currentState!.validate();
    if (sType == null) {
      setState(() {
        sPropertyTypeCheck = 'Please select a property type';
        check = false;
      });
    } else if (sTypeOfProperty == null) {
      setState(() {
        sTypePropertyCheck = 'Please select a type of property';
        check = false;
      });
    } else if (sPropertyStatus == null) {
      setState(() {
        sPropertyStatusCheck = 'Please select a property status';
        check = false;
      });
    } else if (sOwnership == null) {
      setState(() {
        sOwenershipCheck = 'Please select a ownership';
        check = false;
      });
    } else if (sRoms == null && sTypeId == '1') {
      setState(() {
        sRoomsCheck = 'Please select a rooms';
        check = false;
      });
    } else if (sBalconys == null && sTypeId == '1') {
      setState(() {
        sBalconyCheck = 'Please select a balcony counts';
        check = false;
      });
    } else if (sBathrooms == null) {
      setState(() {
        sBathroomCheck = 'Please select a bathroom status';
        check = false;
      });
    } else if (sParkings == null) {
      setState(() {
        sPrakingCheck = 'Please select a parking status';
        check = false;
      });
    } else {
      setState(() {
        check = true;
      });
    }

    if (check == true) {
      updateAndAddstep1();
    }
  }

  Widget commonCont({
    name,
    hint,
    value,
    list,
    funtn,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            name,
            style: Sty()
                .microText
                .copyWith(color: Clr().textGrey, fontWeight: FontWeight.w600),
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
                      borderSide: BorderSide(color: Clr().primaryColor),
                      borderRadius: BorderRadius.circular(55)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(55),
                      borderSide:
                          BorderSide(color: Clr().borderColor, width: 0.5)),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: Dim().d20,
                    vertical: Dim().d12,
                  )),
              isExpanded: true,
              hint: Text(
                value ?? hint,
                style: Sty().smallText.copyWith(
                      color: value != null ? Clr().black : Clr().hintColor,
                    ),
              ),
              icon: SvgPicture.asset(
                "assets/down_arrow.svg",
                color: Clr().textcolor,
              ),
              // style: TextStyle(color: Color(0xff2D2D2D)),
              items: list.map<DropdownMenuItem<String>>((dynamic string) {
                return DropdownMenuItem<String>(
                  value: string['id'].toString(),
                  child: Text(string['name'].toString(),
                      style: Sty().smallText.copyWith(
                            color: Clr().black,
                          )),
                );
              }).toList(),
              onChanged: funtn,
            ),
          ),
        ),
      ],
    );
  }

  /// Commercial Property Layout
  Widget commercialPropertyLayout(ctx) {
    return Column(
      children: [
        SizedBox(
          height: Dim().d20,
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  commonCont(
                      name: 'Property Status',
                      funtn: (v) {
                        setState(() {
                          sPropertyStatusId = v;
                          int pos = statusList.indexWhere((element) =>
                              element['id'].toString() == v.toString());
                          sPropertyStatus = statusList[pos]['name'];
                          sPropertyStatusCheck = null;
                        });
                      },
                      hint: 'Select Status',
                      list: statusList,
                      value: sPropertyStatus),
                  if (sPropertyStatusCheck != null)
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dim().d12, vertical: Dim().d4),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '$sPropertyStatusCheck',
                          style:
                              Sty().smallText.copyWith(color: Clr().errorRed),
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
                children: [
                  commonCont(
                      name: 'Ownership',
                      funtn: (v) {
                        setState(() {
                          sOwnershipId = v;
                          int pos = ownershipList.indexWhere((element) =>
                              element['id'].toString() == v.toString());
                          sOwnership = statusList[pos]['name'];
                          sOwenershipCheck = null;
                        });
                      },
                      hint: 'Select Buy/Rent',
                      list: ownershipList,
                      value: sOwnership),
                  if (sOwenershipCheck != null)
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dim().d12, vertical: Dim().d4),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '$sOwenershipCheck',
                          style:
                              Sty().smallText.copyWith(color: Clr().errorRed),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        if (sTypeId != '2')
          SizedBox(
            height: Dim().d20,
          ),
        sTypeId != '2'
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        commonCont(
                          funtn: (v) {
                            setState(() {
                              sRomsId = v;
                              int pos = roomsList.indexWhere((element) =>
                                  element['id'].toString() == v.toString());
                              sRoms = roomsList[pos]['name'];
                              sRoomsCheck = null;
                            });
                          },
                          hint: 'Select Rooms',
                          list: roomsList,
                          name: 'Rooms',
                          value: sRoms,
                        ),
                        if (sRoomsCheck != null)
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dim().d12, vertical: Dim().d4),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '$sRoomsCheck',
                                style: Sty()
                                    .smallText
                                    .copyWith(color: Clr().errorRed),
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
                      children: [
                        commonCont(
                          funtn: (v) {
                            setState(() {
                              sBalconys = v.toString();
                              sBalconyCheck = null;
                            });
                          },
                          hint: 'Select Balcony',
                          list: balconyList,
                          name: 'Balcony',
                          value: sBalconys,
                        ),
                        if (sBalconyCheck != null)
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: Dim().d12, vertical: Dim().d4),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '$sBalconyCheck',
                                style: Sty()
                                    .smallText
                                    .copyWith(color: Clr().errorRed),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              )
            : Container(),
        SizedBox(
          height: Dim().d20,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                children: [
                  commonCont(
                    funtn: (v) {
                      setState(() {
                        sBathroomsId = v;
                        int pos = bathroomList.indexWhere((element) =>
                            element['id'].toString() == v.toString());
                        sBathrooms = bathroomList[pos]['name'];
                        sBathroomCheck = null;
                      });
                    },
                    hint: sTypeId == '2' ? 'Select Yes/No' : 'Select Bathroom',
                    list: bathroomList,
                    name: sTypeId == '2' ? 'Washroom' : 'Bathroom',
                    value: sBathrooms,
                  ),
                  if (sBathroomCheck != null)
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dim().d12, vertical: Dim().d4),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '$sBathroomCheck',
                          style:
                              Sty().smallText.copyWith(color: Clr().errorRed),
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
                children: [
                  commonCont(
                    funtn: (v) {
                      setState(() {
                        sParkingsId = v;
                        int pos = parkingList.indexWhere((element) =>
                            element['id'].toString() == v.toString());
                        sParkings = parkingList[pos]['name'];
                        sPrakingCheck = null;
                      });
                    },
                    hint: 'Select Yes/No',
                    list: parkingList,
                    name: 'Parking Available?',
                    value: sParkings,
                  ),
                  if (sPrakingCheck != null)
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dim().d12, vertical: Dim().d4),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '$sPrakingCheck',
                          style:
                              Sty().smallText.copyWith(color: Clr().errorRed),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Commercial Property Layout
  Widget residentialPropertyLayout(ctx) {
    return Column(
      children: [
        SizedBox(
          height: Dim().d20,
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Ownership',
                      style: Sty().microText.copyWith(
                          color: Clr().textGrey, fontWeight: FontWeight.w600),
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
                                    color: Clr().borderColor, width: 0.5)),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: Dim().d20,
                              vertical: Dim().d12,
                            )),
                        // value: sCity,
                        isExpanded: true,
                        hint: Text(
                          sOwnership ?? 'Select Buy/Rent',
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
                            child: Text(string['name'].toString(),
                                style: Sty().smallText.copyWith(
                                      color: Clr().black,
                                    )),
                          );
                        }).toList(),
                        onChanged: (v) {
                          setState(() {
                            sOwnership = v;
                            print("City :: $sOwnership");
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
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Budget Range (in ₹)',
                      style: Sty().microText.copyWith(
                          color: Clr().textGrey, fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(
                    height: Dim().d4,
                  ),
                  TextFormField(
                    // controller: whatsappCtrl,
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },

                    cursorColor: Clr().textcolorsgray,
                    style: Sty().smallText,
                    keyboardType: TextInputType.number,
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
                                  // whatsappCtrl.text.isNotEmpty ||
                                  //     isFocused
                                  //     ? Clr().primaryColor
                                  //     :
                                  Clr().hintColor,
                            ),
                          ),
                          hintStyle: Sty()
                              .smallText
                              .copyWith(color: Clr().grey, fontFamily: "SF"),
                          hintText: "Min Value",
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
                  SizedBox(
                    height: Dim().d4,
                  ),
                  TextFormField(
                    // controller: whatsappCtrl,
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },

                    cursorColor: Clr().textcolorsgray,
                    style: Sty().smallText,
                    keyboardType: TextInputType.number,
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
                                  // whatsappCtrl.text.isNotEmpty ||
                                  //     isFocused
                                  //     ? Clr().primaryColor
                                  //     :
                                  Clr().hintColor,
                            ),
                          ),
                          hintStyle: Sty()
                              .smallText
                              .copyWith(color: Clr().grey, fontFamily: "SF"),
                          hintText: "Max Value",
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
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// getCities List Api
  void getCities() async {
    //Output
    var result =
        await STM().getwithToken(context, Str().loading, "get_cities", sToken);
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
    //Output
    var result = await STM()
        .getwithToken(context, Str().loading, "get_type_of_property", sToken);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(() {
        typeOfPropertyList = result['data'];
        getstatus();
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }

  void getstatus() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var result = await STM().allApi(
      apiname: 'get_status',
      ctx: ctx,
      token: sp.getString('token'),
      type: 'get',
      load: true,
      loadtitle: Str().loading,
    );
    if (result['success'] == true) {
      setState(() {
        statusList = result['data'];
        getrooms();
      });
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }

  void getrooms() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var result = await STM().allApi(
      apiname: 'get_rooms',
      ctx: ctx,
      token: sp.getString('token'),
      type: 'get',
      load: true,
      loadtitle: Str().loading,
    );
    if (result['success'] == true) {
      setState(() {
        roomsList = result['data'];
      });
      print(result);
      if (widget.data != null) {
        setState(() {
          int pos = propertyTypeList.indexWhere((element) =>
              element['id'].toString() ==
              widget.data['property_info']['property_type'].toString());
          sTypeId = widget.data['property_info']['property_type'].toString();
          sType = propertyTypeList[pos]['name'];
          sTypeOfPropertyId =
              widget.data['property_info']['property_type_id'].toString();
          int pos1 = typeOfPropertyList.indexWhere((element) =>
              element['id'].toString() ==
              widget.data['property_info']['property_type_id'].toString());
          sTypeOfProperty = typeOfPropertyList[pos1]['name'].toString();
          sPropertyStatusId =
              widget.data['property_info']['property_status_id'].toString();
          int pos2 = statusList.indexWhere((element) =>
              element['id'].toString() ==
              widget.data['property_info']['property_status_id'].toString());
          sPropertyStatus = statusList[pos2]['name'];

          sOwnershipId = widget.data['property_info']['ownership'].toString();
          int pos3 = ownershipList.indexWhere((element) =>
              element['id'].toString() ==
              widget.data['property_info']['ownership'].toString());
          sOwnership = ownershipList[pos3]['name'];

          sRomsId = widget.data['property_info']['room_id'].toString();
          int pos4 = roomsList.indexWhere((element) =>
              element['id'].toString() ==
              widget.data['property_info']['room_id'].toString());
          sRoms = roomsList[pos4]['name'];

          sBalconys = widget.data['property_info']['balcony'].toString();

          sBathroomsId = widget.data['property_info']['bathroom'].toString();
          int pos5 = sTypeId == '2'
              ? bathroomList.indexWhere((element) =>
                  element['id'].toString() ==
                  widget.data['property_info']['washroom'].toString())
              : bathroomList.indexWhere((element) =>
                  element['id'].toString() ==
                  widget.data['property_info']['bathroom'].toString());
          sBathrooms = bathroomList[pos5]['name'];

          sParkingsId = widget.data['property_info']['parking'].toString();
          int pos6 = parkingList.indexWhere((element) =>
              element['id'].toString() ==
              widget.data['property_info']['parking'].toString());
          sParkings = parkingList[pos6]['name'];
        });
      }
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }

  void updateAndAddstep1() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var result = await STM().allApi(
      apiname: 're/step2',
      ctx: ctx,
      load: true,
      loadtitle: Str().processing,
      token: sp.getString('token'),
      type: 'post',
      body: {
        "id": widget.data != null ? widget.data['property_info']['id'] : null,
        "property_id":
            widget.data != null ? widget.data['id'] : widget.property_id,
        "property_type_id": sTypeOfPropertyId,
        "property_type": sTypeId,
        "property_status_id": sPropertyStatusId,
        "balcony": sBalconys,
        "bathroom": sBathroomsId,
        "ownership": sOwnershipId,
        "parking": sParkingsId == '1' ? true : false,
        "room_id": sRomsId,
        "washroom": sBathroomsId == '1' ? true : false,
      },
    );
    if (result['success'] == true) {
      if (widget.data != null) {
        STM().successDialogWithReplace(
            ctx, result['message'], const estateList());
      } else {
        STM().redirect2page(
          ctx,
          step3Page(
            property_id: widget.property_id,
          ),
        );
        STM().displayToast(result['message']);
      }
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }
}
