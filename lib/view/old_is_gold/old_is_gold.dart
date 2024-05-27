import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:letsfind/values/dimens.dart';
import 'package:letsfind/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:letsfind/values/colors.dart';
import 'package:letsfind/values/dimens.dart';
import 'package:letsfind/values/strings.dart';
import 'package:letsfind/values/styles.dart';
import '../../data/static_method.dart';
import 'og_category.dart';

class OldIsGold extends StatefulWidget {
  const OldIsGold({super.key});

  @override
  State<OldIsGold> createState() => _OldIsGoldState();
}

class _OldIsGoldState extends State<OldIsGold> {
  late BuildContext ctx;

  List<dynamic> catList = [];
  String? sToken;
  bool isLoaded = false;

  getsessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sToken = sp.getString("token" ?? "");
    STM().checkInternet(context, widget).then(
      (value) {
        if (value) {
          getCategory();
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
          'Old is Gold',
          style: Sty().largeText.copyWith(
                color: Clr().primaryColor,
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(Dim().d16),
        child: isLoaded
            ? Column(
                children: [
                  catList.isNotEmpty
                      ? Card(
                          elevation: 0,
                          surfaceTintColor: Clr().white,
                          color: Clr().white,
                          shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(Dim().d16),
                            borderSide: BorderSide(
                              color: Clr().borderColor,
                            ),
                          ),
                          child: ListView.separated(
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                child: Divider(
                                  color: Clr().borderColor,
                                ),
                                height: Dim().d6,
                              );
                            },
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: catList.length,
                            itemBuilder: (context, index) {
                              return cardLayout(ctx, index, catList);
                            },
                          ),
                        )
                      : Column(
                          children: [
                            SizedBox(
                              height: Dim().d140,
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
                                'No Categories Found',
                                style: Sty().mediumText.copyWith(
                                    fontSize: 20,
                                    color: Clr().primaryColor,
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          ],
                        ),
                ],
              )
            : Container(),
      ),
    );
  }

  Widget cardLayout(ctx, index, list) {
    var v = catList[index];

    return Column(
      children: [
        InkWell(
          onTap: () {
            STM().redirect2page(
                ctx,
                OGCategory(
                  slist: v['subcategories'],
                  sName: v['name'].toString(),
                  sID: v['id'].toString(),
                ));
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  // 'Cars',
                  v['name'].toString(),
                  style: Sty().smallText.copyWith(
                      fontWeight: FontWeight.w500, color: Clr().textcolor),
                ),
                Icon(
                  Icons.arrow_forward_ios_sharp,
                  size: 14,
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// get Categories List Api
  void getCategory() async {
    //Output
    var result = await STM().getwithToken(
        ctx, Str().loading, "old_gold_get_categories", sToken);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(
        () {
          isLoaded = true;
          catList = result['data']['categories'];
        },
      );
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
