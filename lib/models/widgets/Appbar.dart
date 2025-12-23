// ignore_for_file: file_names, camel_case_types, avoid_print

import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:Williams/services/AppData.dart';
import 'package:Williams/widgets/ConnectionCompleted.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onUpdate;
  
  const Appbar({super.key, required this.title, this.onUpdate});

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
      ),
      actions: [
        if (title == "Controller")
          StreamBuilder<ConnectionState>(
            stream: MainData.connectionStream,
            initialData: MainData.state,
            builder: (context, snapshot) {
              final state = snapshot.data ?? MainData.state;
              return IconButton(
                onPressed: () => _showBluetoothDialog(context),
                icon: Icon(
                  state.isConnected
                      ? Icons.bluetooth_connected
                      : Icons.bluetooth,
                  size: 24,
                  color: state.isConnected ? Colors.blue : null,
                ),
              );
            },
          ),
        const SizedBox(width: 10),
      ],
    );
  }

  Future<void> _showBluetoothDialog(BuildContext context) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    
    try {
      await getDevices();
      if (context.mounted) Navigator.pop(context);
      if (context.mounted) _showDeviceList(context);
    } catch (e) {
      if (context.mounted) Navigator.pop(context);
      if (context.mounted) _showError(context, 'Failed to load devices: $e');
    }
  }

  void _showDeviceList(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.bluetooth, color: Colors.blue),
            SizedBox(width: 10),
            Text('Bluetooth Devices'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: StreamBuilder<ConnectionState>(
            stream: MainData.connectionStream,
            initialData: MainData.state,
            builder: (context, snapshot) {
              final state = snapshot.data ?? MainData.state;
              
              if (state.devices.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.bluetooth_disabled, size: 50, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text('No devices found'),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showBluetoothDialog(context);
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Scan'),
                      ),
                    ],
                  ),
                );
              }
              
              return Column(
                children: [
                  // Status
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: state.isConnected ? Colors.green[50] : Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          state.isConnected ? Icons.check_circle : Icons.info,
                          color: state.isConnected ? Colors.green : Colors.grey,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            state.isConnected
                                ? 'Connected to ${state.address}'
                                : '${state.devices.length} devices found',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Device list
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.devices.length,
                      itemBuilder: (context, index) {
                        final device = state.devices[index];
                        final isConnected = state.address == device.address;
                        
                        return Card(
                          color: isConnected ? Colors.blue[50] : null,
                          child: ListTile(
                            leading: Icon(
                              isConnected ? Icons.bluetooth_connected : Icons.bluetooth,
                              color: isConnected ? Colors.blue : Colors.grey,
                            ),
                            title: Text(
                              device.name ?? 'Unknown',
                              style: TextStyle(
                                fontWeight: isConnected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            subtitle: Text(device.address, style: const TextStyle(fontSize: 11)),
                            trailing: isConnected
                                ? const Chip(
                                    label: Text('Connected', style: TextStyle(fontSize: 10)),
                                    backgroundColor: Colors.green,
                                  )
                                : ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _connectToDevice(device, context);
                                    },
                                    child: const Text('Connect'),
                                  ),
                            onTap: isConnected
                                ? () {
                                    Navigator.pop(context);
                                    _disconnectDevice(context);
                                  }
                                : () {
                                    Navigator.pop(context);
                                    _connectToDevice(device, context);
                                  },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showBluetoothDialog(context);
            },
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Future<void> _connectToDevice(BluetoothDevice device, BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text('Connecting...'),
          ],
        ),
      ),
    );
    
    try {
      final connection = await BluetoothConnection.toAddress(device.address);
      MainData.updateConnection(
        isConnected: true,
        device: connection,
        address: device.address,
      );
      
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          ConnectionCompleted(device.name ?? 'Device', true),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        _showError(context, 'Failed to connect: $e');
      }
    }
  }

  void _disconnectDevice(BuildContext context) {
    MainData.clearConnection();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Disconnected')),
    );
  }

  void _showError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}