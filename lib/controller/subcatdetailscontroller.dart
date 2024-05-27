import 'package:shared_preferences/shared_preferences.dart';

import '../data/static_method.dart';

var details;

class subcatdetilscontroller {
  void getshopDeatils(ctx, setState, id) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var result = await STM().allApi(
      apiname: 'shop_details',
      ctx: ctx,
      token: sp.getString('token'),
      type: 'post',
      load: true,
      loadtitle: 'Loading...',
      body: {
        'shop_id': id,
      },
    );
    if (result['success'] == true) {
      setState(() {
        details = result['data'];
      });
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }
}
