import 'package:flutter/material.dart';
import 'package:smarty/features/devices/domain/models/devices.dart';

class IsServerConnectedProvider extends ChangeNotifier {
    bool connected=false;

  void updateStatus(bool newValue) {
    connected=newValue;
    notifyListeners();
  }

  bool getServerStatus(){
    return connected;
  }

}
