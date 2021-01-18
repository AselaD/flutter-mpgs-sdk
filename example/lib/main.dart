import 'package:flutter/material.dart';
import 'package:flutter_mpgs_sdk/card_add_form.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    CardAddForm.init(
        "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImQxN2Q5OGJhMGUxNDg0ZjI3OGNhMTExMzYyNzczOWQ5YjM2NjQzMDcwZWUxMzBhNmYxYWJhMThhNDBmOTk4YWNmZTVkOTc4MThlOTYxNDdlIn0.eyJhdWQiOiIxIiwianRpIjoiZDE3ZDk4YmEwZTE0ODRmMjc4Y2ExMTEzNjI3NzM5ZDliMzY2NDMwNzBlZTEzMGE2ZjFhYmExOGE0MGY5OThhY2ZlNWQ5NzgxOGU5NjE0N2UiLCJpYXQiOjE1OTQ2NDMwNjIsIm5iZiI6MTU5NDY0MzA2MiwiZXhwIjoxNjI2MTc5MDYyLCJzdWIiOiIxNSIsInNjb3BlcyI6WyJvcmVsX3BheS51c2VyIl19.hwOlZBf5S8I4eK-dsK9LKtv52vtFMVMssc-Y6Io1tnCd5Wd-l1N6MEP4mmTE4YYIVLDoqxEboa9bCgpDxMzI8TXvtn6yPdsLLbR1axiwh4TjWOyVNe00Hja8vvFzTsJEoUaw0Bn5e1DmXskjarpFNiFmD-9kvyK91GcSzAEWlMwKZ0gtrZNf-U88_a7xS47arTvGe-dX29DbQTG-Eyt8PN_SAMDva4_rb0qhIkAUDBIRz4RP6l8aP57Faid6WwdMiAaGuxqjOUck2O_9j8zzYI-ycx36jmrQ3Iv4g_Zo3VdGDOxoBik7kpHYeqVG8T4ed7j5zV_hmOoDZtBqIG8LLLkqTPme6V6LEQpG08KNFdm3FrR3jiOPwE-sjp3nbVIF2UjFTmSIPJLrOHvDdhEQKGOvKijTuNDJAERtWG4dvwSdxpDaSZZu4fvBUGn_IYrXDVwD0N7nsn8r0YlhIqYzGYkgViExLkZwE3XpL13X3oCr9MobS8ps9BcTbYa-QbScRaRmp3STviAq9C3NMnMxpNrTBdwYl2_it11zLZeGYbZK2kvXiavWWcNRcmrZnNWENDwB1Tn3U2F9nZJ--bKIElb9Qo6TcqF0qjCvTOI45HZ2wTg7sskJ3tKiO7REI2bu2sbLzQ5wHNe0QqItKyU_w81noLwS52_3YGf_q5HdTuE");
    CardAddForm.setBlinkCardLicense(
        ios:
            "sRwAAAEbY29tLnBheW1lZGlhLmZsdXR0ZXJtcGdzc2Rrb0Zmmo/7xgX58rpEcM7aOvgjjAo1TCkn4oWt12lUNJ7exKJza8ee5uaUP9+VTl6bQ+cfLgMZdx0ftWioPOCvsQcglwzhQGn+PiVNjCuzzPxR/97eYTW4Z/EXc+kl2N4vjntxh/N0Q3lUgJXzvbMot1fzEtfMJyxMOcx2N2mTLcgdoI7v64/v4Q==",
        android: "sRwAAAAdY29tLnBheW1lZGlhLmZsdXR0ZXJfbXBnc19zZGuXTEDpVPGE+034r9lUr130/82GTtzRNquQMEOY4EsxvtNtiz+Fa27U9x6PAZ5d0iO/8XRNwKxdAQoxhzFpLD868PlWqQp/hVRXRrk/WWnAdTbTgqed1IxgmunWicSaAnlIqPIPGEmAE+FTCz5imN80Cr2Qclszd9RAdH84Uir5emVfnecGNTZ0");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('Plugin example app'),
          ),
          body: CardAddForm()),
    );
  }
}
