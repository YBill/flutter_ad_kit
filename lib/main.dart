import 'package:flutter/material.dart';
import 'package:flutter_ad_kit/ad/custom_ad_config.dart';
import 'package:flutter_ad_kit/details_page.dart';
import 'package:flutter_ad_kit/navigation_manager.dart';
import 'package:flutter_ad_kit/src/ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Ads.instance.initialize(CustomAdConfig());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: NavigationApp.navigatorKey,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Platform Ads'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                    return const DetailsPage();
                  }));
                },
                child: const Text(
                  'Show Ads',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ))
          ],
        ),
      ),
    );
  }
}
