// ignore_for_file: use_build_context_synchronously

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:letsfind/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/static_method.dart';
import '../../values/colors.dart';
import '../../values/dimens.dart';
import '../../values/styles.dart';
import 'esatelist.dart';

class amenitiesPage extends StatefulWidget {
  final data, property_id;
  const amenitiesPage({super.key, this.data, this.property_id});

  @override
  State<amenitiesPage> createState() => _amenitiesPageState();
}

class _amenitiesPageState extends State<amenitiesPage> {
  late BuildContext ctx;
  List<Map<String, dynamic>> emenitiesList = [];
  final _formKey = GlobalKey<FormState>();

  getSession() async {
    if (widget.data != null) {
      for (int a = 0; a < widget.data['amenity'].length; a++) {
        setState(() {
          emenitiesList.add({
            'name': TextEditingController(
                text: widget.data['amenity'][a]['name'].toString()),
          });
        });
      }
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
                  text: '4 ',
                  style: Sty().smallText.copyWith(
                        color: const Color(0xffFF8000),
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
                            'Amenities',
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
                            "Add amenities for your property.",
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
                        InkWell(
                          onTap: () {
                            setState(() {
                              emenitiesList.add({
                                'name': TextEditingController(text: ''),
                              });
                            });
                          },
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            dashPattern: [Dim().d8, Dim().d8],
                            color: Clr().primaryColor,
                            radius: Radius.circular(Dim().d56),
                            strokeWidth: 0.8,
                            padding: EdgeInsets.all(Dim().d6),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(Dim().d12)),
                              child: SizedBox(
                                height: 30,
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    'Add Amenities',
                                    style: Sty().smallText.copyWith(
                                        color: Clr().primaryColor,
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
                SizedBox(
                  height: Dim().d20,
                ),
                ListView.builder(
                  itemCount: emenitiesList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: Dim().d20),
                      padding: EdgeInsets.symmetric(
                          horizontal: Dim().d20, vertical: Dim().d20),
                      decoration: BoxDecoration(
                        color: Clr().white,
                        borderRadius: BorderRadius.circular(Dim().d16),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              spreadRadius: 1)
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Amenity ${(index + 1)}',
                                style: Sty().mediumText.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    emenitiesList.removeAt(index);
                                  });
                                },
                                child: Icon(
                                  Icons.dangerous_outlined,
                                  color: Clr().errorRed,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: Dim().d20,
                          ),
                          TextFormField(
                            controller: emenitiesList[index]['name'],
                            style: Sty().smallText,
                            decoration:
                                Sty().TextFormFieldOutlineDarkStyle.copyWith(
                                      hintText: 'Enter the amenities',
                                      hintStyle: Sty().smallText.copyWith(
                                            color: Clr().hintColor,
                                          ),
                                    ),
                            validator: (v) {
                              if (v!.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                          )
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: Dim().d32,
                ),
                SizedBox(
                  height: Dim().d48,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (emenitiesList.isNotEmpty) {
                          addamenitiesUpdate();
                        } else {
                          STM().displayToast('Please add some emenities');
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Clr().primaryColor,
                    ),
                    child: Center(
                      child: Text(
                        widget.data != null ? 'Update' : 'Submit',
                        style: Sty().mediumText.copyWith(color: Clr().white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addamenitiesUpdate() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    List emenitesNameList = [];
    for (int a = 0; a < emenitiesList.length; a++) {
      setState(() {
        emenitesNameList.add(emenitiesList[a]['name'].text.toString());
      });
    }
    print(emenitesNameList);
    var result = await STM().allApi(
      apiname: 're/step4',
      ctx: ctx,
      load: true,
      loadtitle: Str().processing,
      token: sp.getString('token'),
      type: 'post',
      body: {
        "property_id":
            widget.data != null ? widget.data['id'] : widget.property_id,
        "amenities": emenitesNameList,
      },
    );

    if (result['success'] == true) {
      STM()
          .successDialogWithReplace(ctx, result['message'], const estateList());
      STM().displayToast(result['message']);
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }
}
