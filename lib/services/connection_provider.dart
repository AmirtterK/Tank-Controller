
import 'package:flutter/material.dart';

class ConectionProvider with ChangeNotifier {
  late bool _connected;

  bool isConnected(){
    return _connected;
  }


  ConectionProvider();

  bool get connected => _connected;
  set themeData(bool connected) {
    _connected = connected;
    notifyListeners(); 
  }


  void toggleConnection(bool connected) {
    _connected = connected;

    notifyListeners();
  }
}
