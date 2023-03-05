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

final client = MqttServerClient(serverDomain, 'my_app');
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



  @override
  void initState() {
    _tabController = TabController(length: _children.length, vsync: this);
    _tabController.index = widget.initialTab;
    loadAllData();
    super.initState();
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


    client.updates!.listen((messageList) {
      print(" listening.... ${messageList.length}");
      if(messageList.length>0){
        print("my message is ${messageList[0].payload}");
      }

      final recMess = messageList[0];
      // if (recMess is! MqttReceivedMessage<MqttPublishMessage>) return;
      // final pubMess = recMess.payload;
      // final pt = MqttPublishPayload.bytesToStringAsString(pubMess.payload.message);
      print('EXAMPLE::Change notification:: topic is <${recMess.topic}>, payload is <--  -->');
      String devName=recMess.topic.split("ert/")[1].split("/sta").first;
      Provider.of<DeviceProvider>(context, listen: true).getDevices().forEach((element) {
        if(element.name==devName) {
          //if(messageList[0].payload.toString()[1]=="1"){
            if(recMess.topic.split("stat/")[1]=="Alarm"){
              element.alarm=messageList[0].payload.toString()[1];
            }else if(recMess.topic.split("stat/")[1]=="Mute"){
              element.mute=messageList[0].payload.toString()[1];
            }else if(recMess.topic.split("stat/")[1]=="Power"){
              element.power=messageList[0].payload.toString()[1];
            }
            Provider.of<DeviceProvider>(context, listen: false).update(element.index, element);
          //}
        }
      });
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
    Provider.of<DeviceProvider>(context, listen: false).getDevices().forEach((element) {
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
    List<Device> strList = await LocalDatabase.getStringList(LocalDatabase.MY_DEVICES_LIST);
    print("my devices...${strList.length}");
    Provider.of<DeviceProvider>(context, listen: false).addAll(strList);
    setState(() {});
  }

  void loadAllData() async {
    await loadDevices();
    mqttServerConnectivity();
  }


}
