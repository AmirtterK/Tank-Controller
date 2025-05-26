import 'package:Williams/services/AppData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Williams/services/themeprovider.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Drawer(
      width: 150,
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(themeProvider.isDarkMode
                  ? Icons.dark_mode
                  : Icons.light_mode),
              Switch(
                activeTrackColor: Theme.of(context).colorScheme.secondary,
                value: themeProvider.isDarkMode,
                onChanged: (value) =>
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme(),
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          ClipOval(
            child: Material(
              color: Theme.of(context).colorScheme.surface,
              child: InkWell(
                onTapDown: (details) async =>
                    await sendCommand(Command.REV.codeUnitAt(0)),
                onTapUp: (details) async =>
                    await sendCommand(Command.STOP_REV.codeUnitAt(0)),
                child: SizedBox(
                  
                  height: 40,
                  width: 40,
                  child: Icon(
                    // FontAwesomeIcons.bullhorn,
                    Icons.campaign,
                    // FontAwesomeIcons.gaugeHigh,
                    // Icons.volume_up,
                    size: 35,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
