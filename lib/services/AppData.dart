// ignore_for_file: constant_identifier_names
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class MainData {
  static double speed = 150;
  static final StreamController<ConnectionState> _connectionController = 
      StreamController<ConnectionState>.broadcast();
  
  static Stream<ConnectionState> get connectionStream => _connectionController.stream;
  
  static ConnectionState _state = ConnectionState(
    isConnected: false,
    device: null,
    address: '',
    devices: [],
  );
  
  static ConnectionState get state => _state;
  
  static void updateConnection({
    bool? isConnected,
    BluetoothConnection? device,
    String? address,
    List<BluetoothDevice>? devices,
  }) {
    _state = ConnectionState(
      isConnected: isConnected ?? _state.isConnected,
      device: device ?? _state.device,
      address: address ?? _state.address,
      devices: devices ?? _state.devices,
    );
    _connectionController.add(_state);
  }
  
  static void clearConnection() {
    if (_state.device != null) {
      _state.device!.close();
      _state.device!.dispose();
    }
    updateConnection(
      isConnected: false,
      device: null,
      address: '',
    );
  }
  
  static void dispose() {
    _connectionController.close();
  }
}

class ConnectionState {
  final bool isConnected;
  final BluetoothConnection? device;
  final String address;
  final List<BluetoothDevice> devices;
  
  ConnectionState({
    required this.isConnected,
    required this.device,
    required this.address,
    required this.devices,
  });
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

Future<List<BluetoothDevice>> getDevices() async {
  print('Getting Bluetooth devices...');
  
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  
  await bluetooth.cancelDiscovery();
  
  final state = await bluetooth.state;
  print('Bluetooth state: $state');
  
  if (state != BluetoothState.STATE_ON) {
    print('Bluetooth is off, requesting enable...');
    await bluetooth.requestEnable();
  }
  
  var bondedDevices = await bluetooth.getBondedDevices();
  print('Found ${bondedDevices.length} bonded devices');
  
  MainData.updateConnection(devices: bondedDevices);
  
  return bondedDevices;
}

Future<void> sendCommand(int data) async {
  if (!MainData.state.isConnected || MainData.state.device == null) {
    print('Not connected, cannot send command');
    return;
  }
  
  try {
    MainData.state.device!.output.add(Uint8List.fromList([data]));
    await MainData.state.device!.output.allSent;
    print("Command sent: $data");
  } catch (e) {
    print('Error sending command: $e');
    MainData.clearConnection();
  }
}