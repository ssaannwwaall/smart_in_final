import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Helper/Helper.dart';
import '../../../../Provider/DeviceProvider.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../shared/res/res.dart';
import '../../../../utils/enums.dart';
import '../../domain/models/devices.dart';
import 'package:provider/provider.dart';
class Fence extends StatefulWidget {
  final Device device;
  Fence({Key? key, required this.device})
      : assert(device.type == DeviceType.fence),
        super(key: key);

  @override
  State<Fence> createState() => _FenceState();
}

class _FenceState extends State<Fence> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 32.h + MediaQuery.of(context).padding.top),
              Row(
                children: [
                  if (AppNavigator.canPop)
                    GestureDetector(
                      onTap: () => AppNavigator.pop(),
                      child: const Icon(Icons.arrow_back_ios),
                    ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Fence',
                        style: TextStyles.headline4,
                      ),
                    ),
                  ),
                  IconButton(onPressed: () {
                    Helper.yesNoDialog(context,"Do you want to delete it?",() {
                      //yes
                      Navigator.of(context).pop();
                    },(){
                      //no
                      Navigator.of(context).pop();
                    });
                  }, icon: Icon(Icons.remove_circle_outline,size: 30.h,)),
                  SizedBox(width: 5.r,),
                  IconButton(onPressed: () {
                    //open next page which is adding device...
                    AppNavigator.pushNamed(addDeviceScreen, arguments: widget.device);
                  }, icon: Icon(Icons.settings,size: 30.h,)),
                ],
              ),
              SizedBox(height: 36.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fence',
                    style:
                    TextStyles.headline4.copyWith(color: SmartyColors.grey),
                  ),
                  Text(
                    widget.device.room,
                    style: TextStyles.body.copyWith(color: SmartyColors.grey60),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              Container(
                padding: EdgeInsets.all(24.r),
                decoration: BoxDecoration(
                  color: SmartyColors.grey10,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /*Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset('assets/icons/netflix.png', width: 28),
                            SizedBox(width: 8.w),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Netflix',
                                  style: TextStyles.body
                                      .copyWith(color: SmartyColors.grey),
                                ),
                                Text(
                                  'Deadline 2022/07/20',
                                  style: TextStyles.subtitle
                                      .copyWith(color: SmartyColors.grey60),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),*/
                    SizedBox(height: 10.h),
                    Text(
                      'Fence current status',
                      style: TextStyles.subtitle,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        //color: SmartyColors.primary,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Stack(children: [
                        Center(child: Image.asset('assets/icons/machinetools.png',
                          color: SmartyColors.grey80,width: 200.h,height: 200.w,)),
                        /*Visibility(
                          visible: true,
                          child: Positioned.fill(
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 24.w),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: SmartyColors.black,
                                ),
                                child: Text(
                                  widget.device.active?'Armed':"Disarmed",
                                  style: TextStyles.headline3
                                      .copyWith(color: SmartyColors.tertiary),
                                ),
                              ),
                            ),
                          ),
                        )*/
                      ]),
                    ),
                    SizedBox(height: 5.h),
                   /* Padding(
                      padding: EdgeInsets.symmetric(horizontal: 19.w),
                      child: Column(
                        children: [
                          SizedBox(height: 24.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                // height: 40.h,
                                padding: EdgeInsets.all(6.r),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.r),//100
                                  border:
                                  Border.all(color: SmartyColors.grey30),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          widget.device.power="1";
                                        });
                                      },
                                      padding: EdgeInsets.zero,
                                      //constraints: const BoxConstraints(),
                                      icon:  Icon(Icons.power,
                                        color: SmartyColors.primary,
                                        size: 50.r,
                                          ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          widget.device.power="0";
                                        });
                                      },
                                      padding: EdgeInsets.zero,
                                      //constraints: const BoxConstraints(),
                                      icon:  Icon(Icons.power_off,
                                        color: SmartyColors.grey60,
                                        size: 50.r,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                // height: 40.h,
                                padding: EdgeInsets.all(16.r),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(200.r),
                                  border:
                                  Border.all(color: SmartyColors.grey30),
                                ),
                                child: Row(
                                  children: [
                                    //const Icon(Icons.volume_up_rounded),
                                     SizedBox(width: 5.w),
                                    Text(
                                        widget.device.power=="0"?'Disarmed':
                                        widget.device.power=="1"?"Armed":
                                        widget.device.power=="1"?"":"Not connected",
                                      style: TextStyles.headline4
                                          .copyWith(color: SmartyColors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    *//*Padding(
                      padding: EdgeInsets.symmetric(horizontal: 19.w),
                      child: Column(
                        children: [
                          SizedBox(height: 20.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                // height: 40.h,
                                padding: EdgeInsets.all(16.r),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.r),//100
                                  border:
                                  Border.all(color: SmartyColors.grey30),
                                ),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: (){
                                        setState(() {
                                          widget.device.alarm="1";
                                        });
                                      },
                                      child: Image.asset('assets/icons/unmute.png',
                                        color: SmartyColors.primary,width: 40.r,height: 40.r,),
                                    ),
                                    SizedBox(width: 30.h,),
                                    InkWell(
                                      onTap: (){
                                        setState(() {
                                          widget.device.alarm="0";
                                        });
                                      },
                                      child: Image.asset('assets/icons/unmute.png',
                                        color: SmartyColors.primary,width: 40.r,height: 40.r,),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                // height: 40.h,
                                padding: EdgeInsets.all(16.r),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(200.r),
                                  border:
                                  Border.all(color: SmartyColors.grey30),
                                ),
                                child: Row(
                                  children: [
                                    //const Icon(Icons.volume_up_rounded),
                                    SizedBox(width: 5.w),
                                    Text(
                                      widget.device.power=="0"?'Disarmed':
                                      widget.device.power=="1"?"Armed":
                                      widget.device.power=="1"?"":"Not connected",
                                      style: TextStyles.headline4
                                          .copyWith(color: SmartyColors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),*/
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Column(
                  children: [
                    SizedBox(height: 24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          // height: 40.h,
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),//100
                            border:
                            Border.all(color: SmartyColors.grey30),
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Helper.publishTopic("${widget.device.deviceBrand}/${widget.device.model}/${widget.device.deviceId}/cmd/Power/1",context);
                                  // setState(() {
                                  //   //publish here
                                  //   widget.device.power="1";
                                  // });
                                },
                                child: Image.asset('assets/icons/power.png',
                                  color: SmartyColors.primary,width: 40.r,height: 40.r,),
                              ),
                              SizedBox(width: 30.h,),
                              InkWell(
                                onTap: (){
                                  Helper.publishTopic("${widget.device.deviceBrand}/${widget.device.model}/${widget.device.deviceId}/cmd/Power/0",context);
                                  // setState(() {
                                  //   widget.device.power="0";
                                  // });
                                },
                                child: Image.asset('assets/icons/power.png',
                                  color: SmartyColors.grey80,width: 40.r,height: 40.r,),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          // height: 40.h,
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(200.r),
                            border:
                            Border.all(color: SmartyColors.grey30),
                          ),
                          child: Row(
                            children: [
                              //const Icon(Icons.volume_up_rounded),
                              SizedBox(width: 5.w),
                              Text(
                                Provider.of<DeviceProvider>(context, listen: false).getDevices()[widget.device.index].power=="0"?'Disarmed':
                                Provider.of<DeviceProvider>(context, listen: false).getDevices()[widget.device.index].power=="1"?"Armed":
                                Provider.of<DeviceProvider>(context, listen: false).getDevices()[widget.device.index].power=="2"?"Not responding":"Un-known",
                                style: TextStyles.headline4
                                    .copyWith(color: SmartyColors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Column(
                  children: [
                    SizedBox(height: 24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          // height: 40.h,
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),//100
                            border:
                            Border.all(color: SmartyColors.grey30),
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  //publish here
                                  print('clicked...');
                                  Helper.publishTopic("${widget.device.deviceBrand}/${widget.device.model}/${widget.device.deviceId}/cmd/mute/0",context);
                                  // setState(() {
                                  //   widget.device.mute="0";
                                  // });
                                },
                                child: Image.asset('assets/icons/unmute.png',
                                  color: SmartyColors.primary,width: 40.r,height: 40.r,),
                              ),
                              SizedBox(width: 30.h,),
                              InkWell(
                                onTap: (){
                                  Helper.publishTopic("${widget.device.deviceBrand}/${widget.device.model}/${widget.device.deviceId}/cmd/mute/1",context);
                                  // setState(() {
                                  //   widget.device.mute="1";
                                  // });
                                },
                                child: Image.asset('assets/icons/mute.png',
                                  color: SmartyColors.grey80,width: 40.r,height: 40.r,),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          // height: 40.h,
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(200.r),
                            border:
                            Border.all(color: SmartyColors.grey30),
                          ),
                          child: Row(
                            children: [
                              //const Icon(Icons.volume_up_rounded),
                              SizedBox(width: 5.w),
                              Text(
                                Provider.of<DeviceProvider>(context, listen: false).getDevices()[widget.device.index].mute=="0"?'Mute':"Un-mute",
                                style: TextStyles.headline4
                                    .copyWith(color: SmartyColors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              /*Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 48.w,
                    width: 48.w,
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.r),
                      border: Border.all(color: SmartyColors.grey30),
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      color: SmartyColors.grey60,
                    ),
                  ),
                  Container(
                    height: 48.w,
                    width: 48.w,
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.r),
                      border: Border.all(color: SmartyColors.grey30),
                    ),
                    child: Icon(
                      Icons.cast_connected_rounded,
                      color: SmartyColors.grey60,
                    ),
                  )
                ],
              ),
              SizedBox(height: 51.h),*/
              /*ChipButton(
                child:  Image.asset("assets/icons/sound_test.png",height: 50.r,width: 50.r,color: SmartyColors.grey80,),
                onPressed: () {
                  setState(() {
                    _isOn = !_isOn;
                  });
                },
              ),*/
              Center(
                child: InkWell(
                  onTap: (){
                    Helper.publishTopic("${widget.device.deviceBrand}/${widget.device.model}/${widget.device.deviceId}/cmd/Sound/1",context);
                    //publish here
                  },
                  child: Container(
                    padding: EdgeInsets.all(20.r),
                      decoration: BoxDecoration(
                        color: SmartyColors.grey10,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Column(
                        children: [
                          Image.asset("assets/icons/sound_test.png",height: 50.r,width: 50.r,
                            color: SmartyColors.primary,),
                          Text("Sound test",style: TextStyles.body,)
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
