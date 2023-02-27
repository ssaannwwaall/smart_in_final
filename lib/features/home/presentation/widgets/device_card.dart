import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smarty/Helper/Constants.dart';

import '../../../../Helper/Helper.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../shared/res/res.dart';
import '../../../devices/domain/models/devices.dart';
import '../../../../utils/enums.dart';

class DeviceCard extends StatefulWidget {
  final Device device;
  final bool isFromHome;
  const DeviceCard({
    Key? key,
    required this.device,
    required this.isFromHome,
  }) : super(key: key);

  @override
  State<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //print("route is ${widget.device.type.routeName}   device name ${widget.device.name}");
        AppNavigator.pushNamed(widget.device.type!.routeName, arguments: widget.device);
        },
      child: Row(
        children: [
           Container(
            padding:        EdgeInsets.all(10.r),
            margin: EdgeInsets.only(right: 10.w),
            decoration: BoxDecoration(
              color: SmartyColors.secondary10,
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(color:widget.device.alarm=="1"? SmartyColors.error
                  : SmartyColors.secondary10,width: 3)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      widget.device.type!.icon ?? 'assets/icons/ac.png',
                      width: 48.w,
                      //height: 48.w,
                    ),
                    SizedBox(width: 30.w),//32.w
                    !widget.isFromHome? Switch.adaptive(
                      activeColor: SmartyColors.primary,
                      value: widget.device.active,
                      onChanged: (bool v) {
                        setState(() {
                          widget.device.active = v;
                        });
                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ):Container(),
                  ],
                ),
                //SizedBox(height: 32.h),
                Text(
                  widget.device.name ?? widget.device.type!.name,
                  //widget.device.name!=null || widget.device.name!="null" ? widget.device.name! : widget.device.type!.name,
                  style: TextStyles.body.copyWith(color: SmartyColors.grey),
                ),
                SizedBox(height: 4.h),
                Text(
                  widget.device.active ? "Status : Armed":"Status : Disarmed",
                  style: TextStyles.body.copyWith(color: SmartyColors.grey60),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
