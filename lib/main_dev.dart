import 'package:flutter/cupertino.dart';
import 'package:yes_broker/env/app_env.dart';
import 'package:yes_broker/main.dart';

void main() {
  AppEnvironment.setupEnv(Environment.dev);
  runApp(const MyApp());
}
