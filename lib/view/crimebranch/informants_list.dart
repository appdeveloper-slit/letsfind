import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/static_method.dart';
import '../../values/colors.dart';
import '../../values/dimens.dart';
import '../../values/strings.dart';
import '../../values/styles.dart';

class InformantsList extends StatefulWidget {
  final sCaseID;

  const InformantsList({Key? key, this.sCaseID}) : super(key: key);

  @override
  State<InformantsList> createState() => _InformantsListState();
}

class _InformantsListState extends State<InformantsList> {
  late BuildContext ctx;

  String? sToken;
  List<dynamic> informantsList = [];

  getsessionData() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sToken = sp.getString("token") ?? "";
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        caseLeads();
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
        title: Text(
          'Informants List',
          style: Sty().largeText.copyWith(
                color: Clr().primaryColor,
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dim().d16),
        child: Column(
          children: [
            if (informantsList.isEmpty)
              SizedBox(
                height: MediaQuery.of(ctx).size.height / 1.3,
                child: Center(
                  child: Text(
                    'No Data Found',
                    style: Sty().mediumText,
                  ),
                ),
              ),
            if (informantsList.isNotEmpty)
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.separated(
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          child: Divider(
                            color: Clr().borderColor,
                          ),
                          height: Dim().d40,
                        );
                      },
                      shrinkWrap: true,
                      padding: EdgeInsets.all(Dim().d20),
                      physics: const BouncingScrollPhysics(),
                      itemCount: informantsList.length,
                      itemBuilder: (context, index) {
                        return leadsLayout(ctx, index, informantsList);
                      },
                    ),
                  ],
                ),
              ),
            SizedBox(
              height: Dim().d20,
            ),
          ],
        ),
      ),
    );
  }

  ///Leads Layout
  Widget leadsLayout(ctx, index, list) {
    var v = informantsList[index];

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lead Name',
                  style: Sty().microText.copyWith(
                      color: Clr().hintColor, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: Dim().d4,
                ),
                Text(
                  // 'Dilip Khanna',
                  v['user']['name'].toString(),
                  style: Sty().smallText.copyWith(
                      color: Clr().textcolor, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Report Date',
                  style: Sty().microText.copyWith(
                      color: Clr().hintColor, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: Dim().d4,
                ),
                Text(
                  // '27th March 2024',
                  v['crime_case']['created_at'].toString(),
                  style: Sty().smallText.copyWith(
                      color: Clr().textcolor, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: Dim().d12,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mobile Number',
                  style: Sty().microText.copyWith(
                      color: Clr().hintColor, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: Dim().d4,
                ),
                Text(
                  // '+91 8384389492',
                  "+91 ${v['user']['mobile'].toString()}",
                  style: Sty().smallText.copyWith(
                      color: Clr().textcolor, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(
              width: 28,
              height: 28,
              child: ElevatedButton(
                onPressed: () {
                  STM().openDialer(
                    "+91 ${v['user']['mobile'].toString()}",
                    // "+91 8384389492",
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SvgPicture.asset(
                    "assets/call.svg",
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(55),
                    ),
                    backgroundColor: Clr().primaryColor),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Infomants case leads
  void caseLeads() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    FormData body = FormData.fromMap({
      'case_id': widget.sCaseID,
    });
    print("sCaseID :: ${widget.sCaseID}");
    var result = await STM().postWithToken(
        ctx, Str().loading, 'crime_branch/get_leads', body, sToken);
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(() {
        informantsList = result['data'];
        print('Information :: ${informantsList}');
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
