import '../data/static_method.dart';
import '../otp.dart';
import '../values/strings.dart';

class signuController {
  void registerUserApi(ctx, {nameCtrl, mobileCtrl, emailCtrl}) async {
    var body = {
      "name": nameCtrl,
      "mobile": mobileCtrl,
      "email": emailCtrl,
    };
    var result = await STM().allApi(
      apiname: 'send_otp',
      body: body,
      ctx: ctx,
      load: true,
      loadtitle: 'Sending OTP...',
      type: 'post',
    );
    if (result['success'] == true) {
      STM().redirect2page(
        ctx,
        OTP(
          registerData: {
            "name": nameCtrl,
            "mobile": mobileCtrl,
            "email": emailCtrl,
          },
        ),
      );
    } else {
      STM().errorDialog(ctx, result['message']);
    }
  }

  emailValidaion(value) {
    if (value!.isEmpty) {
      return '*Please enter an email id';
    }
    if (!RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(value)) {
      return '*Please enter a valid email address';
    }
    return null;
  }

  mobileValidation(value) {
    if (value!.isEmpty || !RegExp(r'([5-9]{1}[0-9]{9})').hasMatch(value)) {
      return Str().invalidMobile;
    } else {
      return null;
    }
  }

  nameValidation(value) {
    if (value!.isEmpty) {
      return Str().invalidName;
    } else {
      return null;
    }
  }

  userTypeValidation(value) {
    if (value == null) {
      return 'Please select a user type';
    } else {
      return null;
    }
  }
}
