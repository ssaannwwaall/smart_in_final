import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarty/utils/enums.dart';
import '../features/devices/domain/models/devices.dart';


class LocalDatabase {
  static const String _userIsLogined = 'userisLogined';

  static String SERVER_DOMAIN = "domain_key";
  static String SERVER_PORT = "port_key";
  static String SERVER_USER_NAME = "username_key";
  static String SERVER_PASSWORD = "serverpassword_key";
  static String SERVER_TOKEN= "server_token_key";
  static String USER_EMAIL = "driverEmail_key";
  static String FIREBASE_MSG_TOKEN = "push_notification_token";
  static String MY_DEVICES_LIST = "my_devices_list";

  ///   ----------------bools----------------


  static String RECENTLY_USED_ADDRESS = "recently_us_addresss";
  static String HOME_ADDRESS = "home_addressss";
  static String OFFICE_ADDRESS = "office_addressss";

  static Future setLogined(bool logined) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(_userIsLogined, logined);

      return true;
    } catch (e) {
      print("name saving error $e.toString()");
      return null;
    }
  }

  static Future isUserLogined() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? value = prefs.getBool(_userIsLogined);
      print(' current user loggined?  $value');
      print(value);
      return value ?? false;
    } catch (e) {
      print(' current vaccinator name exception...');
      print(e.toString());
      return false;
    }
  }


  static saveString(String key, String value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(key, value);
      print(" ${key}  saved  $value");
    } catch (e) {
      print("Savei string error   $e.toString()");
    }
  }

  static Future getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }

  static saveStringList(String key, List<String> value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList(key, value);
      print(" ${key}  saved  $value");
    } catch (e) {
      print("Savei string error   $e.toString()");
    }
  }
  static Future<List<Device>> getStringList(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("list is ${prefs.getStringList(key)}");

    List<Device> lis=[];
    Device d;
    for (var element in prefs.getStringList(key)!) {
      d=Device.fromJson(jsonDecode(element));
      d.type=DeviceType.fence;
      lis.add(d);
    }
    print('list after...${lis.length}');
    return lis;
  }

  static saveBool(String key, bool value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(key, value);
      print(" ${key} bool saved  $value");
    } catch (e) {
      print("Savei bool error   ${e.toString()}");
    }
  }

  static Future getBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ;
  }

  static saveJson(String key, Map<String,dynamic> value) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(key, jsonEncode(value));
      print(" ${key}  saved value   ${value} ");
    } catch (e) {
      print("Savei string error   $e.toString()");
    }
  }

  static Future getJson(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? a=prefs.getString(key);
    print("Savei string error   $a");
    return jsonDecode(a??'null') ;
  }

}
