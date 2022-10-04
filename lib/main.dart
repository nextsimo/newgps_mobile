import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:newgps/src/utils/utils.dart';
import 'app.dart';
import 'src/utils/locator.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setup();
  Utils.initFirebaseConfig();
  Utils.handleSplashScreen(widgetsBinding);
  runApp(Phoenix(child: const NewGpsApp()));
}