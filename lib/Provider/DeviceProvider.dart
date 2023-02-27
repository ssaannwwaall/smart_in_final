import 'package:flutter/material.dart';
import 'package:smarty/features/devices/domain/models/devices.dart';

class DeviceProvider extends ChangeNotifier {
  final List<Device> _myDevices = [];

  void add(Device item) {
    _myDevices.add(item);
    notifyListeners();
  }
  void addAll(List<Device> li) {
    _myDevices.addAll(li);
    notifyListeners();
  }

  void removeAll() {
    _myDevices.clear();
    notifyListeners();
  }

  List<Device> getDevices() {
    //notifyListeners();
    return _myDevices;
  }

  void update(int position,Device item) {
    //_myDevices.re(item);
    _myDevices.insert(position, item);
    notifyListeners();
  }
}
