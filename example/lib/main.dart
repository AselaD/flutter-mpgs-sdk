import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_mpgs/flutter_mpgs.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _initStatus = 'Unknown';
  String _updateStatus = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initSDK() async {
    String initState = "";
    try {
      final region = Region.MTF;
      final gatewayId = "DPTEST";
      final apiVersion = "46";

      await FlutterMPGS.init(
          region: region, gatewayId: gatewayId, apiVersion: apiVersion);
      initState = "initialized with region: $region, gatewayId: $gatewayId";
    } on PlatformException catch (e) {
      print(e);
      initState = e.message;
    }
    if (!mounted) return;
    setState(() {
      _initStatus = initState;
    });
  }

  Future<void> _updateSession() async {
    String updateStatus = "";

    try {
      final String sessionId = "1234565432112675757232325747576769";
      final String cardholderName = "test";
      final String cardNumber = "1234543265548765";
      final String year = "10";
      final String month = "22";
      final String cvv = "123";

      await FlutterMPGS.updateSession(
          sessionId: sessionId,
          cardHolder: cardholderName,
          cardNumber: cardNumber,
          year: year,
          month: month,
          cvv: cvv);
      updateStatus =
          "Session updated.\nsessionId: $sessionId\ncardholderName:$cardholderName\ncardNumber:$cardNumber\nyear:$year\nmonth:$month\ncvv:$cvv";
    } on PlatformException catch (e) {
      print(e);
      updateStatus = e.message;
    }

    if (!mounted) return;
    setState(() {
      _updateStatus = updateStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("MPGS Test",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.title),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              child: Text("Init SDK"),
              onPressed: () {
                this._initSDK();
              },
            ),
            Text(
              "$_initStatus",
              textAlign: TextAlign.center,
            ),
            TextFormField(onChanged: (t) {}),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              child: Text("Update Session"),
              onPressed: () {
                this._updateSession();
              },
            ),
            Text(
              "$_updateStatus",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
