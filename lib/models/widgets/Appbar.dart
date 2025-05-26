// ignore_for_file: file_names, camel_case_types, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:popover/popover.dart';
import 'package:Williams/services/AppData.dart';
import 'package:Williams/widgets/ConnectionCompleted.dart';

class Appbar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onUpdate;
  const Appbar({super.key, required this.title, this.onUpdate});

  @override
  State<Appbar> createState() => _AppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

class _AppbarState extends State<Appbar> {
  Icon icon = Icon(
    Icons.menu_rounded,
    size: 32,
    weight: 500,
  );
  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      scrolledUnderElevation: 0,
      title: Text(
        widget.title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
      ),
      actions: [
        (widget.title == "Controller")
            ? Builder(
                key: ValueKey(MainData.address),
                builder: (BuildContext context) => IconButton(
                  onPressed: () async {
                    setState(() {
                      getDevices();
                    });
                    if (!context.mounted) {
                      return;
                    }
                    showPopover(
                      width: 300,
                      context: context,
                      direction: PopoverDirection.bottom,
                      bodyBuilder: (context) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          MainData.devices.length,
                          (index) => ListTile(
                            key: ValueKey(index),
                            title:
                                Text(MainData.devices[index].name ?? 'HC-05'),
                            subtitle: Text(MainData.devices[index].address),
                            onTap: () async {
                              if (MainData.address ==
                                  MainData.devices[index].address) {
                                setState(() {
                                  MainData.isConnected = false;
                                  MainData.address = "";
                                  MainData.device.close();
                                  MainData.device.dispose();
                                });
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      ConnectionCompleted(
                                          MainData.devices[index].name ??
                                              'HC-05',
                                          false));
                                }
                              } else {
                                try {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      Connecting(
                                          MainData.devices[index].name ??
                                              'HC-05',
                                          context,
                                          true));
                                  MainData.device =
                                      await BluetoothConnection.toAddress(
                                          MainData.devices[index].address);
                                  print('Connected to the device');
                                  // await sendCommand('CONNECTED');
                                  setState(() {
                                    MainData.isConnected = true;
                                    MainData.address =
                                        MainData.devices[index].address;
                                  });
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        ConnectionCompleted(
                                            MainData.devices[index].name ??
                                                'HC-05',
                                            true));
                                  }
                                } catch (exception) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        Connecting(
                                            MainData.devices[index].name ??
                                                'HC-05',
                                            context,
                                            false));
                                  }
                                  print('Cannot connect, exception occured');
                                  setState(() {
                                    MainData.isConnected = false;
                                    MainData.address = "";
                                  });
                                }
                              }
                            },
                            trailing: Icon(MainData.address ==
                                    MainData.devices[index].address
                                ? Icons.check_outlined
                                : null),
                          ),
                        ),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.surface,
                    );
                  },
                  icon: Icon(
                    MainData.isConnected
                        ? Icons.bluetooth_connected_outlined
                        : Icons.bluetooth_disabled_outlined,
                  ),
                ),
              )
            : SizedBox(),
        SizedBox(
          width: 10,
        )
      ],
    );
  }
}
