# flutter_mpgs

Flutter plugin for mpgs sdk

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.

### Usage

- initialize before update session
await FlutterMPGS.init(region: region, gatewayId: gatewayId, apiVersion: apiVersion);

- update mpgs session using sessionId and card details

await FlutterMPGS.updateSession(
    sessionId: sessionId,
    cardHolder: cardholderName,
    cardNumber: cardNumber,
    year: year,
    month: month,
    cvv: cvv);
