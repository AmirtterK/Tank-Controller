// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';


class MainData {
  static double speed = 150;
  static List<BluetoothDevice> devices = [];
  static bool isConnected = false;
  static late BluetoothConnection device;
  static String address = "";
}

class Command {
  static const String FORWARD = 'F';
  static const String BACKWARD = 'B';
  static const String LEFT = 'L';
  static const String RIGHT = 'R';
  static const String STOP = 'S';
  static const String TRIANGLE = 'T';
  static const String SQUARE = 'Q';
  static const String CIRCLE = 'C';
  static const String XMARK = 'X';
  static const String REV = '0';
  static const String STOP_REV = '1';
}

class Device {
  static int pixelRatio = 4;
}

StreamSubscription<BluetoothDiscoveryResult>? _discoverySubscription;

Future<void> getDevices() async {
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  
  await bluetooth.cancelDiscovery();

  if ((await bluetooth.state) != BluetoothState.STATE_ON) {
    await bluetooth.requestEnable();
  }

  MainData.devices.clear();

  var bondedDevices = await bluetooth.getBondedDevices();
  for (var device in bondedDevices) {
    if (!MainData.devices.any((d) => d.address == device.address)) {
      MainData.devices.add(device);
      print("Bonded device: ${device.address}");
    }
  }

  _discoverySubscription = bluetooth.startDiscovery().listen((result) {
    if (!MainData.devices.any((d) => d.address == result.device.address)) {
      MainData.devices.add(result.device);
      print("Discovered: ${result.device.address}");
    }
  });

  _discoverySubscription!.onDone(() {
    print("Discovery finished");
    MainData.devices.removeWhere((device) => device.name == null);
  });
}



Future<void> sendCommand(int data) async {
  if (!MainData.isConnected) return;
  MainData.device.output.add(Uint8List.fromList([data]));
  await MainData.device.output.allSent;
  print("command sent: $data");
}
