import 'package:flutter/material.dart';
import 'package:smarty/features/devices/domain/models/devices.dart';

class DeviceProvider extends ChangeNotifier {
  final List<Device> _myDevices = [];

  void add(Device item) {
    _myDevices.add(item);
    notifyListeners();
  }
  void addAll(List<Device> li) {
    print("llllllllllllllllllll");
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
    print('updaeting at $position   item is   ${item.index}');
    //_myDevices.insert(position, item);
    _myDevices[position]= item ;//(position, item);
    //_myDevices.
    notifyListeners();
  }
}
