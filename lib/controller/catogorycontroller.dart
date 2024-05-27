import 'package:shared_preferences/shared_preferences.dart';

import '../data/static_method.dart';

List categoryList = [];
List filterList = [];
List CatbannerList = [];
bool isLoaded = false;

class categoryController {
  void getCategoryApi(ctx, setState, id) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var result = await STM().allApi(
      apiname: 'get_subcategories',
      ctx: ctx,
      token: sp.getString('token'),
      type: 'post',
      body: {
        'category_id': id,
      },
    );
    if (result['success'] == true) {
      setState(() {
        isLoaded = true;
        categoryList = result['data']['subcategories'];
        CatbannerList = result['data']['banners'];
        filterList = categoryList;
      });
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }
}
