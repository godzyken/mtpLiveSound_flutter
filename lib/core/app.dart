import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:mtp_live_sound/core/constants/app_constants.dart';
import 'package:mtp_live_sound/core/constants/constants.dart';
import 'package:mtp_live_sound/core/controllers/controllers.dart';
import 'package:mtp_live_sound/localizations.dart';
import 'package:mtp_live_sound/ui/components/components.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ThemeController.to.getThemeModeFromStore();
    return GetBuilder<LanguageController>(
      builder: (languageController) => Loading(
        child: GetMaterialApp(
          //begin language translation stuff //https://github.com/aloisdeniel/flutter_sheet_localization
          locale: languageController.getLocale, // <- Current locale
          localizationsDelegates: [
            const AppLocalizationsDelegate(), // <- Your custom delegate
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales:
          AppLocalizations.languages.keys.toList(), // <- Supported locales
          //end language translation stuff
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
          ],
          debugShowCheckedModeBanner: false,
          //defaultTransition: Transition.fade,
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: ThemeMode.system,
          initialRoute: "/",
          getPages: RoutePaths.routes,
        ),
      ),
    );
  }
}