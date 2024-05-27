import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:letsfind/data/static_method.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

List sliderList = [];
List categoriesList = [];

class homeController {
  void getHomeApi(ctx, setState, lat, lng) async {
    AwesomeDialog dialog = STM().loadingDialog(ctx, "Loading...");
    dialog.show();
    SharedPreferences sp = await SharedPreferences.getInstance();
    var result = await STM().allApi(
      apiname: 'home',
      ctx: ctx,
      token: sp.getString('token'),
      type: 'post',
      body: {
        'uuid': OneSignal.User.pushSubscription.id,
        'lattitude': lat,
        'longitude': lng,
      },
    );
    print(OneSignal.User.pushSubscription.id);
    if (result['success'] == true) {
      setState(() {
        dialog.dismiss();
        sliderList = result['data']['banners'];
        categoriesList = result['data']['categories'];
        sliderList.isEmpty
            ? sliderList.add(
                {
                  'image':
                      'https://www.generationsforpeace.org/wp-content/uploads/2018/03/empty.jpg',
                },
              )
            : null;
      });
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }
}
