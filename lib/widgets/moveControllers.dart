import 'package:flutter/material.dart';
import 'package:Williams/services/AppData.dart';

class MoveControllers extends StatelessWidget {
  const MoveControllers({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
            padding: EdgeInsets.only(top: 20, left: 40), 
            child: Column(
              children: [
                ClipOval(
                  child: Material(
                    color: Theme.of(context).colorScheme.secondary,
                    child: InkWell(
                      onTapDown: (details) async =>
                          await sendCommand(Command.FORWARD.codeUnitAt(0)),
                      onTapUp: (details) async =>
                          await sendCommand(Command.STOP.codeUnitAt(0)),
                      child: SizedBox(
                        height: 80,
                        width: 80,
                        child: Icon(
                          Icons.arrow_upward_outlined,
                          size: 40,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    ClipOval(
                      child: Material(
                        color:
                            Theme.of(context).colorScheme.secondary,
                        child: InkWell(
                          onTapDown: (details) async =>
                              await sendCommand(Command.LEFT.codeUnitAt(0)),
                          onTapUp: (details) async =>
                              await sendCommand(Command.STOP.codeUnitAt(0)),
                          child: SizedBox(
                            height: 80,
                            width: 80,
                            child: Icon(
                              Icons.arrow_back_outlined,
                              size: 40,
                              color:
                                  Theme.of(context).colorScheme.surface,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                    ),
                    ClipOval(
                      child: Material(
                        color:
                            Theme.of(context).colorScheme.secondary,
                        child: InkWell(
                          onTapDown: (details) async =>
                              await sendCommand(Command.RIGHT.codeUnitAt(0)),
                          onTapUp: (details) async =>
                              await sendCommand(Command.STOP.codeUnitAt(0)),
                          child: SizedBox(
                            height: 80,
                            width: 80,
                            child: Icon(
                              Icons.arrow_forward_outlined,
                              size: 40,
                              color:
                                  Theme.of(context).colorScheme.surface,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ClipOval(
                  child: Material(
                    color: Theme.of(context).colorScheme.secondary,
                    child: InkWell(
                      onTapDown: (details) async =>
                          await sendCommand(Command.BACKWARD.codeUnitAt(0)),
                      onTapUp: (details) async =>
                          await sendCommand(Command.STOP.codeUnitAt(0)),
                      child: SizedBox(
                        height: 80,
                        width: 80,
                        child: Icon(
                          Icons.arrow_downward_outlined,
                          size: 40,
                          color: Theme.of(context).colorScheme.surface,
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