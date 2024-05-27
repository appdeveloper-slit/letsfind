import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:letsfind/data/static_method.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../values/strings.dart';

List emergensyList = [];
List extarctList = [];
List cityList = [];

class emergensyController {
  void getEmergensyApi(ctx, setState) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var result = await STM().allApi(
      apiname: 'emergency_services',
      ctx: ctx,
      load: true,
      loadtitle: 'Loading...',
      token: sp.getString('token'),
      type: 'get',
    );
    if (result['success'] == true) {
      setState(() {
        emergensyList = result['data'];
        extarctList = result['data'][0]['emergency_service'];
        getCities(ctx, setState);
      });
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }

  /// getCities List Api
  void getCities(ctx, setState) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    //Output
    var result = await STM().getwithToken(
      ctx,
      Str().loading,
      "get_cities",
      sp.getString('token'),
    );
    var success = result['success'];
    var message = result['message'];
    if (success) {
      setState(() {
        cityList = result['data'];
      });
    } else {
      STM().errorDialog(ctx, message);
    }
  }
}
