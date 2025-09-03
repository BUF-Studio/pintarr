import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pintarr/app.dart';
import 'package:pintarr/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  try {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // setWindowTitle("Pintar Care");

      // setWindowMinSize(Size(1030, 600));
      // setWindowFrame()
      // setWindowMaxSize(Size(600, 1000));
      Size size = await DesktopWindow.getWindowSize();
    // print(size);
    await DesktopWindow.setMinWindowSize(const Size(1030,600));
    }
  } catch (e) {}
  // runApp(MyApp());

  runApp(App());
}
