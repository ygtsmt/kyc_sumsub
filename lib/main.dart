import 'package:flutter/material.dart';
import 'package:flutter_idensic_mobile_sdk_plugin/flutter_idensic_mobile_sdk_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Sumsub'),
        centerTitle: true,
      ),
      body: Center(
          child: Center(
        child: FilledButton(
            onPressed: () => launchSDK(), child: const Text('Launch')),
      )),
    );
  }

  void launchSDK() async {
    String? applicantId;
    final onTokenExpiration = () async {
      return Future<String>.delayed(const Duration(seconds: 2),
          () => 'YOUR KYC ONSITE ACCESS TOKEN IS HERE');
    };

    final SNSEventHandler onEvent = (SNSMobileSDKEvent event) {
      if ((event.payload["applicantId"].toString().length) > 8) {
        setState(() {
          applicantId = event.payload["applicantId"].toString();
        });
      } else {
        debugPrint("küçük ${event.payload["applicantId"].toString()}");
      }
    };

    final SNSStatusChangedHandler onStatusChanged =
        (SNSMobileSDKStatus newStatus, SNSMobileSDKStatus prevStatus) {};

    final snsMobileSDK = SNSMobileSDK.init(
            'YOUR KYC ONSITE ACCESS TOKEN IS HERE', onTokenExpiration)
        .withHandlers(onStatusChanged: onStatusChanged, onEvent: onEvent)
        .withDebug(true)
        .withLocale(const Locale("en"))
        .build();

    final SNSMobileSDKResult result = await snsMobileSDK.launch();
  }
}
