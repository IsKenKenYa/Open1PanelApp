import 'dart:io';
import 'package:flutter/foundation.dart';

void main() async {
  final envFile = File('../../.env');
  if (envFile.existsSync()) {
    debugPrint("Found .env");
    debugPrint(await envFile.readAsString());
  } else {
    debugPrint(".env not found");
  }
}
