import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:provider/provider.dart';
import 'package:smarty/Provider/IsServerConnectedProvider.dart';

import '../Helper/LocalDatabase.dart';
import '../Provider/DeviceProvider.dart';
import 'devices/domain/models/devices.dart';
import 'devices/presentation/views/device_home.dart';
import 'home/presentation/views/home.dart';
import 'routine/presentation/views/routine_home.dart';
import 'stats/presentation/views/stats_home.dart';
import 'voice/presentation/views/voice_home.dart';

class Dashboard extends StatefulWidget {
  final int initialTab;
  const Dashboard({Key? key, this.initialTab = 0}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}
String serverDomain='';
String serverPort='';
String serverUserName='';
String serverPassword='';
String serverToken='';

final client = MqttServerClient(serverDomain, '1883',);
class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;




  final List<Widget> _children = const [
    HomeScreen(),
    DevicesScreen(),
    //VoiceHomeScreen(),
    RoutineHomeScreen(),
    //StatsHomeScreen(),
  ];

  List<Device> list_for_updates=[];

  @override
  void initState() {
    _tabController = TabController(length: _children.length, vsync: this);
    _tabController.index = widget.initialTab;
    super.initState();
    loadAllData();
  }

  void onTabTapped(int index) {
    _tabController.index = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        children: _children,
        controller: _tabController,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: _tabController.index,
        unselectedFontSize: 14,
        elevation: 2.0,
        // selectedItemColor: ShuttlersColors.shuttlersGreen,
        // selectedIconTheme: ShuttlersThemes.iconThemeData,
        // selectedLabelStyle: TextStyle(
        //   fontWeight: FontWeight.w600,
        //   letterSpacing: 0.0,
        //   fontSize: 12.0,
        // ),
        // unselectedLabelStyle: TextStyle(
        //   letterSpacing: 0.0,
        //   fontSize: 12.0,
        // ),
        // backgroundColor: Colors.white,
        enableFeedback: true,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_outlined),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.phone_iphone_rounded),
              activeIcon: Icon(Icons.phone_iphone_rounded),
              label: "Device"),
          /*BottomNavigationBarItem(
              icon: Icon(Icons.keyboard_voice_outlined),
              activeIcon: Icon(Icons.keyboard_voice_outlined),
              label: "Voice"),*/
          BottomNavigationBarItem(
              icon: Icon(Icons.replay_rounded),
              activeIcon: Icon(Icons.replay_rounded),
              label: "Routine"),
         /* BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded),
              activeIcon: Icon(Icons.bar_chart_rounded),
              label: "Stats"),*/
        ],
      ),
    );
  }


  void mqttServerConnectivity()async{//test.mosquitto.org
    /// Set the correct MQTT protocol for mosquito
    print("domain $serverDomain");
    client.setProtocolV311();
    client.logging(on: false);
    //client.keepAlivePeriod = 20;
    client.onDisconnected = onDisconnected;
    client.onSubscribed = onSubscribed;
    client.onConnected=onConnected;

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
      Provider.of<IsServerConnectedProvider>(context, listen: false).updateStatus(true);
    } else {
      print('EXAMPLE::ERROR Mosquitto client connection failed - disconnecting, state is ${client.connectionStatus!.state}');
      client.disconnect();
      Provider.of<IsServerConnectedProvider>(context, listen: false).updateStatus(false);
    }


    client.updates!.listen((dynamic messageList) {
      print(" listening.... ${messageList.length}");
      if(messageList.length>0) {
        print("my message is ${messageList[0].payload}");
      }
      final MqttPublishMessage recMess = messageList[0].payload;
      final message = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      print('message id : $message    ${recMess.variableHeader?.topicName}');

      print('EXAMPLE::Change notification:: topic is <${recMess.variableHeader?.topicName}>, payload is <--${messageList[0].payload.toString()}  -->');

      if(recMess.variableHeader?.topicName!=null) {
        String? devName = recMess.variableHeader?.topicName.split("/")[2];
        print('updating length ${list_for_updates.length}');
        for(int a=0;a<list_for_updates.length;a++) {
          if (list_for_updates[a].name == devName) {
           // print('updating device $devName');
            //if(messagelist_for_updates[0].payload.toString()[1]=="1"){
            if (recMess.variableHeader?.topicName.split("/").last == "Alarm") {
              list_for_updates[a].alarm = message.toString();
            } else if (recMess.variableHeader?.topicName.split("/").last == "Mute") {
              list_for_updates[a].mute = message.toString();
            } else if (recMess.variableHeader?.topicName.split("/").last == "Power") {
              list_for_updates[a].power = message.toString();
            }
            //print('length is...${list_for_updates[a].index}');
            Provider.of<DeviceProvider>(context, listen: false).update(list_for_updates[a].index, list_for_updates[a]);
            //}
          }
        }
        // Provider.of<DeviceProvider>(context, listen: false)
        //     .getDevices()
        //     .forEach((element) {
        //       print('running...');
        //   // if (element.name == devName) {
        //   //   //if(messageList[0].payload.toString()[1]=="1"){
        //   //   if (recMess.variableHeader?.topicName.split("/").last == "Alarm") {
        //   //     element.alarm = message.toString();
        //   //   } else if (recMess.variableHeader?.topicName.split("/").last == "Mute") {
        //   //     element.mute = message.toString();
        //   //   } else if (recMess.variableHeader?.topicName.split("/").last == "Power") {
        //   //     element.power = message.toString();
        //   //   }
        //   //   Provider.of<DeviceProvider>(context, listen: false).update(
        //   //       element.index, element);
        //   //   //}
        //   // }
        // });
      }else{
        print("payload is null");
      }


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
    // client.publishMessage(topic1, MqttQos.exactlyOnce, builder1.payload!);
    final builder2 = MqttClientPayloadBuilder();
    builder2.addString('Hello from mqtt_client topic 2');
    print('EXAMPLE:: <<<< PUBLISH 2 >>>>');
    //client.publishMessage(topic2, MqttQos.exactlyOnce, builder2.payload!);
    //print('EXAMPLE::Sleeping....');
    //await MqttUtilities.asyncSleep(60);
    //print('EXAMPLE::Unsubscribing');
    // client.unsubscribe(topic1);
    //client.unsubscribe(topic2);
    //await MqttUtilities.asyncSleep(2);
    print('EXAMPLE::Disconnecting');
    //client.disconnect();

  }
  /// The subscribed callback
  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  void onConnected() {
    Provider.of<IsServerConnectedProvider>(context, listen: false).updateStatus(true);
    /// Lets try our subscriptions
    print('EXAMPLE:: <<<< y real topic 1 >>>>');
    const statusTopic1 = 'CeeTech/E_Fence_Alert/E-Fence-2/stat/#'; // Not a wildcard topic
    String powerTopic;
    //String onlineTopic;
    Provider.of<DeviceProvider>(context, listen: false).getDevices().forEach((element) {
      //onlineTopic="${element.deviceBrand}/${element.deviceModel}/${element.name}/stat/Status";
       powerTopic="${element.deviceBrand}/${element.deviceModel}/${element.name}/stat/#";
       client.subscribe(powerTopic, MqttQos.exactlyOnce); //All topics subscribed for all devices
    });
    client.subscribe(statusTopic1, MqttQos.exactlyOnce);
    print('EXAMPLE:: <<<< my real topic 2 >>>>');
  }

  /// The unsolicited disconnect callback
  void onDisconnected()async {
    Provider.of<IsServerConnectedProvider>(context, listen: false).updateStatus(false);
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    try {
      print('connecting2....');
      await client.connect();
      print('connected2.....');
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
      client.disconnect();
    }
  }



  Future<void> loadDevices() async {
    print("app home before loading  ${Provider.of<DeviceProvider>(context, listen: false).getDevices().length}");
    list_for_updates = await LocalDatabase.getStringList(LocalDatabase.MY_DEVICES_LIST);
     print("my devices...${list_for_updates.length}");
     print("app home before loading  ${Provider.of<DeviceProvider>(context, listen: false).getDevices().length}");
     Provider.of<DeviceProvider>(context, listen: false).addAll(list_for_updates);
     print("app home after loading  ${Provider.of<DeviceProvider>(context, listen: false).getDevices().length}");

    //setState(() {});
  }

  void loadAllData() async {
    await loadDevices();
    mqttServerConnectivity();
  }


}
