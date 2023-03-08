import '../../../../utils/enums.dart';

class Device {
  String? name;
  DeviceType? type = DeviceType.fence ;
  String model;
  String deviceId;
  String deviceIP;
  String deviceModel;
  String deviceBrand;
  bool active;//previous
  String room;
  String mute;
  String power;
  String status="1";// tag change here remove value
  String alarm;
 int index;

  Device(
      {this.name,
       this.type,
      required this.active,
      required this.room,
      required this.mute,
      required this.alarm,
      required this.power,
      required this.deviceBrand,
      required this.deviceId,
      required this.deviceIP,
      required this.deviceModel,
      required this.model,
        required this.index,
        required this.status,
      });
  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      name: json['name'].toString(),
      //type: json['type'],
      active: json['active'],
      room: json['room'].toString(),
      mute: json['mute'].toString(),
      alarm: json['alarm'] as String ?? '',
      power: json['power'] as String ?? '',
      deviceBrand: json['deviceBrand'].toString(),
      deviceId: json['deviceId'],
      deviceIP: json['deviceIP'],
      deviceModel: json['deviceModel'].toString(),
      model: json['model'].toString(),
      index: json['index'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    print('json data is...$data');
    data['name'] = name;
    //data['type'] = DeviceType.fence;
    data['room'] = room;
    data['active'] = active;
    data['mute'] = mute;
    data['alarm'] = alarm;
    data['power'] = power;
    data['deviceBrand'] = deviceBrand;
    data['deviceId'] = deviceId;
    data['deviceIP'] = deviceIP;
    data['deviceModel'] = deviceModel;
    data['model'] = model;
    data['index'] = index;
    data['status'] = status;
    return data;
  }

}

List<Device> devices = [
  Device(
    name: 'Fence-1',
    type: DeviceType.fence,
    active: true,
    room: 'Daroghawala',
    mute: "0",
    alarm: "0",
    power: "0",
    deviceBrand: "0",
    model: "0",
    deviceModel: "0",
    deviceIP: "0",
    deviceId:  "0",
    index: 0,
    status: "0"
  ),
  Device(
    name: 'Smart TV',
    type: DeviceType.smartTv,
    active: true,
    room: 'Living Room',
      mute: "0",
      alarm: "0",
      power: "0",
      deviceBrand: "0",
      model: "0",
      deviceModel: "0",
      deviceIP: "0",
      deviceId:  "0",
      status: "0",
    index: 1
  ),
  Device(
    name: 'AC',
    type: DeviceType.ac,
    active: true,
    room: 'Living Room',
      mute: "0",
      power: "0",
    alarm: "0",
    deviceBrand: "0",
    model: "0",
    deviceModel: "0",
    deviceIP: "0",
      status: "0",
    deviceId:  "0",
    index: 2
  ),
 /* Device(
    name: 'CCTV',
    type: DeviceType.cctv,
    active: true,
    room: 'Living Room',
  ),
  Device(
    name: 'Refrigerator',
    type: DeviceType.refridgerator,
    active: true,
    room: 'Living Room',
  ),
  Device(
    name: 'Microwave',
    type: DeviceType.microwave,
    active: true,
    room: 'Living Room',
  ),*/
  Device(
    name: 'Light',
    type: DeviceType.light,
    active: true,
    room: 'Living Room',
      mute: "0",
      power: "0",
    alarm: "0",
    deviceBrand: "0",
    model: "0",
    deviceModel: "0",
    deviceIP: "0",
    deviceId:  "0",
      status: "0",
    index: 3
  ),
];
