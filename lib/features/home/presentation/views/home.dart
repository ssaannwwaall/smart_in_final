import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:smarty/Helper/LocalDatabase.dart';
import '../../../../Provider/DeviceProvider.dart';
import '../../../../Provider/IsServerConnectedProvider.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../shared/res/res.dart';
import '../../../../shared/widgets/onboarding_widget.dart';
import '../../../devices/domain/models/devices.dart';
import '../widgets/widgets.dart';
import 'package:provider/provider.dart';


// class HomeScreen extends StatelessWidget {
//
//   void loadServerData() async {
//     serverDomain=await LocalDatabase.getString(LocalDatabase.SERVER_DOMAIN);
//     serverPort=await LocalDatabase.getString(LocalDatabase.SERVER_PORT);
//     serverUserName=await LocalDatabase.getString(LocalDatabase.SERVER_USER_NAME);
//     serverPassword=await LocalDatabase.getString(LocalDatabase.SERVER_PASSWORD);
//     serverToken=await LocalDatabase.getString(LocalDatabase.SERVER_TOKEN);
//   }
//   const HomeScreen({Key? key}) : super(key: key);
//
//
//   @override
//   Widget build(BuildContext context) {
//     loadServerData();
//     return SingleChildScrollView(
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 24.w),
//         child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//           SizedBox(height: 32.h + MediaQuery.of(context).padding.top),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: Text(
//                   'Good Morning, Sanwal',
//                   style: TextStyles.headline4,
//                 ),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   AppNavigator.pushNamed(appSettings);
//                 },
//                 child:   CircleAvatar(
//                   radius: 24,
//                   backgroundColor: SmartyColors.tertiary80,
//                   child:  Icon(Icons.settings,color: SmartyColors.grey60,),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 32.h),
//           const SummaryHeader(),
//          /* SizedBox(height: 32.h),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Quick Action',
//                 style: TextStyles.body.copyWith(
//                   fontWeight: FontWeight.w500,
//                   color: SmartyColors.grey,
//                 ),
//               ),
//               Text(
//                 'Edit',
//                 style: TextStyles.body.copyWith(
//                   color: SmartyColors.grey60,
//                 ),
//               )
//             ],
//           ),
//           SizedBox(height: 16.h),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               ...['Wake up', 'Sleep', 'Clean']
//                   .map((e) => QuickAction(action: e))
//             ],
//           ),
//           */
//           SizedBox(height: 32.h),
//           Text(
//             'Active Devices',
//             style: TextStyles.body.copyWith(
//               fontWeight: FontWeight.w500,
//               color: SmartyColors.grey,
//             ),
//           ),
//           SizedBox(height: 16.h),
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [...devices.map((e) => DeviceCard(device: e,isFromHome: true,))],
//             ),
//           ),
//           SizedBox(height: 32.h),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Locations',
//                 style: TextStyles.body.copyWith(
//                   fontWeight: FontWeight.w500,
//                   color: SmartyColors.grey,
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 16.h),
//           MediaQuery.removePadding(
//             context: context,
//             removeTop: true,
//             child: GridView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 16,
//                   mainAxisSpacing: 16,
//                   mainAxisExtent: 100,
//                 ),
//                 itemCount: Provider.of<DeviceProvider>(context, listen: false).getDevices().length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return RoomCard(location: Provider.of<DeviceProvider>(context, listen: false).getDevices()[index].room);
//                 }),
//           ),
//         ]),
//       ),
//     );
//   }
// }
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController? _pageController;
  Timer? _pageAnimationTimer;
  int _page = 0;

  void _animatePages() {
    if (_pageController == null) return;
    if (_page < 2) {
      _pageController?.nextPage(
        duration: const Duration(seconds: 1),
        curve: Curves.easeIn,
      );
    }
    if(_page==2){
      _pageController!.jumpToPage(0);
      _page=0;
      setState(() {});
      //_pageController!.previousPage(duration: const Duration(seconds: 1), curve: Curves.ease);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
    _pageAnimationTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _animatePages();
    });
  }


  @override
  void dispose() {
    _pageAnimationTimer?.cancel();
    _pageAnimationTimer = null;
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print("kkkkkkkkkkk  ${Provider.of<DeviceProvider>(context, listen: false).getDevices().length}");
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Welcome to Smart-in',
                        style: TextStyles.headline4,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          // BoxShadow(
                          //   color: Colors.green,
                          //   blurRadius: 20.0,
                          //   spreadRadius: 10.0,
                          // )
                        ],
                      ),
                      child: ClipOval(
                        child: Container(
                          width: 15.r,
                          height: 15.r,
                            color: Provider.of<IsServerConnectedProvider>(context).getServerStatus()?
                            Colors.green:
                                SmartyColors.error,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        AppNavigator.pushNamed(appSettings);
                      },
                      child:   CircleAvatar(
                        radius: 24,
                        backgroundColor: SmartyColors.tertiary80,
                        child:  Icon(Icons.settings,color: SmartyColors.grey60,),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 32.h),
                Container(
                  width: _width*0.9,
                  height: _height*0.12,
                  padding: EdgeInsets.all(_width*0.01),
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (newPage) {
                      setState(() {
                        _page = newPage;
                      });
                    },
                    children:  [
                      Container(
                        width: _width*0.8,
                        height: _height*0.1,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Image.asset( "assets/images/movie.png",fit: BoxFit.cover,),
                      ),
                      Container(
                        width: _width*0.8,
                        height: _height*0.1,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Image.asset( "assets/images/bg.png",fit: BoxFit.cover,),
                      ),
                      Container(
                        width: _width*0.8,
                        height: _height*0.1,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Image.asset( "assets/images/home2.png",fit: BoxFit.cover,),
                      ),
                    ],
                  ),
                ),
                const SummaryHeader(),
                SizedBox(height: 32.h),
                Text(
                  'Active Devices',
                  style: TextStyles.body.copyWith(
                    fontWeight: FontWeight.w500,
                    color: SmartyColors.grey,
                  ),
                ),
                SizedBox(height: 16.h),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [...Provider.of<DeviceProvider>(context, listen: false).getDevices().map((e) => DeviceCard(device: e,isFromHome: true,))],
                  ),
                ),
                SizedBox(height: 32.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Locations',
                      style: TextStyles.body.copyWith(
                        fontWeight: FontWeight.w500,
                        color: SmartyColors.grey,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        mainAxisExtent: 100,
                      ),
                      itemCount: Provider.of<DeviceProvider>(context, listen: false).getDevices().length,
                      itemBuilder: (BuildContext context, int index) {
                        return RoomCard(location: Provider.of<DeviceProvider>(context, listen: false).getDevices()[index].room);
                      }),
                ),
              ]),
        ),
      ),
    );
  }




}


