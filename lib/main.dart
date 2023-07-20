import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yes_broker/constants/utils/theme.dart';
import 'package:yes_broker/routes/routes.dart';
import 'firebase_options.dart';
import 'package:yes_broker/layout.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    GoogleMapController mapController;
    // LatLng _selectedLatLng;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Brokr',
      theme: TAppTheme.lightTheme,
      home: LayoutView(),
      // home: GoogleMap(
      //   onMapCreated: (controlle) {
      //     mapController = controlle;
      //   },
      //   initialCameraPosition: const CameraPosition(
      //     target: LatLng(37.7749, -122.4194), // Set initial map center
      //     zoom: 12,
      //   ),
      //   onTap: (latLng) {
      //     // setState(() {
      //     //   _selectedLatLng = latLng;
      //     // });
      //   },
      //   // markers: _selectedLatLng != null
      //   //     ? Set<Marker>.from([
      //   //         Marker(
      //   //           markerId: MarkerId('selected-location'),
      //   //           position: _selectedLatLng,
      //   //         ),
      //   //       ])
      //   //     : null,
      // ),
      routes: AppRoutes.routesTable,
    );
  }
}
