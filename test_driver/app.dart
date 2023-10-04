// import 'package:flutter_test/flutter_test.dart';
// import 'package:flutter_driver/flutter_driver.dart' as driver;

// void main() {
//   group('App Automation Test', () {
//     late driver.FlutterDriver flutterDriver;

//     setUpAll(() async {
//       flutterDriver = await driver.FlutterDriver.connect();
//     });

//     tearDownAll(() async {
//       flutterDriver.close();
//     });

//     test('Login Test', () async {
//       final usernameFieldFinder = driver.find.byValueKey('usernameField');
//       final passwordFieldFinder = driver.find.byValueKey('passwordField');
//       await flutterDriver.tap(usernameFieldFinder);
//       await flutterDriver.enterText('bhavesh@gmail.com');
//       await flutterDriver.tap(passwordFieldFinder);
//       await flutterDriver.enterText('123456');
//       await flutterDriver.tap(driver.find.byValueKey('loginButton'));
//       await flutterDriver.waitFor(driver.find.byValueKey('YesBroker'));
//       print("object-=============================");
//     });

//     // Add more test cases as needed.
//     // ...
//   });
// }
