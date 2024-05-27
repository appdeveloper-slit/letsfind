// ignore_for_file: use_build_context_synchronously

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:letsfind/controller/homecontroller.dart';
import 'package:letsfind/values/colors.dart';
import 'package:letsfind/values/dimens.dart';
import 'package:letsfind/values/styles.dart';
import 'package:letsfind/view/category.dart';
import 'package:letsfind/view/old_is_gold/old_is_gold.dart';
import 'package:letsfind/view/sidedrawer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../bottomnavigation/bottomnavigationPage.dart';
import '../../data/static_method.dart';
import '../addestate/real_estate_details.dart';
import '../addestate/search_real_estate.dart';
import '../crime_report.dart';
import '../emergencyservices.dart';
import '../matrimony/matrimony_details.dart';
import '../matrimony/search_partner.dart';
import '../old_is_gold/og_subcat_details.dart';
import '../subcat_details.dart';
import 'appbarpage.dart';

GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

class Home extends StatefulWidget {
  final sMobile;

  const Home({super.key, this.sMobile});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late BuildContext ctx;

  int selectedSlider = 0;
  Position? position;
  var pincode;
  List carddetails = [
    {
      'color': 0XFFFFE0D1,
      'name': 'Old is Gold',
      'svg': "assets/old_is_gold.png"
    },
    {'color': 0XFFD1FFE0, 'name': 'Real Estate', 'svg': "assets/estate.png"},
    {'color': 0XFFFFF7D1, 'name': 'Matrimony', 'svg': "assets/matrimony.png"},
  ];

  getLocation() async {
    bool checkdevicelocation = await Geolocator.isLocationServiceEnabled();
    bool applocationServices = await Permission.location.isGranted;
    if (applocationServices) {
      position = await Geolocator.getCurrentPosition();
      List<Placemark> list = await placemarkFromCoordinates(
          position!.latitude, position!.longitude);
      pincode = list[0].postalCode;
      homeController().getHomeApi(context, setState, position!.latitude,
          position!.longitude, list[0].postalCode);
      print(list);
    } else {
      getLoc();
    }
  }

  getLoc() async {
    LocationPermission permission = await Geolocator.requestPermission();
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      position = await Geolocator.getCurrentPosition();
      List<Placemark> list = await placemarkFromCoordinates(
          position!.latitude, position!.longitude);
      pincode = list[0].postalCode;
      homeController().getHomeApi(context, setState, position!.latitude,
          position!.longitude, list[0].postalCode);
      print(list);
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      showModalBottomSheet(
        context: context,
        enableDrag: false,
        isDismissible: false,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: Dim().d20),
                  Text('Current Location',
                      style: Sty()
                          .mediumBoldText
                          .copyWith(color: Clr().primaryColor)),
                  SizedBox(height: Dim().d20),
                  Text('Please allow location access from device settings',
                      textAlign: TextAlign.center,
                      style: Sty().mediumText.copyWith(
                          color: const Color(0xff3F3F41),
                          fontSize: Dim().d14,
                          fontWeight: FontWeight.w400)),
                  SizedBox(height: Dim().d20),
                  Padding(
                    padding: EdgeInsets.all(Dim().d20),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () async {
                                await Geolocator.openAppSettings()
                                    .then((value) {
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    SystemNavigator.pop();
                                  });
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffFA3C5A),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(Dim().d16),
                                  )),
                              child: Padding(
                                padding:
                                    EdgeInsets.symmetric(vertical: Dim().d12),
                                child: Center(
                                  child: Text('Settings',
                                      style: Sty().mediumText.copyWith(
                                          color: Clr().white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: Dim().d16)),
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
    }
  }

  getSession() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    STM().checkInternet(context, widget).then((value) {
      if (value) {
        getLocation();
      }
    });
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      homeController().getHomeApi(
          context, setState, position!.latitude, position!.longitude, pincode);
      _refreshController.refreshCompleted();
    });
  }

  // ignore: prefer_final_fields
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    getSession();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return Scaffold(
        backgroundColor: Clr().background,
        bottomNavigationBar: bottomBarLayout(ctx, 0),
        appBar: appbarPageLayout().bar,
        key: scaffoldState,
        drawer: navBar(ctx, scaffoldState, setState),
        body: UpgradeAlert(
          barrierDismissible: false,
          showIgnore: false,
          showLater: false,
          showReleaseNotes: true,
          dialogStyle: UpgradeDialogStyle.material,
          onUpdate: () {
            Future.delayed(
              const Duration(seconds: 1),
              () {
                SystemNavigator.pop();
              },
            );
            return true;
          },
          child: SmartRefresher(
            controller: _refreshController,
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(Dim().d12),
              child: Column(
                children: [
                  sliderLayout(ctx),
                  SizedBox(
                    height: Dim().d20,
                  ),
                  SizedBox(
                    height: Dim().d150,
                    child: ListView.separated(
                      padding: EdgeInsets.symmetric(
                          vertical: Dim().d4, horizontal: Dim().d4),
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          width: Dim().d12,
                        );
                      },
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: carddetails.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return cardLayout(ctx, carddetails[index]);
                      },
                    ),
                  ),
                  SizedBox(
                    height: Dim().d20,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Clr().white,
                      borderRadius: BorderRadius.circular(Dim().d12),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          spreadRadius: 1,
                          color: Clr().borderColor,
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Container(
                            height: 35,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xffE4F2FF),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: Dim().d4, horizontal: Dim().d20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Explore Categories',
                                    style: Sty().smallText.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Clr().textcolor),
                                  ),
                                  // Text(
                                  //   'Show More',
                                  //   style: Sty().microText.copyWith(
                                  //       fontWeight: FontWeight.w800,
                                  //       color: Clr().red),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: Dim().d12,
                          ),
                          GridView.builder(
                              itemCount: categoriesList.length,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisExtent: 88,
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 20),
                              itemBuilder: (context, index) {
                                return categoryLayout(
                                    ctx, categoriesList[index]);
                              }),
                          SizedBox(
                            height: Dim().d20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Dim().d20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            STM().redirect2page(
                                ctx, const EmergensyServicesPage());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xffEBD8FF),
                                borderRadius: BorderRadius.circular(18)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/24.png',
                                    width: 50,
                                  ),
                                  SizedBox(
                                    width: Dim().d16,
                                  ),
                                  Text(
                                    'Emergency\nServices',
                                    style: Sty().smallText.copyWith(
                                        color: Clr().textcolor,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Dim().d20,
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            STM().redirect2page(ctx, const CrimeReport());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xffFFD4D4),
                                borderRadius: BorderRadius.circular(18)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'assets/crime_report.png',
                                    width: 50,
                                  ),
                                  SizedBox(
                                    width: Dim().d16,
                                  ),
                                  Text(
                                    'Crime\nReport',
                                    style: Sty().smallText.copyWith(
                                        color: Clr().textcolor,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Dim().d20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            STM().redirect2page(
                                ctx, const EmergensyServicesPage());
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xffFFE8AD),
                                borderRadius: BorderRadius.circular(18)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/mahanagar_palika.png',
                                    width: 50,
                                  ),
                                  SizedBox(
                                    width: Dim().d16,
                                  ),
                                  Text(
                                    'Mahanagar\nPalika',
                                    style: Sty().smallText.copyWith(
                                        color: Clr().textcolor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Dim().d20,
                      ),
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Dim().d40,
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget sliderLayout(ctx) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        viewportFraction: 0.9,
        height: 180,
        initialPage: 0,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        onPageChanged: (index, reason) {
          setState(() {
            selectedSlider = index;
          });
        },
      ),
      items: sliderList.map((url) {
        return Builder(
          builder: (BuildContext context) {
            return InkWell(
              onTap: () {
                STM().getLink(
                  link: url['link'],
                  linktype: url['link_type'],
                  moduleid: url['module_id'],
                  productid: url['product_id'],
                  ctx: ctx,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  url['image'],
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Widget categoryLayout(ctx, v) {
    return InkWell(
      onTap: () {
        STM().redirect2page(
          ctx,
          CategoryPage(
            data: v,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          imageLayout(v),
          SizedBox(height: Dim().d12),
          Text(
            v['name'],
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Sty().microText.copyWith(
                  color: Clr().black,
                  height: 1.2,
                  fontWeight: FontWeight.w500,
                ),
          )
        ],
      ),
    );
  }

  Widget imageLayout(v) {
    return Image.network(
      v['icon'],
      height: Dim().d40,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          // Image is done loading
          return child;
        } else {
          // Show a loading indicator
          return CircularProgressIndicator(
            color: Clr().primaryColor,
          );
        }
      },
      errorBuilder: (context, error, stackTrace) {
        return Image.network(
          'https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg',
          height: Dim().d36,
          fit: BoxFit.cover,
        );
      },
    );
  }

  ///card layout code
  Widget cardLayout(ctx, v) {
    return InkWell(
      onTap: () {
        v['name'] == 'Real Estate'
            ? STM().redirect2page(ctx, const SearchRealEstate())
            : v['name'] == 'Old is Gold'
                ? STM().redirect2page(ctx, OldIsGold())
                : v['name'] == 'Matrimony'
                    ? STM().redirect2page(ctx, SearchPartner())
                    : Container();
      },
      child: Container(
        width: Dim().d140,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Clr().shimmerColor.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 1)
          ],
          borderRadius: BorderRadius.circular(20),
          color: Color(v['color']),
        ),
        child: Padding(
          padding: EdgeInsets.all(Dim().d16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                v['svg'],
                height: Dim().d72,
              ),
              SizedBox(
                height: Dim().d8,
              ),
              Text(
                v['name'],
                style: Sty().smallText.copyWith(
                    color: Clr().textcolor, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
