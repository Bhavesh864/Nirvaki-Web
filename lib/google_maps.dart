import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

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
  LatLng? location;

  Future<LatLng?> getCoordinates(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        return LatLng(locations[0].latitude, locations[0].longitude);
      }
    } catch (e) {
      print("Error getting location: $e");
    }
    return null;
  }

  void _loadMap() async {
    location = await getCoordinates('Rajasthan Bikaner, pawanpuri');
    if (location != null) {
      mapController.animateCamera(CameraUpdate.newLatLng(location!));
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _loadMap();
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
                    target: location ?? _selectedLatLng,
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
                      position: location ?? _selectedLatLng,
                    ),
                  },
                  mapType: MapType.terrain,
                ),
              )
            : const CircularProgressIndicator());
  }
}
