// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:letsfind/firebase_options.dart';
import 'package:letsfind/view/homelayout/home.dart';
import 'package:letsfind/data/fireremotepage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sign_in.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize('5a083ba4-3235-463c-a079-987d520ee4be');
  // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.Notifications.requestPermission(true);
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  SharedPreferences sp = await SharedPreferences.getInstance();
  bool isLogin = sp.getBool('login') ?? false;
  // firebaseConfig().intializeFireBaseC();
  // OneSignal.shared.setAppId('7880e9f7-4d17-4845-b4e2-32ef52d76305');
  // GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  // bool firstPage = sp.getBool('firstpage') ?? false;
  //Remove this method to stop OneSignal Debugging
  // OneSignal.logout();
  // OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  // OneSignal.initialize('1b317e72-c395-43ff-9c82-43959bdaa1ac');
  // The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt.
  // We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  // OneSignal.Notifications.requestPermission(true);
  // GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  //
  // OneSignal.Notifications.addClickListener((event) {
  //   navigatorKey.currentState!.push(
  //     MaterialPageRoute(
  //       builder: (context) => NotificationPage(),
  //     ),
  //   );
  // });

  await Future.delayed(const Duration(seconds: 3));
  runApp(
    FlutterSizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          builder: (context, child) {
            return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: child!);
          },
          // navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          home: isLogin ? const Home() : const SignIn(),
        );
      },
    ),
  );
}
