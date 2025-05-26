import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Williams/models/widgets/Appbar.dart';
import 'package:Williams/models/widgets/myDrawer.dart';
import 'package:Williams/services/AppData.dart';
import 'package:Williams/widgets/actionController.dart';

import 'package:Williams/widgets/moveControllers.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbar(title: "Controller"),
      drawer: MyDrawer(),
      body: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MoveControllers(),
          Spacer(),
          ActionsControllers(),
          SizedBox(width: 30,),
          Container(
            padding: EdgeInsets.only(right: 10),
            height: 250,
            child: SfSlider.vertical(
              showDividers: true,
              activeColor: Theme.of(context).colorScheme.secondary,
              inactiveColor: Colors.grey,
              enableTooltip: true,
              value: MainData.speed,
              min: 150,
              max: 250,
              stepSize: 1,
              onChanged: (value) async {
                setState(() {
                  MainData.speed = value;
                });
                sendCommand(MainData.speed.toInt());
                print(String.fromCharCode(MainData.speed.toInt()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
