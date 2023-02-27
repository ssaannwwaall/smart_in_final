import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smarty/shared/res/colors.dart';
import 'Constants.dart';
import 'LocalDatabase.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:oktoast/oktoast.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class Helper {

  static Future<bool> isInternetAvailble() async {
    bool isConnectionSuccessful = false;
    try {
      final response = await InternetAddress.lookup('www.google.com');
      isConnectionSuccessful = response.isNotEmpty;
    } on SocketException catch (e) {
      isConnectionSuccessful = false;
    }
    return isConnectionSuccessful;
  }

  static bool logOut() {
    if (kDebugMode) {
      print('logout is going heree.....');
    }
    bool logout = false;
    try {

      LocalDatabase.setLogined(false);
      logout = true;
    } catch (e) {
      logout = false;
    }
    return logout;
  }

  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  static textViaSim(String phone, String msg) async {
    if (Platform.isAndroid) {
      var uri = 'sms:$phone?body=$msg%20there';
      await launch(uri);
    } else if (Platform.isIOS) {
      // iOS
      var uri = 'sms:$phone&body=$msg%20there';
      await launch(uri);
    }
  }

  static openEmailApp(String to,String msg) async {
    try {
      final url = 'mailto:$to?body=$msg';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        Helper.toast("App Email not found!", SmartyColors.grey60);
        
      }
    } catch (e) {
      Helper.toast("App Email not found!", SmartyColors.grey60);
    }
  }
  static launchURL(String url) async {
    if (kDebugMode) {
      print("url is $url");
    }
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
  static openWhatsapp() async {
    var androidUrl =
        "whatsapp://send?phone=${Constants.SUPPORT_PHONE_NUMBER}&text=Hi,";
    var iosUrl =
        "https://wa.me/${Constants.SUPPORT_PHONE_NUMBER}?text=${Uri.parse('Hi,')}";

    try {
      if (Platform.isIOS) {
        await launchUrl(Uri.parse(iosUrl));
      } else {
        await launchUrl(Uri.parse(androidUrl));
      }
    } on Exception {
      Helper.toast('WhatsApp is not installed.', SmartyColors.grey60);
    }
  }

  static void toast(String msg, Color clr) {
    showToast(
      msg,
      duration: const Duration(seconds: 3),
      position: ToastPosition.bottom,
      backgroundColor: clr,
      radius: 5.0,
      textPadding: const EdgeInsets.all(8),
      textStyle: const TextStyle(fontSize: 20.0),
    );
  }

  static showLoading(BuildContext context) {
    AlertDialog alert = AlertDialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // LoadingAnimationWidget.bouncingBall(
          //   color: Theme.of(context).primaryColor,
          //   size: 70,
          // ),
          LoadingAnimationWidget.beat(
            color: Theme.of(context).primaryColor,
            size: 80,
          ),
          //Text("sanwal")
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.white.withOpacity(0.2),
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static Widget loadingWidget(BuildContext context) {
    return SizedBox(
      child: LoadingAnimationWidget.beat(
        color: Theme.of(context).primaryColor,
        //leftDotColor: const Color(0xFF1A1A3F),
        //rightDotColor: const Color(0xFFEA3799),
        size: 70,
      ),
    );
  }

  static DateTime getCurrentTime() {
    return DateTime.now();
  }

  static void msgDialog(
      BuildContext context, String msg, Function()? functionHandler) {
    Dialog rejectDialogWithReason = Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    "Hi! ",
                    style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 16,
                        color: Colors.black),
                  ),
                ],
              ),
              SizedBox(height: 10.r,),
              Text(
                msg,
                style: const TextStyle(
                    fontWeight: FontWeight.w100,
                    fontSize: 16,
                    color: Colors.black),
              ),
              SizedBox(height: 10.r,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: functionHandler,
                      child: const Text(
                        'OK',
                        style: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 16,
                            color: Colors.black),
                      )),
                ],
              )
            ],
          ),
        ));
    showDialog(
        context: context,
        builder: (BuildContext context) => rejectDialogWithReason);
  }

  static void yesNoDialog(
      BuildContext context, String msg, Function()? functionHandlerYes,Function()? functionHandlerNo) {
    Dialog rejectDialogWithReason = Dialog(
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    "Hi! ",
                    style: TextStyle(
                        fontWeight: FontWeight.w100,
                        fontSize: 16,
                        color: Colors.black),
                  ),
                ],
              ),
              Text(
                msg,
                style: const TextStyle(
                    fontWeight: FontWeight.w100,
                    fontSize: 16,
                    color: Colors.black),
              ),
              SizedBox(height: 20.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: functionHandlerYes,
                      child: const Text(
                        'Yes',
                        style: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 16,
                            color: Colors.black),
                      )),
                  TextButton(
                      onPressed: functionHandlerNo,
                      child: const Text(
                        'No',
                        style: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 16,
                            color: Colors.black),
                      )),
                ],
              )
            ],
          ),
        ));
    showDialog(
        context: context,
        builder: (BuildContext context) => rejectDialogWithReason);
  }

  static Future<TimeOfDay> selectTime(BuildContext context) async {
    TimeOfDay selectedTime = TimeOfDay.now();
    final TimeOfDay? pickedS = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedS != null) selectedTime = pickedS;
    return selectedTime;
  }

  static Future<DateTime> selectDate(BuildContext context) async {
    DateTime selectedTime = DateTime.now();
    final DateTime? pickedS = await showDatePicker(
        context: context,
        initialDate: Helper.getCurrentTime(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (pickedS != null) selectedTime = pickedS;
    return selectedTime;
  }

}
