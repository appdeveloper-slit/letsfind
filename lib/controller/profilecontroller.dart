import 'package:flutter/material.dart';
import 'package:letsfind/data/static_method.dart';
import 'package:shared_preferences/shared_preferences.dart';

TextEditingController namCtrl = TextEditingController();
TextEditingController mobCtrl = TextEditingController();
TextEditingController emlCtrl = TextEditingController();

class profileController {
  void getProfile(ctx, setState) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var result = await STM().allApi(
      apiname: 'profile_details',
      ctx: ctx,
      load: true,
      loadtitle: 'Loading...',
      token: sp.getString('token'),
      type: 'get',
    );
    if (result['success'] == true) {
      setState(() {
        namCtrl = TextEditingController(text: result['data']['name']);
        mobCtrl = TextEditingController(text: result['data']['mobile']);
        emlCtrl = TextEditingController(text: result['data']['email']);
        // STM().displayToast(result['message']);
      });
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }

  void addProfile(ctx, setState, data) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var result = await STM().allApi(
      apiname: 'update_profile',
      ctx: ctx,
      load: true,
      loadtitle: 'Updating...',
      token: sp.getString('token'),
      type: 'post',
      body: {
        "name": data['name'],
        "email": data['email'],
      },
    );
    if (result['success'] == true) {
      setState(() {
        namCtrl = TextEditingController(text: result['data']['name']);
        mobCtrl = TextEditingController(text: result['data']['mobile']);
        emlCtrl = TextEditingController(text: result['data']['email']);
        STM().displayToast(result['message']);
      });
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }

  void updateMobile(ctx, setState, data) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var result = await STM().allApi(
      apiname: 'update_mobile_verify_otp',
      ctx: ctx,
      load: true,
      loadtitle: 'Updating...',
      token: sp.getString('token'),
      type: 'post',
      body: {
        "mobile": data['mobile'],
        "otp": data['otp'],
      },
    );
    if (result['success'] == true) {
      setState(() {
        mobCtrl = TextEditingController(text: result['data']['mobile']);
        STM().displayToast(result['message']);
        STM().back2Previous(ctx);
      });
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }
}
