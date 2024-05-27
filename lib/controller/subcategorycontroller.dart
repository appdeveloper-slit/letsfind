import 'package:shared_preferences/shared_preferences.dart';

import '../data/static_method.dart';

List shopList = [];
List favlist = [];

class subCategoryController {
  void getShops(ctx, setState, id) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var result = await STM().allApi(
      apiname: 'get_shops',
      ctx: ctx,
      token: sp.getString('token'),
      type: 'post',
      load: true,
      loadtitle: 'Loading...',
      body: {
        'subcategory_id': id,
      },
    );
    if (result['success'] == true) {
      setState(() {
        shopList = result['data']['shops'];
      });
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }

  void addFav(ctx, setState, id) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var result = await STM().allApi(
      apiname: 'favourite_shop',
      ctx: ctx,
      token: sp.getString('token'),
      type: 'post',
      body: {
        'shop_id': id,
      },
    );
    if (result['success'] == true) {
      setState(() {
        STM().displayToast(result['message']);
      });
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }

  void favList(ctx, setState) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var result = await STM().allApi(
      apiname: 'favourite_shops',
      ctx: ctx,
      token: sp.getString('token'),
      type: 'get',
    );
    if (result['success'] == true) {
      setState(() {
        favlist = result['data'];
      });
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }

  void addleads(ctx, setState, id) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var result = await STM().allApi(
      apiname: 'add_lead',
      body: {
        'shop_id': id,
      },
      ctx: ctx,
      load: false,
      token: sp.getString('token'),
      type: 'post',
    );
    if (result['success'] == true) {
      print(result['message']);
      print('Leads SuccessFully');
    } else {
      STM().displayToast(result['message']);
    }
  }
}
