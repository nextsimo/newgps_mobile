import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'src/utils/locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   Firebase.initializeApp();
  setup();
  runApp(const NewGpsApp());
}