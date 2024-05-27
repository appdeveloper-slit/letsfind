import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:letsfind/bottomnavigation/bottomnavigationPage.dart';
import 'package:letsfind/controller/reviewdetailscontroller.dart';
import 'package:letsfind/values/dimens.dart';
import 'package:letsfind/view/sub_category.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../data/static_method.dart';
import '../values/colors.dart';
import '../values/styles.dart';

class reviewdetailsPage extends StatefulWidget {
  final id, type, data;

  const reviewdetailsPage({super.key, this.id, this.type, this.data});

  @override
  State<reviewdetailsPage> createState() => _reviewdetailsPageState();
}

class _reviewdetailsPageState extends State<reviewdetailsPage> {
  late BuildContext ctx;
  double ratingUser = 0.0;
  final _formKey = GlobalKey<FormState>();
  TextEditingController revCtrl = TextEditingController();
  bool isLoaded = false;

  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () {
        reviewDetailsController().getReviewsApi(ctx, setState, widget.id);
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;

    print("Data :: ${widget.data}");

    return Scaffold(
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
          'Reviews',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Sty().largeText.copyWith(
                color: Clr().primaryColor,
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: Dim().d20),
        child: Column(
          children: [
            SizedBox(
              height: Dim().d20,
            ),
            Container(
              decoration: BoxDecoration(
                color: Clr().white,
                borderRadius: BorderRadius.all(
                  Radius.circular(Dim().d12),
                ),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 5,
                    spreadRadius: 1,
                    color: Colors.black12,
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(Dim().d12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        reviewDetails == null
                            ? Container()
                            : Expanded(
                                child: ListView.builder(
                                  itemCount:
                                      reviewDetails['rating_count'].length,
                                  shrinkWrap: true,
                                  physics:
                                      const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    String rating =
                                        reviewDetails['rating_count']
                                            .keys
                                            .toList()[index];
                                    double count = double.parse(
                                            reviewDetails['rating_count']
                                                .values
                                                .toList()[index]
                                                .toStringAsFixed(2)
                                                .toString()) /
                                        100;
                                    return Row(
                                      children: [
                                        Text(rating, style: Sty().largeText),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: Dim().d2),
                                          child: LinearPercentIndicator(
                                            width: Dim().d180,
                                            animation: true,
                                            lineHeight: 10.0,
                                            animationDuration: 2500,
                                            percent: count,
                                            linearStrokeCap:
                                                LinearStrokeCap.roundAll,
                                            progressColor: Colors.yellow[700],
                                            barRadius:
                                                Radius.circular(Dim().d4),
                                            backgroundColor: Color(0xff000000)
                                                .withOpacity(0.1),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text:
                                    reviewDetails['averageRating'].toString(),
                                style: Sty()
                                    .extraLargeText
                                    .copyWith(color: Clr().successGreen),
                                children: [
                                  TextSpan(
                                    text: ' / 5',
                                    style: Sty().smallText.copyWith(
                                          color: Clr().grey,
                                        ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: Dim().d8,
                            ),
                            Text(
                              '(${reviewDetails['reviews'].length} Reviews )',
                              style: Sty()
                                  .smallText
                                  .copyWith(color: Clr().hintColor),
                            ),
                          ],
                        )
                      ],
                    ),
                    if (widget.type != 'update')
                      SizedBox(
                        height: Dim().d20,
                      ),
                    if (widget.type != 'update')
                      InkWell(
                        onTap: () {
                          opendialog();
                        },
                        child: Container(
                          height: Dim().d44,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Clr().primaryColor,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(Dim().d20),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Write a Review',
                              style: Sty().mediumText.copyWith(
                                    color: Clr().primaryColor,
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
            Container(
              decoration: BoxDecoration(
                color: Clr().white,
                borderRadius: BorderRadius.all(
                  Radius.circular(Dim().d12),
                ),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 5,
                    spreadRadius: 1,
                    color: Colors.black12,
                  ),
                ],
              ),
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: reviewDetails['reviews'].length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(Dim().d12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        reviewDetails['reviews'][index]
                                            ['user']['name'],
                                        style: Sty().largeText,
                                      ),
                                    ),
                                    RatingBar.builder(
                                      initialRating: double.parse(
                                          reviewDetails['reviews'][index]
                                                  ['rating']
                                              .toString()),
                                      minRating: double.parse(
                                          reviewDetails['reviews'][index]
                                                  ['rating']
                                              .toString()),
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 20.0,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        size: 4.0,
                                        color: Colors.amber,
                                      ),
                                      onRatingUpdate: (rating) {
                                        print(rating);
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: Dim().d20,
                                ),
                                Text(
                                  reviewDetails['reviews'][index]['review'],
                                  style: Sty().smallText,
                                ),
                                SizedBox(
                                  height: Dim().d20,
                                ),
                                Text(
                                  DateFormat('dd MMMM yyyy').format(
                                      DateTime.parse(reviewDetails['reviews']
                                              [index]['created_at']
                                          .toString())),
                                  style: Sty().smallText.copyWith(
                                        color: Clr().hintColor,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          if (reviewDetails['reviews'].length > 1)
                            index == (reviewDetails['reviews'].length - 1)
                                ? Container()
                                : const Divider()
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Dim().d12,
            ),
          ],
        ),
      ),
    );
  }

  opendialog() {
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.noHeader,
        animType: AnimType.scale,
        body: Padding(
          padding: EdgeInsets.all(Dim().d12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RatingBar.builder(
                  initialRating: ratingUser,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 40.0,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    size: 4.0,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      ratingUser = rating;
                    });
                  },
                ),
                SizedBox(
                  height: Dim().d20,
                ),
                TextFormField(
                  controller: revCtrl,
                  maxLines: 3,
                  decoration: Sty().TextFormFieldOutlineDarkStyle.copyWith(
                        hintText: 'Write a Review...',
                        hintStyle: Sty().smallText.copyWith(
                              color: Clr().hintColor,
                            ),
                      ),
                  validator: (v) {
                    if (v!.isEmpty) {
                      return 'Please write a review';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: Dim().d20,
                ),
                AnimatedButton(
                  pressEvent: () {
                    if (_formKey.currentState!.validate()) {
                      if (ratingUser != 0.0) {
                        reviewDetailsController().writeaReviewApi(
                          ctx,
                          setState,
                          {
                            'id': widget.id,
                            'rating': ratingUser,
                            'review': revCtrl.text,
                          },
                        );
                      } else {
                        STM().displayToast('Please give a rating ☹🙁☹');
                      }
                    }
                  },
                  borderRadius: BorderRadius.all(
                    Radius.circular(Dim().d56),
                  ),
                  height: Dim().d48,
                  text: 'Submit',
                  color: Clr().primaryColor,
                ),
                SizedBox(
                  height: Dim().d20,
                ),
              ],
            ),
          ),
        )).show();
  }
}
