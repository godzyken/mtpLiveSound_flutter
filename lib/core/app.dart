import 'package:flutter/material.dart';
import 'package:mtpLiveSound/core/constants/app_constants.dart';
import 'package:mtpLiveSound/core/providers/provider_setup.dart';
import 'package:mtpLiveSound/ui/router.dart'as root;
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Test Flutter app',
        theme:ThemeData(primarySwatch: Colors.blue),
        initialRoute: RoutePaths.Landing,
        onGenerateRoute: root.Router.generateRoute,
      ),
    );
  }
}