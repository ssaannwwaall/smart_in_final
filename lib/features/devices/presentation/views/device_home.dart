import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../Provider/DeviceProvider.dart';
import '../../domain/models/devices.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../shared/res/res.dart';
import '../../../home/presentation/widgets/widgets.dart';
import 'package:provider/provider.dart';
// class DevicesScreen extends StatelessWidget {
//   const DevicesScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 24.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 32 + MediaQuery.of(context).padding.top),
//               Row(
//                 children: [
//                   if (AppNavigator.canPop)
//                     GestureDetector(
//                       onTap: () => AppNavigator.pop(),
//                       child: const Icon(Icons.arrow_back_ios),
//                     ),
//                   Text(
//                     'Devices',
//                     style: TextStyles.headline4,
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16.h),
//               Text(
//                 'Living Room',
//                 style: TextStyles.body,
//               ),
//               SizedBox(height: 16.h),
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [...devices.map((e) => DeviceCard(device: e,isFromHome: false,))],
//                 ),
//               ),
//               SizedBox(height: 16.h),
//               Text(
//                 'Bed Room',
//                 style: TextStyles.body,
//               ),
//               SizedBox(height: 16.h),
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   //children: [...devices.map((e) => DeviceCard(device: e,isFromHome: false,))],
//                   children: [...Provider.of<DeviceProvider>(context, listen: true).getDevices().map((e) => DeviceCard(device: e,isFromHome: false,))],
//                 ),
//               ),
//               SizedBox(height: 16.h),
//               Text(
//                 'Kitchen',
//                 style: TextStyles.body,
//               ),
//               SizedBox(height: 16.h),
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [...devices.map((e) => DeviceCard(device: e,isFromHome: false,))],
//                   //children: [...Provider.of<DeviceProvider>(context, listen: false).getDevices().map((e) => DeviceCard(device: e,isFromHome: false,))],
//                 ),
//               ),
//               SizedBox(height: 16.h),
//               Text(
//                 'Dining Room',
//                 style: TextStyles.body,
//               ),
//               SizedBox(height: 16.h),
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [...devices.map((e) => DeviceCard(device: e,isFromHome: false,))],
//                 ),
//               ),
//               SizedBox(height: 48.h),
//               AppButtonPrimary(
//                 label: 'Add Device',
//                 onPressed: () {},
//               ),
//               SizedBox(height: 64.h),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({Key? key}) : super(key: key);
  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 32 + MediaQuery.of(context).padding.top),
                  Row(
                    children: [
                      if (AppNavigator.canPop)
                        GestureDetector(
                          onTap: () => AppNavigator.pop(),
                          child: const Icon(Icons.arrow_back_ios),
                        ),
                      Text(
                        'Devices',
                        style: TextStyles.headline4,
                      ),
                    ],
                  ),
                  /*SizedBox(height: 16.h),
                  Text(
                    'Living Room',
                    style: TextStyles.body,
                  ),
                  SizedBox(height: 16.h),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [...devices.map((e) => DeviceCard(device: e,isFromHome: false,))],
                    ),
                  ),*/
                  SizedBox(height: 16.h),
                  Text(
                    //'Bed Room',
                    'My all devices',
                    style: TextStyles.body,
                  ),
                  SizedBox(height: 16.h),
                  /*SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //children: [...devices.map((e) => DeviceCard(device: e,isFromHome: false,))],
                      children: [...Provider.of<DeviceProvider>(context, listen: true).getDevices().map((e) => DeviceCard(device: e,isFromHome: false,))],
                    ),
                  ),*/
                  GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 5,//16
                        mainAxisSpacing: 20,//16
                        mainAxisExtent: 120,
                      ),
                      itemCount: Provider.of<DeviceProvider>(context, listen: false).getDevices().length,
                      itemBuilder: (BuildContext context, int index) {
                        //return RoomCard(location: Provider.of<DeviceProvider>(context, listen: false).getDevices()[index].room);
                        return DeviceCard(device: Provider.of<DeviceProvider>(context, listen: false).getDevices()[index],isFromHome: false,);
                      }),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.all(30.r),
                      child: FloatingActionButton(onPressed: (){
                        AppNavigator.pushNamed(addDeviceScreen);
                      },child: Icon(Icons.add,size: 45.r,))),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}





