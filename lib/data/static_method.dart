// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:letsfind/sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../values/colors.dart';
import '../values/dimens.dart';
import '../values/styles.dart';
import 'app_url.dart';

class STM {
  void redirect2page(BuildContext context, Widget widget) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }

  void replacePage(BuildContext context, Widget widget) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => widget,
      ),
    );
  }

  void back2Previous(BuildContext context) {
    Navigator.pop(context);
  }

  void displayToast(String string) {
    Fluttertoast.showToast(msg: string, toastLength: Toast.LENGTH_SHORT);
  }

  void displaySearchToast(String string) {
    Fluttertoast.showToast(
        msg: string,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM);
  }

  openWeb(String url) async {
    await launchUrl(Uri.parse(url.toString()));
  }

  void finishAffinity(final BuildContext context, Widget widget) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => widget,
      ),
      (Route<dynamic> route) => false,
    );
  }

  void successDialog(context, message, widget) {
    AwesomeDialog(
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.scale,
            headerAnimationLoop: true,
            title: 'Success',
            desc: message,
            btnOkText: "OK",
            btnOkOnPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => widget),
              );
            },
            btnOkColor: Clr().successGreen)
        .show();
  }

  AwesomeDialog successWithButton(context, message, function) {
    return AwesomeDialog(
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.scale,
        headerAnimationLoop: true,
        title: 'Success',
        desc: message,
        btnOkText: "OK",
        btnOkOnPress: function,
        btnOkColor: Clr().successGreen);
  }

  void successDialogWithAffinity(
      BuildContext context, String message, Widget widget) {
    AwesomeDialog(
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.scale,
            headerAnimationLoop: true,
            title: 'Success',
            desc: message,
            btnOkText: "OK",
            btnOkOnPress: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => widget,
                ),
                (Route<dynamic> route) => false,
              );
            },
            btnOkColor: Clr().successGreen)
        .show();
  }

  void errorDialogWithAffinity(
      BuildContext context, String message, Widget widget) {
    AwesomeDialog(
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.scale,
            headerAnimationLoop: true,
            title: 'Note',
            desc: message,
            btnOkText: "OK",
            btnOkOnPress: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => widget,
                ),
                (Route<dynamic> route) => false,
              );
            },
            btnOkColor: Clr().errorRed)
        .show();
  }

  void successDialogWithReplace(
      BuildContext context, String message, Widget widget) {
    AwesomeDialog(
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            context: context,
            dialogType: DialogType.success,
            animType: AnimType.scale,
            headerAnimationLoop: true,
            title: 'Success',
            desc: message,
            btnOkText: "OK",
            btnOkOnPress: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => widget,
                ),
              );
            },
            btnOkColor: Clr().successGreen)
        .show();
  }

  void errorDialog(BuildContext context, String message, {func}) {
    AwesomeDialog(
            context: context,
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            dialogType: DialogType.error,
            animType: AnimType.scale,
            headerAnimationLoop: true,
            title: 'Note',
            desc: message,
            btnOkText: "OK",
            btnOkOnPress: () {},
            btnOkColor: Clr().errorRed)
        .show();
  }

  void errorDialogWithReplace(
      BuildContext context, String message, Widget widget) {
    AwesomeDialog(
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            context: context,
            dialogType: DialogType.error,
            animType: AnimType.scale,
            headerAnimationLoop: true,
            title: 'Note',
            desc: message,
            btnOkText: "OK",
            btnOkOnPress: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => widget,
                ),
              );
            },
            btnOkColor: Clr().errorRed)
        .show();
  }

  AwesomeDialog loadingDialog(BuildContext context, String title) {
    AwesomeDialog dialog = AwesomeDialog(
      width: 250,
      context: context,
      dismissOnBackKeyPress: true,
      dismissOnTouchOutside: false,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      body: WillPopScope(
        onWillPop: () async {
          displayToast('Something went wrong try again.');
          return true;
        },
        child: Container(
          height: Dim().d160,
          padding: EdgeInsets.all(Dim().d16),
          decoration: BoxDecoration(
            color: Clr().white,
            borderRadius: BorderRadius.circular(Dim().d32),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(Dim().d12),
                child: SpinKitSquareCircle(
                  color: Clr().primaryColor,
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.all(Dim().d4),
              //   child:Lottie.asset('animation/ShrmaAnimation.json',height: 90,
              //       fit: BoxFit.cover),
              // ),
              // SizedBox(
              //   height: Dim().d16,
              // ),
              Text(
                title,
                style: Sty().mediumBoldText,
              ),
            ],
          ),
        ),
      ),
    );
    return dialog;
  }

  Widget sb({
    double? h,
    double? w,
  }) {
    return SizedBox(
      height: h,
      width: w,
    );
  }

  void alertDialog(context, message, widget) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        AlertDialog dialog = AlertDialog(
          title: Text(
            "Confirmation",
            style: Sty().largeText,
          ),
          content: Text(
            message,
            style: Sty().smallText,
          ),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {},
            ),
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
        return dialog;
      },
    );
  }

  AwesomeDialog modalDialog(context, widget, color) {
    AwesomeDialog dialog = AwesomeDialog(
      dialogBackgroundColor: color,
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      body: widget,
    );
    return dialog;
  }

  void mapDialog(BuildContext context, Widget widget) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      padding: EdgeInsets.zero,
      animType: AnimType.scale,
      body: widget,
      btnOkText: 'Done',
      btnOkColor: Clr().successGreen,
      btnOkOnPress: () {},
    ).show();
  }

  Widget setSVG(name, size, color) {
    return SvgPicture.asset(
      'assets/$name.svg',
      height: size,
      width: size,
      color: color,
    );
  }

  Widget emptyData(message) {
    return Center(
      child: Text(
        message,
        style: Sty().smallText.copyWith(
              color: Clr().primaryColor,
              fontSize: 18.0,
            ),
      ),
    );
  }

  List<BottomNavigationBarItem> getBottomList(index, b) {
    return [
      BottomNavigationBarItem(
        icon: index == 0
            ? SvgPicture.asset('assets/Home.svg')
            : SvgPicture.asset(
                "assets/homesvg.svg",
              ),
        label: 'Home',
        backgroundColor: index == 0 ? const Color(0xffBFDFFF) : Clr().white,
      ),
      BottomNavigationBarItem(
        icon: index == 1
            ? SvgPicture.asset('assets/searches.svg')
            : SvgPicture.asset(
                "assets/searchsvg.svg",
              ),
        label: 'Search',
        backgroundColor: index == 1 ? const Color(0xffBFDFFF) : Clr().white,
      ),
      BottomNavigationBarItem(
        icon: index == 2
            ? SvgPicture.asset('assets/Favourites.svg')
            : SvgPicture.asset(
                "assets/favsvg.svg",
              ),
        label: 'Favourites',
        backgroundColor: index == 2 ? const Color(0xffBFDFFF) : Clr().white,
      ),
      BottomNavigationBarItem(
        icon: Image.asset(
          "assets/logo.png",
          height: Dim().d28,
        ),
        label: 'My Listings',
      ),
    ];
  }

  //Dialer
  Future<void> openDialer(String phoneNumber) async {
    Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(Uri.parse(launchUri.toString()));
  }

  //WhatsApp
  Future<void> openWhatsApp(String phoneNumber) async {
    await launchUrl(Uri.parse("https://wa.me/$phoneNumber"));
    // if (Platform.isIOS) {
    //   await launchUrl(Uri.parse("whatsapp:wa.me/$phoneNumber"));
    // } else {
    //   await launchUrl(Uri.parse("whatsapp:send?phone=$phoneNumber"));
    // }
  }

  Future<bool> checkInternet(context, widget) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      internetAlert(context, widget);
      return false;
    }
  }

  internetAlert(context, widget) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      body: Padding(
        padding: EdgeInsets.all(Dim().d20),
        child: Column(
          children: [
            // SizedBox(child: Lottie.asset('assets/no_internet_alert.json')),
            Text(
              'Connection Error',
              style: Sty().largeText.copyWith(
                    color: Clr().primaryColor,
                    fontSize: 18.0,
                  ),
            ),
            SizedBox(
              height: Dim().d8,
            ),
            Text(
              'No Internet connection found.',
              style: Sty().smallText,
            ),
            SizedBox(
              height: Dim().d32,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Clr().primaryColor,
                ),
                onPressed: () async {
                  var connectivityResult =
                      await (Connectivity().checkConnectivity());
                  if (connectivityResult == ConnectivityResult.mobile ||
                      connectivityResult == ConnectivityResult.wifi) {
                    Navigator.pop(context);
                    STM().replacePage(context, widget);
                  }
                },
                child: Text(
                  "Try Again",
                  style: Sty().largeText.copyWith(
                        color: Clr().white,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    ).show();
  }

  String dateFormat(format, date) {
    return DateFormat(format).format(date).toString();
  }

  Future<dynamic> get(ctx, title, name) async {
    //Dialog
    AwesomeDialog dialog = STM().loadingDialog(ctx, title);
    dialog.show();
    Dio dio = Dio(
      BaseOptions(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.plain,
      ),
    );
    String url = AppUrl.mainUrl + name;
    dynamic result;
    try {
      Response response = await dio.get(url);
      if (kDebugMode) {
        print("Url = $url\nResponse = $response");
      }

      if (response.statusCode == 200) {
        dialog.dismiss();
        result = json.decode(response.data.toString());
      }
    } on DioError catch (e) {
      debugPrint(e.message);
    }
    return result;
  }

  Future<dynamic> getWithoutDialog(ctx, name) async {
    Dio dio = Dio(
      BaseOptions(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.plain,
      ),
    );
    String url = AppUrl.mainUrl + name;
    dynamic result;
    try {
      Response response = await dio.get(url);
      if (kDebugMode) {
        print("Url = $url\nResponse = $response");
      }
      if (response.statusCode == 200) {
        result = json.decode(response.data.toString());
      }
    } on DioError catch (e) {
      debugPrint(e.message);
    }
    return result;
  }

  Future<dynamic> postget(ctx, title, name, body, token) async {
    //Dialog
    AwesomeDialog dialog = STM().loadingDialog(ctx, title);
    dialog.show();
    Dio dio = Dio(
      BaseOptions(
        headers: {
          "Content-Type": "application/json",
          "responseType": "ResponseType.plain",
          "Authorization": "Bearer $token",
        },
      ),
    );
    String url = AppUrl.mainUrl + name;
    if (kDebugMode) {
      print("Url = $url\nBody = ${body.fields}");
    }
    dynamic result;
    try {
      Response response = await dio.post(url, data: body);
      if (kDebugMode) {
        print("Response = $response");
      }
      if (response.statusCode == 200) {
        dialog.dismiss();
        result = response.data;
        // result = json.decode(response.data.toString());
      }
    } on DioError catch (e) {
      debugPrint(e.message);
      // dialog.dismiss();
      // STM().errorDialog(ctx, e.message);
    }
    return result;
  }

  Future<dynamic> post(ctx, title, name, body) async {
    //Dialog
    AwesomeDialog dialog = STM().loadingDialog(ctx, title);
    dialog.show();
    Dio dio = Dio(
      BaseOptions(
        contentType: Headers.jsonContentType,
        responseType: ResponseType.plain,
      ),
    );
    String url = AppUrl.mainUrl + name;
    if (kDebugMode) {
      print("Url = $url\nBody = ${body.fields}");
    }
    dynamic result;
    try {
      Response response = await dio.post(url, data: body);
      if (kDebugMode) {
        print("Response = $response");
      }
      if (response.statusCode == 200) {
        dialog.dismiss();
        result = json.decode(response.data.toString());
      }
    } on DioError catch (e) {
      debugPrint(e.message);
      // STM().errorDialog(ctx, e.message);
    }
    return result;
  }

  Future<dynamic> postWithoutDialog(ctx, name, body, token) async {
    //Dialog
    Dio dio = Dio(
      BaseOptions(
        headers: {
          "Content-Type": "application/json",
          "responseType": "ResponseType.plain",
          "Authorization": "Bearer $token",
        },
      ),
    );
    String url = AppUrl.mainUrl + name;
    dynamic result;
    try {
      Response response = await dio.post(url, data: body);
      if (kDebugMode) {
        print("Url = $url\nBody = ${body.fields}\nResponse = $response");
      }
      if (response.statusCode == 200) {
        result = json.decode(response.data.toString());
      }
    } on DioError catch (e) {
      debugPrint(e.message);
    }
    return result;
  }

  // Future<dynamic> postWithoutDialog(ctx, name, body,token) async{
  //   Dio dio = Dio(
  //     BaseOptions(
  //       headers: {
  //         "Content-Type": "application/json",
  //         "responseType": "ResponseType.plain",
  //         "Authorization": "Bearer $token",
  //       },
  //     ),
  //   );
  //   String url = AppUrl.mainUrl + name;
  //   if (kDebugMode) {
  //     print("Url = $url\nBody = ${body.fields}");
  //   }
  //   dynamic result;
  //   try {
  //     Response response = await dio.post(url, data: body);
  //     if (kDebugMode) {
  //       print("Response = $response");
  //     }
  //     if (response.statusCode == 200) {
  //       result = response.data;
  //       // result = json.decode(response.data.toString());
  //     }
  //   } on DioError catch (e) {
  //     STM().errorDialog(ctx, e.message);
  //   }
  //   return result;
  // }

  Future<dynamic> postWithToken(ctx, title, name, body, token) async {
    //Dialog
    AwesomeDialog dialog = STM().loadingDialog(ctx, title);
    dialog.show();
    Dio dio = Dio(
      BaseOptions(
        headers: {
          "Content-Type": "application/json",
          "responseType": "ResponseType.plain",
          "Authorization": "Bearer $token",
        },
      ),
    );
    String url = AppUrl.mainUrl + name;
    if (kDebugMode) {
      print("Url = $url\nBody = ${body.fields}");
    }
    dynamic result;
    try {
      Response response = await dio.post(url, data: body);
      if (kDebugMode) {
        print("Response = $response");
      }
      if (response.statusCode == 200) {
        dialog.dismiss();
        result = response.data;
        // result = json.decode(response.data.toString());
      }
    } on DioError catch (e) {
      dialog.dismiss();
      STM().errorDialog(ctx, e.message.toString());
    }
    return result;
  }

  Future<dynamic> getwithToken(ctx, title, name, token) async {
    AwesomeDialog dialog = STM().loadingDialog(ctx, title);
    dialog.show();
    Dio dio = Dio(
      BaseOptions(
        headers: {
          "Content-Type": "application/json",
          "responseType": "ResponseType.plain",
          "Authorization": "Bearer $token",
        },
      ),
    );
    String url = AppUrl.mainUrl + name;
    if (kDebugMode) {
      // print("Url = $url\nBody = ${body.fields}");
    }
    dynamic result;
    try {
      Response response = await dio.get(url);
      if (kDebugMode) {
        print("Response = $response");
      }
      if (response.statusCode == 200) {
        dialog.dismiss();
        result = response.data;
      }
    } on DioError catch (e) {
      STM().errorDialog(ctx, e.message.toString());
    }
    return result;
  }

  Future<bool?> showToast(title) {
    return Fluttertoast.showToast(
        msg: title,
        backgroundColor: Clr().red,
        gravity: ToastGravity.BOTTOM,
        textColor: Clr().white,
        toastLength: Toast.LENGTH_LONG);
  }

  Future<dynamic> allApi({
    ctx,
    Map<String, dynamic>? body,
    apiname,
    type,
    token,
    bool? load,
    loadtitle,
  }) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    AwesomeDialog dialog =
        STM().loadingDialog(ctx, load == true ? loadtitle : '');
    load == true ? dialog.show() : null;
    String url = AppUrl.mainUrl + apiname;
    var headers = token != null
        ? {
            "Content-Type": "application/json",
            "responseType": "ResponseType.plain",
            "Authorization": "Bearer $token",
          }
        : {
            "Content-Type": "application/json",
            "responseType": "ResponseType.plain",
          };

    dynamic result;
    try {
      final response = type == 'post'
          ? await http.post(
              Uri.parse(url),
              body: json.encode(body),
              headers: headers,
            )
          : await http.get(
              Uri.parse(url),
              headers: headers,
            );
      if (response.statusCode == 200) {
        print(response.body);
        try {
          load == true ? dialog.dismiss() : null;
          result = json.decode(response.body.toString());
        } catch (_) {
          load == true ? dialog.dismiss() : null;
          result = response.body;
        }
      } else if (response.statusCode == 500) {
        load == true ? dialog.dismiss() : null;
        STM().errorDialog(
          ctx,
          'Something went wrong on the server side. Please try again later ${response.statusCode} Occurred in $apiname',
        );
      } else if (response.statusCode == 401) {
        load == true ? dialog.dismiss() : null;
        STM().errorDialog(ctx,
            'Something went wrong on the server side. Please try again later ${response.statusCode} Occurred in $apiname');
      } else if (response.statusCode == 403) {
        load == true ? dialog.dismiss() : null;
        sp.setBool('login', false);
        sp.clear();
        STM().errorDialogWithAffinity(
            ctx, 'Your account is inactive.', const SignIn());
      } else {
        load == true ? dialog.dismiss() : null;
        STM().errorDialog(ctx,
            'Something went wrong on the server side. Please try again later ${response.statusCode} Occurred  in $apiname');
      }
    } catch (e) {
      load == true ? dialog.dismiss() : null;
      if (e is TimeoutException) {
        showToast('TimeOut!!!,Please try again');
      } else if (e is CertificateException) {
        showToast(
            'CertificateException!!! SSL not verified while fetching data from $apiname');
      } else if (e is HandshakeException) {
        showToast(
            'HandshakeException!!! Connection not secure while fetching data from $apiname');
      } else if (e is FormatException) {
        showToast(
            'FormatException!!! Data cannot parse and unexpected format while fetching data from $apiname');
      } else {
        showToast('Something went wrong in  $apiname');
      }
    }
    return result;
  }

  Future<dynamic> postDialogToken2(ctx, title, name, body, token) async {
    AwesomeDialog dialog = STM().loadingDialog(ctx, title);
    dialog.show();
    Dio dio = Dio();
    String url = AppUrl.mainUrl + name;
    if (kDebugMode) {
      print("Url = $url\nBody = ${body}");
    }
    dynamic result;
    try {
      Response response = await dio.post(
        url,
        data: body,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            // Pass the token in the Authorization header
            'Content-Type': 'application/json',
            // Adjust content type based on your API requirements
          },
        ),
      );
      if (kDebugMode) {
        print("Response = $response");
      }
      if (response.statusCode == 200) {
        dialog.dismiss();
        result = response.data;

        // result = json.decode(response.data.toString());
      }
    } on DioError catch (e) {
      debugPrint(e.message);
      // STM().errorDialog(ctx, e.message);
    }
    return result;
  }

  Widget loadingPlaceHolder() {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 0.6,
        color: Clr().primaryColor,
      ),
    );
  }

  Widget imageView(Map<String, dynamic> v) {
    return v['url'].toString().contains('assets')
        ? Image.asset(
            '${v['url']}',
            width: v['width'],
            height: v['height'],
            fit: v['fit'] ?? BoxFit.fill,
          )
        : CachedNetworkImage(
            width: v['width'],
            height: v['height'],
            fit: v['fit'] ?? BoxFit.fill,
            imageUrl: v['url'] ??
                'https://www.famunews.com/wp-content/themes/newsgamer/images/dummy.png',
            placeholder: (context, url) => STM().loadingPlaceHolder(),
          );
  }

  CachedNetworkImage networkimg(url) {
    return url == null
        ? CachedNetworkImage(
            imageUrl:
                'https://liftlearning.com/wp-content/uploads/2020/09/default-image.png',
            fit: BoxFit.cover,
            imageBuilder: (context, imageProvider) => Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Clr().lightGrey),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
          )
        : CachedNetworkImage(
            imageUrl: '$url',
            fit: BoxFit.cover,
            imageBuilder: (context, imageProvider) => Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                // borderRadius: BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
          );
  }

  String formatAmount(amount) {
    if (amount >= 1000 && amount < 100000) {
      // Convert to "K" (thousands)
      return NumberFormat('#,##,##0.##', 'en_IN')
              .format(amount / 1000)
              .toString() +
          'K';
      ;
    } else if (amount >= 100000) {
      // Convert to "Lakh" (hundreds of thousands) with Indian Rupee symbol (₹)
      return NumberFormat('#,##,##0.###', 'en_IN')
              .format(amount / 100000)
              .toString() +
          ' Lac';
    } else {
      // Use regular formatting for smaller amounts
      return NumberFormat('#,##0', 'en_IN').format(amount);
    }
  }
}
