import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:letsfind/view/sub_category.dart';
import 'package:letsfind/values/dimens.dart';
import 'package:letsfind/values/strings.dart';
import 'package:letsfind/values/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/catogorycontroller.dart';
import '../data/static_method.dart';
import '../values/colors.dart';

class CategoryPage extends StatefulWidget {
  final data;

  const CategoryPage({super.key, this.data});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late BuildContext ctx;
  TextEditingController editingController = TextEditingController();
  int selectedSlider = 0;
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      categoryController().getCategoryApi(
        ctx,
        setState,
        widget.data['id'],
      );
    });
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
          widget.data['name'],
          style: Sty().largeText.copyWith(
                color: Clr().primaryColor,
                fontWeight: FontWeight.w800,
              ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dim().d16),
        child: isLoaded
            ? Column(
                children: [
                  if (CatbannerList.isNotEmpty) sliderLayout(ctx),
                  TextFormField(
                    controller: editingController,
                    keyboardType: TextInputType.text,
                    onChanged: searchresult,
                    decoration: Sty().TextFormFieldOutlineDarkStyle.copyWith(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: Dim().d16, horizontal: Dim().d16),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset(
                              'assets/search.png',
                              height: Dim().d20,
                              width: Dim().d20,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xffBFDFFF),
                            ),
                            borderRadius: BorderRadius.circular(
                              Dim().d56,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xffBFDFFF),
                            ),
                            borderRadius: BorderRadius.circular(
                              Dim().d56,
                            ),
                          ),
                          hintText: 'Search By Categories...',
                          hintStyle:
                              Sty().smallText.copyWith(color: Clr().hintColor),
                        ),
                  ),
                  SizedBox(
                    height: Dim().d20,
                  ),
                  if (categoryList.isNotEmpty)
                    Container(
                      margin: EdgeInsets.zero,
                      decoration: BoxDecoration(
                        color: Clr().white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Clr().borderColor,
                            blurRadius: 4,
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(
                            height: Dim().d16,
                          ),
                          ListView.separated(
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: Dim().d6,
                              );
                            },
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: filterList.length,
                            itemBuilder: (context, index) {
                              return listLayout(ctx, filterList[index]);
                            },
                          ),
                        ],
                      ),
                    ),
                ],
              )
            : Container(),
      ),
    );
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
      items: CatbannerList.map((url) {
        return Padding(
          padding: EdgeInsets.only(bottom: Dim().d12),
          child: Builder(
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
          ),
        );
      }).toList(),
    );
  }

  Widget listLayout(ctx, v) {
    return InkWell(
      onTap: () {
        STM().redirect2page(
          ctx,
          SubCategoryPage(
            data: v,
          ),
        );
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: Dim().d8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  v['name'],
                  style: Sty().smallText.copyWith(
                      fontWeight: FontWeight.w500, color: Clr().textcolor),
                ),
                const Icon(
                  Icons.arrow_forward_ios_sharp,
                  size: 14,
                )
              ],
            ),
          ),
          SizedBox(
            height: Dim().d8,
          ),
          if (categoryList.length > 1)
            Divider(
              color: Clr().borderColor.withOpacity(0.5),
            ),
        ],
      ),
    );
  }

  void searchresult(String value) {
    if (value.isEmpty) {
      setState(() {
        filterList = categoryList;
      });
    } else {
      setState(() {
        filterList = categoryList.where((element) {
          final resultTitle = element['name'].toLowerCase();
          final input = value.toLowerCase();
          return element['name']
              .toString()
              .toLowerCase()
              .contains(value.toLowerCase());
        }).toList();
      });
    }
  }
}
