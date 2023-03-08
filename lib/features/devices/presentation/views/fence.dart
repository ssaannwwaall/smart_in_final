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
    MediaQueryData mediaQuery=MediaQuery.of(context);
    double _width=mediaQuery.size.width;
    double _height=mediaQuery.size.height;
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
                 // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                   // SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10),
                          decoration:  BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Provider.of<DeviceProvider>(context, listen: true).getDevices()[widget.device.index].status=="1"?Colors.green:
                                SmartyColors.error,
                                blurRadius: 20.0,
                                spreadRadius: 10.0,
                              )
                            ],
                          ),
                          child: ClipOval(
                            child: Container(
                              width: 15.r,
                              height: 15.r,
                              color: Provider.of<DeviceProvider>(context, listen: true).getDevices()[widget.device.index].status=="1"?
                              Colors.green:
                              SmartyColors.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        //color: SmartyColors.primary,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Stack(children: [
                        Center(child: Image.asset('assets/icons/machinetools.png',
                          color: SmartyColors.grey80,width: 200.h,height: 200.w,)),
                      ]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          // height: 40.h,
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            border:
                            Border.all(color: SmartyColors.grey30),
                          ),
                          child: Text(
                            Provider.of<DeviceProvider>(context, listen: true).getDevices()[widget.device.index].mute=="0"?'Mute':"Un-mute",
                            style: TextStyles.headline4
                                .copyWith(color: SmartyColors.grey),
                          ),
                        ),
                        Container(
                          // height: 40.h,
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            border:
                            Border.all(color: SmartyColors.grey30),
                          ),
                          child: Row(
                            children: [
                              //const Icon(Icons.volume_up_rounded),
                              SizedBox(width: 5.w),
                              Text(
                                Provider.of<DeviceProvider>(context, listen: true).getDevices()[widget.device.index].power=="0"?'Disarmed':
                                Provider.of<DeviceProvider>(context, listen: true).getDevices()[widget.device.index].power=="1"?"Armed":
                                Provider.of<DeviceProvider>(context, listen: true).getDevices()[widget.device.index].power=="2"?"Not responding":"Un-known",
                                style: TextStyles.headline4
                                    .copyWith(color: SmartyColors.grey),
                              ),
                            ],
                          ),
                        ),
                        //Paste here

                      ],
                    ),
                    SizedBox(height: 5.h),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Column(
                  children: [
                    SizedBox(height: 24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        /*InkWell(
                                onTap: () {
                                  Helper.publishTopic("${widget.device.deviceBrand}/${widget.device.model}/${widget.device.name}/cmd/Power","1",context);
                                  // setState(() {
                                  //   //publish here
                                  //   widget.device.power="1";
                                  // });
                                },
                                child: Image.asset('assets/icons/power.png',
                                  color: SmartyColors.primary,width: 40.r,height: 40.r,),
                              ),*/
                        SizedBox(
                          width: _width*0.3,
                          child: InkWell(
                            onTap: (){
                              Helper.publishTopic("${widget.device.deviceBrand}/${widget.device.model}/${widget.device.name}/cmd/Power","1",context);
                            },
                            child: Container(
                                padding: EdgeInsets.all(20.r),
                                decoration: BoxDecoration(
                                  color: SmartyColors.grey10,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Column(
                                  children: [
                                    Image.asset("assets/icons/power.png",height: 50.r,width: 50.r,
                                      color: SmartyColors.primary,),
                                    Text("Armed",style: TextStyles.body,)
                                  ],
                                )),
                          ),
                        ),
                        SizedBox(width: 30.h,),
                        /*InkWell(
                                onTap: (){
                                  Helper.publishTopic("${widget.device.deviceBrand}/${widget.device.model}/${widget.device.name}/cmd/Power","0",context);
                                  // setState(() {
                                  //   widget.device.power="0";
                                  // });
                                },
                                child: Image.asset('assets/icons/power.png',
                                  color: SmartyColors.grey80,width: 40.r,height: 40.r,),
                              ),*/
                        SizedBox(
                          width: _width*0.3,
                          child: InkWell(
                            onTap: (){
                              Helper.publishTopic("${widget.device.deviceBrand}/${widget.device.model}/${widget.device.name}/cmd/Power","0",context);
                            },
                            child: Container(
                                padding: EdgeInsets.all(20.r),
                                decoration: BoxDecoration(
                                  color: SmartyColors.grey10,
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Column(
                                  children: [
                                    Image.asset("assets/icons/power.png",height: 50.r,width: 50.r,
                                      color: SmartyColors.grey80,),
                                    Text("Disarmed",style: TextStyles.body,)
                                  ],
                                )),
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: _width*0.3,
                          child: InkWell(
                            onTap: (){
                              Helper.publishTopic("${widget.device.deviceBrand}/${widget.device.deviceModel}/${widget.device.name}/cmd/Mute","0",context);//TODO ${widget.device.deviceModel}
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
                                    Image.asset("assets/icons/unmute.png",height: 50.r,width: 50.r,
                                      color: SmartyColors.primary,),
                                    Text("Un-mute",style: TextStyles.body,)
                                  ],
                                )),
                          ),
                        ),
                        SizedBox(width: 30.h,),
                        SizedBox(
                          width: _width*0.3,
                          child: InkWell(
                            onTap: (){
                              print('clicked....');
                              Helper.publishTopic("${widget.device.deviceBrand}/${widget.device.deviceModel}/${widget.device.name}/cmd/Mute","1",context);
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
                                    Image.asset("assets/icons/mute.png",height: 50.r,width: 50.r,
                                      color: SmartyColors.primary,),
                                    Text("Mute 🔔",style: TextStyles.body,)
                                  ],
                                )),
                          ),
                        ),
                        //listing mute/unmute
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              Center(
                child: InkWell(
                  onTap: (){
                    Helper.publishTopic("${widget.device.deviceBrand}/${widget.device.model}/${widget.device.name}/cmd/SoundTest","1",context);
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
                          Text("Sound test 🔔",style: TextStyles.body,)
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
