import 'dart:convert';

import 'package:coin_cap/model/app_config.dart';
import 'package:coin_cap/pages/HomePage.dart';
import 'package:coin_cap/services/http_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // to make sure all the things are initialized
  await loadConfig();
  registerHTTPService(); // make sure load config called before. because we are using it https_service.dart
  runApp(const MyApp());
}

void registerHTTPService() {
  GetIt.instance.registerSingleton<HTTPService>( // 3
    HTTPService(),
  );
}


Future<void> loadConfig() async {
  String _configContent = await rootBundle.loadString("assets/config/main.json"); // 1
  Map _configData = jsonDecode(_configContent);
  GetIt.instance.registerSingleton<AppConfig>( // 2
    AppConfig(COIN_BASE_API_URL: _configData["COIN_API_BASE_URL"]),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coin Cap',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black
      ),
      home: HomePage(),
    );
  }
}

/* Documentation  :

1. String _configContent = await rootBundle.loadString("assets/config/main.json");
   this line loads the content of the specified JSON file (main.)
   rootBundle: This is a Flutter class that provides access to the resources (like assets) bundled with the application.

2.   GetIt.instance.registerSingleton<AppConfig>(
    registerSingleton : line registers a singleton instance of the AppConfig class with the GetIt service locator.
    It ensures that there is only one instance of AppConfig throughout the application.

3.   GetIt.instance.registerSingleton<HTTPService>(
     This line registers a singleton instance of the HTTPService class with the GetIt service locator.


* */
