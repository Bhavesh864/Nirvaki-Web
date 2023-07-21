import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class CustomGoogleMap extends StatefulWidget {
  final void Function(LatLng) onLatLngSelected;

  const CustomGoogleMap({
    required this.onLatLngSelected,
    super.key,
  });

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late GoogleMapController mapController;
  List<Marker> markers = [];
  bool showMaps = true;
  LatLng _selectedLatLng = const LatLng(20.5937, 78.9629);

  Future<void> getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        _showSnackbar('Location services are disabled.');
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        _showSnackbar('Location permission is required to use your curren location.');
        return;
      }
    }

    locationData = await location.getLocation();
    setState(() {
      _selectedLatLng = LatLng(locationData.latitude!, locationData.longitude!);
      showMaps = true;
    });
    mapController.animateCamera(CameraUpdate.newLatLng(_selectedLatLng));
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: showMaps
            ? SizedBox(
                height: 307,
                width: 795,
                child: GoogleMap(
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: _selectedLatLng,
                    zoom: 10,
                  ),
                  onTap: (latLng) {
                    setState(() {
                      _selectedLatLng = latLng;
                    });
                    widget.onLatLngSelected(_selectedLatLng);
                  },
                  markers: <Marker>{
                    Marker(
                      markerId: const MarkerId('myLocation'),
                      position: _selectedLatLng,
                    ),
                  },
                  mapType: MapType.terrain,
                ),
              )
            : const CircularProgressIndicator());
  }
}
