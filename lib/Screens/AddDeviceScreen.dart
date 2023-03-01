import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smarty/Helper/LocalDatabase.dart';
import 'package:smarty/Widgets/CustomButton.dart';
import 'package:smarty/Widgets/CustomTextField.dart';
import 'package:smarty/shared/res/res.dart';
import 'package:smarty/utils/enums.dart';
import '../Helper/Constants.dart';
import '../Helper/Helper.dart';
import '../Provider/DeviceProvider.dart';
import '../core/navigation/navigator.dart';
import 'package:provider/provider.dart';
import '../features/devices/domain/models/devices.dart';
import '../shared/res/typography.dart';
import 'package:upnp2/dial.dart';
import 'package:upnp2/media.dart';
import 'package:upnp2/router.dart';
import 'package:upnp2/server.dart';
import 'package:upnp2/upnp.dart'as ssdp;


class AddDeviceScreen extends StatefulWidget {
  final Device? device;
   AddDeviceScreen({Key? key, this.device,})
      : super(key: key);

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  final TextEditingController _controllerDeviceId=TextEditingController();
  final TextEditingController _controllerName=TextEditingController();
  final TextEditingController _controllerLocation=TextEditingController();
  final TextEditingController _controllerIP=TextEditingController();
  final TextEditingController _controllerModel=TextEditingController();
  final TextEditingController _controllerBrand=TextEditingController();
  String isAuto="Auto";
  String isScheduled="yes";
  TimeOfDay? onTime;
  TimeOfDay? offTime;


  List<Device> listOnLocalNetwork=[];

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
          children: [
            SizedBox(height: _height*0.06,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              IconButton(onPressed: (){Navigator.of(context).pop();}, icon: const Icon(Icons.arrow_back_ios,color: Colors.black,)),
              Text("Add Device",style: TextStyles.body,),
              IconButton(onPressed: () async {
                String result=await AppNavigator.pushNamed(qRScanScreen);
                _controllerDeviceId.text=result;
                }, icon: Icon(Icons.qr_code_scanner_sharp,color: SmartyColors.grey80,size: _height*0.04,)),
            ],),

            /*Container(
              width: 100,
              height: 100,
              child: DropdownButton<String>(
                value: selectedDevice,
                icon:const  Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.red, fontSize: 18),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String? data) {
                  setState(() {
                    selectedDevice = data!;
                  });
                },
                items: listDevicesOnLocalId.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),*/

            CustomTextField(_width*0.95, "Enter here", "Device ID", TextInputType.text, _controllerDeviceId),
            CustomTextField(_width*0.95, "Enter here", "Name", TextInputType.text, _controllerName),
            CustomTextField(_width*0.95, "Enter here", "Location", TextInputType.text, _controllerLocation),
            SizedBox(height: _height*0.01,),
            SizedBox(width: _width*0.95,child: Text("How you wanna add your device?",style: TextStyles.body,)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Text("Auto",style: TextStyles.body,),
                Expanded(
                  flex: 1,
                  child: RadioListTile(
                    contentPadding:const EdgeInsets.all(0),
                    title: const Text("Auto"),
                    value: "Auto",
                    groupValue: isAuto,
                    onChanged: (value){
                      setState(() {
                        isAuto = value.toString();
                      });
                    },
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: RadioListTile(
                    contentPadding:const EdgeInsets.all(0),
                    title: const Text("Manual"),
                    value: "Manual",
                    groupValue: isAuto,
                    onChanged: (value){
                      setState(() {
                        isAuto = value.toString();
                      });
                    },
                  ),
                ),
              ],
            ),
            isAuto=="Manual"?Column(
              children: [
                CustomTextField(_width*0.95, "Enter here", "IP", TextInputType.number, _controllerIP),
                CustomTextField(_width*0.95, "Enter here", "Model", TextInputType.text, _controllerModel),
                CustomTextField(_width*0.95, "Enter here", "Brand", TextInputType.text, _controllerBrand),
              ],
            ): CustomButton("Search on local network", _width*0.9, () {
              loadSSDP();
            },background: Colors.white),
            SizedBox(height: _height*0.01,),
            SizedBox(width: _width*0.95,child: Text("You wanna add daily schedule?",style: TextStyles.body,)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center ,
              children: [
                //Text("Auto",style: TextStyles.body,),
                Expanded(
                  flex: 2,
                  child: RadioListTile(
                    contentPadding:const EdgeInsets.all(0),
                    title: const Text("Non-schedule"),
                    value: "no",
                    groupValue: isScheduled,
                    onChanged: (value){
                      setState(() {
                        isScheduled = value.toString();
                      });
                    },
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: RadioListTile(
                    contentPadding:const EdgeInsets.all(0),
                    title: const Text("Schedule"),
                    value: "yes",
                    groupValue: isScheduled,
                    onChanged: (value){
                      setState(() {
                        isScheduled = value.toString();
                      });
                    },
                  ),
                ),

              ],
            ),

            isScheduled=="yes"?Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: ()async{
                    onTime= await Helper.selectTime(context);
                    setState(() {});
                  },
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("On",textAlign: TextAlign.center,style: TextStyles.body,),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(10.w),
                        width: _width*0.4,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: SmartyColors.primary)
                        ),
                        child: Text(onTime!=null?"${onTime!.hour}:${onTime!.minute}":"On Time",textAlign: TextAlign.center,style: TextStyles.headline4,),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: ()async{
                    offTime= await Helper.selectTime(context);
                    setState(() {});
                  },
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Off",style: TextStyles.body,),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(10.w),
                        width: _width*0.4,
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: SmartyColors.primary)
                        ),
                        child: Text(offTime!=null?"${offTime!.hour}:${offTime!.minute}":"Off Time",textAlign: TextAlign.center,style: TextStyles.headline4,),
                      ),
                    ],
                  ),
                ),
              ],
            ):Container(),

            CustomButton(widget.device!=null?"Update":"Save", _width*0.9, () {
              //save device
              if(widget.device!=null){
                //update
                Provider.of<DeviceProvider>(context, listen: false).update( widget.device!.index, Device(
                    name: _controllerName.text.toString(),
                    type: DeviceType.fence,
                    active: false, room: _controllerLocation.text.toString(),
                    mute: "0", alarm: "0", power: "0", deviceBrand: _controllerBrand.text.toString(),
                    deviceId: _controllerDeviceId.text.toString(), deviceIP: _controllerIP.text.toString(),
                    deviceModel: _controllerModel.text.toString(), model: _controllerModel.text.toString(),
                    index: widget.device!.index,
                ),
                );
                LocalDatabase.saveStringList(LocalDatabase.MY_DEVICES_LIST,
                    Provider.of<DeviceProvider>(context,listen: false).getDevices().map((deviceObj) => jsonEncode( deviceObj.toJson() )).toList() );

              }else{
                Provider.of<DeviceProvider>(context, listen: false).add(
                    Device(
                        name: _controllerName.text.toString(),
                        type: DeviceType.fence,
                        active: false, room: _controllerLocation.text.toString(),
                        mute: "0", alarm: "0", power: "0", deviceBrand: _controllerBrand.text.toString(),
                        deviceId: _controllerDeviceId.text.toString(), deviceIP: _controllerIP.text.toString(),
                        deviceModel: _controllerModel.text.toString(), model: _controllerModel.text.toString(),
                        index: Provider.of<DeviceProvider>(context, listen: false).getDevices().length
                    ));
                LocalDatabase.saveStringList(LocalDatabase.MY_DEVICES_LIST,
                    Provider.of<DeviceProvider>(context,listen: false).getDevices().map((deviceObj) => jsonEncode( deviceObj.toJson() )).toList() );

              }

            }),
          ],
        ),
      ),
    );
  }



  void loadData() {
    if(widget.device!=null) {
      _controllerDeviceId.text=widget.device!.deviceId;
      _controllerName.text=widget.device!.name??"";
      _controllerLocation.text=widget.device!.room;
      _controllerIP.text=widget.device!.deviceIP;
      _controllerModel.text=widget.device!.model;
      _controllerBrand.text=widget.device!.deviceBrand;
      setState(() {});
    }
  }
  loadSSDP()async {
    Helper.showLoading(context);
    final disc = ssdp.DeviceDiscoverer();
    await disc.start(ipv6: false);
    disc.quickDiscoverClients().listen((client) async {
      try {
        final dev = await client.getDevice();
        if (kDebugMode) {
          print('Found device: ${dev!.friendlyName}: ${dev.url}');
          print('Found device deviceType: ${dev.deviceType}: ${dev.url}');
          print('Found device manufacturer: ${dev.manufacturer}: ${dev.url}');
          print('Found device modelName: ${dev.modelName}: ${dev.url}');
          print('Found device urlBase: ${dev.urlBase}: ${dev.url}');
          print('Found device modelName: ${dev.modelName}: ${dev.url}');
          print('Found device icons: ${dev.icons}: ${dev.url}');
          print('Found device modelDescription: ${dev.modelDescription}: ${dev.url}');
        }

        bool alreadySaved=false;
        if(dev!.manufacturer==Constants.BRAND_NAME) { //brand
          Provider.of<DeviceProvider>(context, listen: false).getDevices().forEach((element) {
            if(element.deviceBrand==dev.modelName) {
              alreadySaved=true;
            }
          });
          if(!alreadySaved) {
            //String url="http://192.168.0.102:80/description.xml";
            String s1=dev.urlBase.toString().split("//")[1];
            String ip=s1.split("/des").first;
            print("IP is $ip");
            listOnLocalNetwork.add(Device(active: false, room: "", mute: "0",
            alarm: "0", power: "0", deviceBrand: dev.manufacturer!,
            deviceId: dev.serviceNames.toString(), deviceIP: ip,
            deviceModel: dev.modelName.toString(), model: "", index: 0));
          }
        }
        setState(() {});
      } catch (e, stack) {
        print('ERROR: $e - ${client.location}');
        print(stack);
      }
    }
    ).onDone(() {

      Navigator.of(context).pop();
      if(listOnLocalNetwork.isEmpty){
        Helper.toast("Device not found", SmartyColors.error);
      }else{
        totalDevices(context,"${listOnLocalNetwork.length} device(s) found, do you want to save device?",(){
          //save..
          // saveDevice(Device(
          //     name: listOnLocalNetwork.first.name,
          //     type: DeviceType.fence,
          //     active: false, room: _controllerLocation.text.toString(),
          //     mute: "0", alarm: "0", power: "0", deviceBrand: _controllerBrand.text.toString(),
          //     deviceId: _controllerDeviceId.text.toString(), deviceIP: _controllerIP.text.toString(),
          //     deviceModel: _controllerModel.text.toString(), model: _controllerModel.text.toString(),
          //     index: Provider.of<DeviceProvider>(context, listen: false).getDevices().length
          // ));
          _controllerDeviceId.text=listOnLocalNetwork.first.deviceId;
          _controllerName.text=listOnLocalNetwork.first.name??"";
          _controllerLocation.text="";
          _controllerIP.text=listOnLocalNetwork.first.deviceIP;
          _controllerModel.text=listOnLocalNetwork.first.model;
          _controllerBrand.text=listOnLocalNetwork.first.deviceBrand;
          setState((){});
        });
      }
    });
  }
  static void totalDevices(BuildContext context, String msg, Function()? functionHandler) {
    Dialog rejectDialogWithReason = Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 15.r,),
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
                        'Save one',
                        style: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 16,
                            color: Colors.black),
                      )),
                  TextButton(
                      onPressed: (){Navigator.of(context).pop();},
                      child: const Text(
                        'Cancel',
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

  saveDevice(Device device1) {
    Provider.of<DeviceProvider>(context, listen: false).add(device1);
    LocalDatabase.saveStringList(LocalDatabase.MY_DEVICES_LIST,
        Provider.of<DeviceProvider>(context,listen: false).getDevices().map((deviceObj) => jsonEncode( deviceObj.toJson() )).toList() );
    Helper.toast("${device1.name} saved successfully", SmartyColors.success);
    Navigator.of(context).pop();
  }

}
