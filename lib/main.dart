import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mtp_live_sound/core/app.dart';
import 'package:mtp_live_sound/core/controllers/controllers.dart';
import 'package:provider/provider.dart';

FirebaseAnalytics analytics;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp firebaseApp = await Firebase.initializeApp();
  final db = FirebaseFirestore.instanceFor(app: firebaseApp);
  db.collection('users').snapshots(includeMetadataChanges: false);

  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(
      true); // turn this off after seeing reports in in the console.
  Firebase.app().setAutomaticDataCollectionEnabled(
      true); // turn this off after seeing reports in in the console.
  Firebase.app()
      .isAutomaticDataCollectionEnabled; // turn this off after seeing reports in in the console.
  Firebase.app().setAutomaticResourceManagementEnabled(
      true); // turn this off after seeing reports in in the console.
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  Provider.debugCheckInvalidValueType = null;
  analytics = FirebaseAnalytics();
  await GetStorage.init();
  Get.put<AuthController>(AuthController());
  Get.put<ThemeController>(ThemeController());
  Get.put<LanguageController>(LanguageController());
  runApp(MyApp());
}

