// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letsfind/view/addestate/step4.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/static_method.dart';
import '../../values/colors.dart';
import '../../values/dimens.dart';
import '../../values/strings.dart';
import '../../values/styles.dart';
import 'esatelist.dart';

class step3Page extends StatefulWidget {
  final data, property_id;
  const step3Page({super.key, this.data, this.property_id});

  @override
  State<step3Page> createState() => _step3PageState();
}

class _step3PageState extends State<step3Page> {
  late BuildContext ctx;
  TextEditingController sqftCtrl = TextEditingController();
  TextEditingController carpCtrl = TextEditingController();
  TextEditingController tpriCtrl = TextEditingController();
  TextEditingController bookingamtCtrl = TextEditingController();
  TextEditingController registrPriCtrl = TextEditingController();
  TextEditingController reraidCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  getSession() async {
    if (widget.data != null) {
      setState(() {
        sqftCtrl = TextEditingController(
            text: widget.data['property_space']['builtup_area'].toString());
        carpCtrl = TextEditingController(
            text: widget.data['property_space']['carpet_area'].toString());
        tpriCtrl = TextEditingController(
            text: widget.data['property_space']['total_price'].toString());
        bookingamtCtrl = TextEditingController(
            text: widget.data['property_space']['booking_amount'].toString());
        registrPriCtrl = TextEditingController(
            text:
                widget.data['property_space']['registration_price'].toString());
        reraidCtrl = TextEditingController(
            text: widget.data['property_space']['rara_id'].toString());
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return WillPopScope(
      onWillPop: () async {
        widget.data != null
            ? STM().replacePage(ctx, estateList())
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
                  text: '3 ',
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: Dim().d20, vertical: Dim().d20),
                      decoration: BoxDecoration(
                        color: Clr().white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              spreadRadius: 1)
                        ],
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Property Spaces',
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
                              "Specify property area and booking amount",
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
                                  child: commonTextFormfiled(
                                      ctrl: sqftCtrl,
                                      hint: 'Builtup Area (sqft)',
                                      keyboardtype: TextInputType.number,
                                      name: 'Builtup Area (sqft)')),
                              SizedBox(
                                width: Dim().d16,
                              ),
                              Expanded(
                                child: commonTextFormfiled(
                                    ctrl: carpCtrl,
                                    hint: 'Carpet Area (sqft)',
                                    keyboardtype: TextInputType.number,
                                    name: 'Carpet Area (sqft)'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Dim().d20,
                          ),
                          commonTextFormfiled(
                              ctrl: tpriCtrl,
                              hint: 'Enter Total Amount',
                              keyboardtype: TextInputType.number,
                              name: 'Total Price'),
                          SizedBox(
                            height: Dim().d20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: commonTextFormfiled(
                                      ctrl: bookingamtCtrl,
                                      hint: 'Enter Amount',
                                      keyboardtype: TextInputType.number,
                                      name: 'Booking Amount')),
                              SizedBox(
                                width: Dim().d16,
                              ),
                              Expanded(
                                child: commonTextFormfiled(
                                    ctrl: registrPriCtrl,
                                    hint: 'Enter Amount',
                                    keyboardtype: TextInputType.number,
                                    name: 'Registration Price'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: Dim().d20,
                          ),
                          commonTextFormfiled(
                              ctrl: reraidCtrl,
                              hint: 'Enter RERA ID Number',
                              keyboardtype: TextInputType.text,
                              name: 'RERA ID'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dim().d120,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0, backgroundColor: Clr().primaryColor),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            updateAndAddstep1();
                          }
                          // // submitStep6();
                        },
                        child: Text(
                          widget.data != null ? 'Update' : 'Next',
                          style: Sty().mediumText.copyWith(color: Clr().white),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget commonTextFormfiled({name, ctrl, keyboardtype, hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dim().d16),
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
        TextFormField(
          controller: ctrl,
          keyboardType: keyboardtype,
          style: Sty().mediumText,
          decoration: Sty().TextFormFieldOutlineDarkStyle.copyWith(
                hintText: hint,
                hintStyle: Sty().smallText.copyWith(
                      color: Clr().hintColor,
                    ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(Dim().d56),
                  ),
                  borderSide: BorderSide(
                    color: Clr().black,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(Dim().d56),
                  ),
                  borderSide: BorderSide(
                    color: Clr().black,
                  ),
                ),
                filled: true,
                fillColor: Clr().white,
              ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'This field is required';
            }
            return null;
          },
        ),
      ],
    );
  }

  void updateAndAddstep1() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var result = await STM().allApi(
      apiname: 're/step3',
      ctx: ctx,
      load: true,
      loadtitle: Str().processing,
      token: sp.getString('token'),
      type: 'post',
      body: {
        "id": widget.data != null ? widget.data['property_space']['id'] : null,
        "property_id":
            widget.data != null ? widget.data['id'] : widget.property_id,
        "builtup_area": sqftCtrl.text,
        "carpet_area": carpCtrl.text,
        "total_price": tpriCtrl.text,
        "booking_amount": bookingamtCtrl.text,
        "registration_price": registrPriCtrl.text,
        "rara_id": reraidCtrl.text,
      },
    );
    if (result['success'] == true) {
      if (widget.data != null) {
        STM().successDialogWithReplace(
            ctx, result['message'], const estateList());
      } else {
        STM().redirect2page(
          ctx,
          amenitiesPage(
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
