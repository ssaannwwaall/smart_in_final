import 'package:flutter/material.dart';
import 'package:smarty/Helper/Helper.dart';
import 'package:smarty/Helper/LocalDatabase.dart';
import 'package:smarty/features/devices/domain/models/devices.dart';
import 'package:smarty/features/home/presentation/views/home.dart';
import '../Widgets/CustomButton.dart';
import '../Widgets/CustomTextField.dart';
import '../shared/res/colors.dart';


class AppSettings extends StatefulWidget {
  const AppSettings({Key? key}) : super(key: key);

  @override
  State<AppSettings> createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  final TextEditingController _controllerDomain=TextEditingController();
  final TextEditingController _controllerPort=TextEditingController();
  final TextEditingController _controlleruUserName=TextEditingController();
  final TextEditingController _controllerPassword=TextEditingController();
  final TextEditingController _controllerToken=TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery=MediaQuery.of(context);
    double _width=mediaQuery.size.width;
    double _height=mediaQuery.size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: _height*0.06,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: (){Navigator.of(context).pop();}, icon: const Icon(Icons.arrow_back_ios,color: Colors.black,)),
              ],),
            SizedBox(height: _height*0.02,),
            CustomTextField(_width*0.95, "abc.xyz.com i.e.", "Domain", TextInputType.text, _controllerDomain),
            CustomTextField(_width*0.95, "1880 i.e.", "Port", TextInputType.text, _controllerPort),
            CustomTextField(_width*0.95, "Enter here", "UserName", TextInputType.text, _controlleruUserName),
            CustomTextField(_width*0.95, "Enter here", "Password", TextInputType.text, _controllerPassword),
            CustomTextField(_width*0.95, "Enter here", "Token", TextInputType.text, _controllerToken),
            SizedBox(height: _height*0.06,),

            CustomButton("Save", _width*0.9, () {
              //save device
              if(_controllerDomain.text.toString().isEmpty){
                Helper.toast("Invalid domain", SmartyColors.grey60);
              }else if(_controllerPort.text.toString().isEmpty){
                Helper.toast("Invalid port", SmartyColors.grey60);
              }else if(_controlleruUserName.text.toString().isEmpty){
                Helper.toast("Invalid username", SmartyColors.grey60);
              }else if(_controllerPassword.text.toString().isEmpty){
                Helper.toast("Invalid password", SmartyColors.grey60);
              }else if(_controllerToken.text.toString().isEmpty){
                Helper.toast("Invalid token", SmartyColors.grey60);
              }else{
                LocalDatabase.saveString(LocalDatabase.SERVER_DOMAIN, _controllerDomain.text.toString());
                LocalDatabase.saveString(LocalDatabase.SERVER_PORT, _controllerPort.text.toString());
                LocalDatabase.saveString(LocalDatabase.SERVER_USER_NAME, _controlleruUserName.text.toString());
                LocalDatabase.saveString(LocalDatabase.SERVER_PASSWORD, _controllerPassword.text.toString());
                LocalDatabase.saveString(LocalDatabase.SERVER_TOKEN, _controllerToken.text.toString());
                Helper.msgDialog(context, "Server data saved successfully", () => Navigator.of(context).pop());
              }
            }),

          ],
        ),
      ),
    );
  }

  void loadData() {
    _controllerDomain.text=serverDomain;
    _controllerPort.text=serverPort;
    _controlleruUserName.text=serverUserName;
    _controllerPassword.text=serverPassword;
    _controllerToken.text=serverToken;

  }



}
