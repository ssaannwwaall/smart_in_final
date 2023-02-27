import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:smarty/Helper/LocalDatabase.dart';
import '../../../../Provider/DeviceProvider.dart';
import '../../../../core/navigation/navigator.dart';
import '../../../../shared/res/res.dart';
import '../../../../shared/widgets/onboarding_widget.dart';
import '../../../devices/domain/models/devices.dart';
import '../widgets/widgets.dart';
import 'package:provider/provider.dart';

String serverDomain='';
String serverPort='';
String serverUserName='';
String serverPassword='';
String serverToken='';
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
    loadServerData();
    loadDevices();
  }
  void loadDevices() async {
    List<Device> strList = await LocalDatabase.getStringList(LocalDatabase.MY_DEVICES_LIST);
    print("my devices...${strList.length}");
    Provider.of<DeviceProvider>(context, listen: false).addAll(strList);
    setState(() {});
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

    MediaQueryData mediaQuery=MediaQuery.of(context);
    double _width=mediaQuery.size.width;
    double _height=mediaQuery.size.height;
    return SingleChildScrollView(
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
                  'Good Morning, Sanwal',
                  style: TextStyles.headline4,
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
          /* SizedBox(height: 32.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Quick Action',
                style: TextStyles.body.copyWith(
                  fontWeight: FontWeight.w500,
                  color: SmartyColors.grey,
                ),
              ),
              Text(
                'Edit',
                style: TextStyles.body.copyWith(
                  color: SmartyColors.grey60,
                ),
              )
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ...['Wake up', 'Sleep', 'Clean']
                  .map((e) => QuickAction(action: e))
            ],
          ),
          */
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
              children: [...devices.map((e) => DeviceCard(device: e,isFromHome: true,))],
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
    );
  }

  void loadServerData() async {
    serverDomain=await LocalDatabase.getString(LocalDatabase.SERVER_DOMAIN);
    serverPort=await LocalDatabase.getString(LocalDatabase.SERVER_PORT);
    serverUserName=await LocalDatabase.getString(LocalDatabase.SERVER_USER_NAME);
    serverPassword=await LocalDatabase.getString(LocalDatabase.SERVER_PASSWORD);
    serverToken=await LocalDatabase.getString(LocalDatabase.SERVER_TOKEN);
    final client = MqttServerClient(serverDomain, '');
    /// Set the correct MQTT protocol for mosquito
    client.setProtocolV311();
    client.logging(on: false);
    client.keepAlivePeriod = 20;
    client.onDisconnected = onDisconnected;
    client.onSubscribed = onSubscribed;
    final connMess = MqttConnectMessage()
        .withClientIdentifier('Mqtt_MyClientUniqueIdQ2')
        .withWillTopic('willtopic') // If you set this you must set a will message
        .withWillMessage('My Will message')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
    print('EXAMPLE::Mosquitto client connecting....');
    client.connectionMessage = connMess;
    try {
      print('connecting....');
      await client.connect();
      print('connected.....');
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
      client.disconnect();
    }

    /// Check we are connected
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('EXAMPLE::Mosquitto client connected');
    } else {
      print('EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, state is ${client.connectionStatus!.state}');
      client.disconnect();
    }

    /// Lets try our subscriptions
    print('EXAMPLE:: <<<< SUBSCRIBE 1 >>>>');
    const topic1 = 'SJHTopic1'; // Not a wildcard topic
    client.subscribe(topic1, MqttQos.exactlyOnce);
    print('EXAMPLE:: <<<< SUBSCRIBE 2 >>>>');
    const topic2 = 'SJHTopic2'; // Not a wildcard topic
    client.subscribe(topic2, MqttQos.exactlyOnce);
    client.updates!.listen((messageList) {
      final recMess = messageList[0];
      if (recMess is! MqttReceivedMessage<MqttPublishMessage>) return;
      final pubMess = recMess.payload;
      final pt =
      MqttPublishPayload.bytesToStringAsString(pubMess.payload.message);
      print(
          'EXAMPLE::Change notification:: topic is <${recMess.topic}>, payload is <-- $pt -->');
      print('');
    });

    /// If needed you can listen for published messages that have completed the publishing
    /// handshake which is Qos dependant. Any message received on this stream has completed its
    /// publishing handshake with the broker.
    // ignore: avoid_types_on_closure_parameters
    client.published!.listen((MqttPublishMessage message) {
      print('EXAMPLE::Published notification:: topic is ${message.variableHeader!.topicName}, with Qos ${message.header!.qos}');
    });

    final builder1 = MqttClientPayloadBuilder();
    builder1.addString('Hello from mqtt_client topic 1');
    print('EXAMPLE:: <<<< PUBLISH 1 >>>>');
    client.publishMessage(topic1, MqttQos.exactlyOnce, builder1.payload!);
    final builder2 = MqttClientPayloadBuilder();
    builder2.addString('Hello from mqtt_client topic 2');
    print('EXAMPLE:: <<<< PUBLISH 2 >>>>');
    client.publishMessage(topic2, MqttQos.exactlyOnce, builder2.payload!);
    print('EXAMPLE::Sleeping....');
    await MqttUtilities.asyncSleep(60);
    print('EXAMPLE::Unsubscribing');
    client.unsubscribe(topic1);
    client.unsubscribe(topic2);
    await MqttUtilities.asyncSleep(2);
    print('EXAMPLE::Disconnecting');
    client.disconnect();

  }
  /// The subscribed callback
  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  /// The unsolicited disconnect callback
  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
  }



}


