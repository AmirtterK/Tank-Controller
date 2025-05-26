import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

SnackBar ConnectionCompleted(String name, bool connected) {
  return SnackBar(
    content: Center(
        child:
            Text(connected ? 'Connected to $name' : 'Disconnected from $name')),
    behavior: SnackBarBehavior.floating,
    width: 350,
  );
}

SnackBar Connecting(String name,BuildContext context,bool running) {
  return SnackBar(
    duration: Duration(milliseconds: running? 4000:2500),
    content: Center(
        child: Row(
      children: [
       running? SpinKitPulse(
          color: Theme.of(context).colorScheme.secondary,
          size: 30,
        ):SizedBox(),
        SizedBox(width: 10,),
        Text(running? 'Connectig to $name':"Cannot to $name" ),
      ],
    )),
    behavior: SnackBarBehavior.floating,
    width: 350,
  );
}
