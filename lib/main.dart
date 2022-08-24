import 'dart:io';
import 'package:chess_one/app.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('Chess One');
    setWindowMinSize(const Size(600, 400));
    setWindowMaxSize(Size.infinite);
  }

  runApp(const App());
}
