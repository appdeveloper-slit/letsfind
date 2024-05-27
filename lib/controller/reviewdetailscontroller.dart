import 'package:shared_preferences/shared_preferences.dart';

import '../data/static_method.dart';

var reviewDetails;
bool isLoaded = false;

class reviewDetailsController {
  void getReviewsApi(ctx, setState, id) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var result = await STM().allApi(
      apiname: 'get_reviews',
      ctx: ctx,
      token: sp.getString('token'),
      type: 'post',
      body: {
        'shop_id': id,
      },
    );
    if (result['success'] == true) {
      setState(() {
         isLoaded = true;
        reviewDetails = result['data'];
      });
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }

  void writeaReviewApi(ctx, setState, data) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var result = await STM().allApi(
      apiname: 'add_review',
      ctx: ctx,
      token: sp.getString('token'),
      type: 'post',
      body: {
        "shop_id": data['id'],
        "rating": data['rating'],
        "review": data['review'],
      },
    );
    if (result['success'] == true) {
      setState(() {
        STM().back2Previous(ctx);
        STM().displayToast(result['message']);
        getReviewsApi(ctx, setState, data['id']);
      });
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }
}
