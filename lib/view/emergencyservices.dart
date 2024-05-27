import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:letsfind/bottomnavigation/bottomnavigationPage.dart';
import 'package:letsfind/controller/emergensycontroller.dart';
import 'package:letsfind/values/dimens.dart';

import '../data/static_method.dart';
import '../values/colors.dart';
import '../values/styles.dart';

class EmergensyServicesPage extends StatefulWidget {
  const EmergensyServicesPage({super.key});

  @override
  State<EmergensyServicesPage> createState() => _EmergensyServicesPageState();
}

class _EmergensyServicesPageState extends State<EmergensyServicesPage> {
  late BuildContext ctx;
  int _selectIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () {
      emergensyController().getEmergensyApi(ctx, setState);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
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
          'Emergency Services',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Sty().largeText.copyWith(
                color: Clr().primaryColor,
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: Dim().d12,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: Dim().d12, vertical: Dim().d20),
              child: Container(
                decoration: BoxDecoration(
                  color: Clr().white,
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 5,
                      spreadRadius: 1,
                      color: Colors.black12,
                    ),
                  ],
                  // borderRadius: BorderRadius.all(
                  //   Radius.circular(Dim().d12),
                  // ),
                ),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.double_arrow_outlined,
                        size: 15.0,
                      ),
                    ),
                    SizedBox(
                      height: Dim().d48,
                      width: double.infinity,
                      child: ListView.builder(
                        itemCount: emergensyList.length,
                        shrinkWrap: true,
                        // ignore: prefer_const_constructors
                        physics: AlwaysScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              // borderRadius: index == 0
                              //     ? BorderRadius.only(
                              //         topLeft: Radius.circular(Dim().d12),
                              //       )
                              //     : BorderRadius.zero,
                              color: Clr().white,
                              border: Border(
                                bottom: BorderSide(
                                  color: _selectIndex == index
                                      ? Clr().black
                                      : Clr().lightGrey,
                                ),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dim().d12, vertical: Dim().d8),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    extarctList = emergensyList[index]
                                        ['emergency_service'];
                                    _selectIndex = index;
                                    print(extarctList);
                                  });
                                },
                                child: Text(
                                  emergensyList[index]['name'],
                                  style: Sty().mediumText,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    ListView.builder(
                      itemCount: extarctList.length,
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: extarctList.length - 1 == index
                                    ? Colors.transparent
                                    : Colors.black26,
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      extarctList[index]['name'],
                                      style: Sty().smallText,
                                    ),
                                    SizedBox(
                                      height: Dim().d2,
                                    ),
                                    Text(
                                      extarctList[index]['mobile'],
                                      style: Sty()
                                          .microText
                                          .copyWith(color: Clr().hintColor),
                                    ),
                                    SizedBox(
                                      height: Dim().d2,
                                    ),
                                    Text(
                                      cityList[cityList.indexWhere((e) =>
                                              e['id'].toString() ==
                                              extarctList[index]['city_id']
                                                  .toString())]['name']
                                          .toString(),
                                      style: Sty()
                                          .microText
                                          .copyWith(color: Clr().hintColor),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  await STM()
                                      .openDialer(extarctList[index]['mobile']);
                                },
                                child: SizedBox(
                                  child:
                                      SvgPicture.asset('assets/phonecall.svg'),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
