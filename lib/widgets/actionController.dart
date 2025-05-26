import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Williams/services/AppData.dart';

class ActionsControllers extends StatelessWidget {
  const ActionsControllers({super.key});

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
                onTap: () async => await sendCommand(Command.TRIANGLE.codeUnitAt(0)),
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: Icon(
                    CupertinoIcons.triangle_fill,
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
                  color: Theme.of(context).colorScheme.secondary,
                  child: InkWell(
                    onTap: () async => await sendCommand(Command.SQUARE.codeUnitAt(0)),
                    child: SizedBox(
                      height: 80,
                      width: 80,
                      child: Icon(
                        CupertinoIcons.square_fill,
                        size: 40,
                        color: Theme.of(context).colorScheme.surface,
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
                  color: Theme.of(context).colorScheme.secondary,
                  child: InkWell(
                    onTap: () async => await sendCommand(Command.CIRCLE.codeUnitAt(0)),
                    child: SizedBox(
                      height: 80,
                      width: 80,
                      child: Icon(
                        CupertinoIcons.circle_fill,
                        size: 40,
                        color: Theme.of(context).colorScheme.surface,
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
                onTap: () async => await sendCommand(Command.XMARK.codeUnitAt(0)),
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: Icon(
                    CupertinoIcons.xmark,
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
