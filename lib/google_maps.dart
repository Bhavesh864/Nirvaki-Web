import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yes_broker/widgets/lat_lng_get.dart';

class CustomGoogleMap extends StatefulWidget {
  final String stateName;
  final String cityName;
  final String address1;
  final String address2;
  final void Function(LatLng) onLatLngSelected;

  const CustomGoogleMap({
    required this.onLatLngSelected,
    Key? key,
    required this.stateName,
    required this.cityName,
    required this.address1,
    required this.address2,
  }) : super(key: key);

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  GoogleMapController? mapController;
  bool showMaps = true;

  LatLng? location;

  @override
  void initState() {
    super.initState();
    // Load the map when the widget is first initialized
    _loadMap();
  }

  Future<void> _loadMap() async {
    final placeName = '${widget.stateName} ${widget.cityName} ${widget.address1} ${widget.address2}';
    location = await getLatLng(placeName);
    if (location != null && mapController != null) {
      mapController!.animateCamera(CameraUpdate.newLatLng(location!));
    }
    widget.onLatLngSelected(location!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 307,
        width: 795,
        child: GoogleMap(
          onMapCreated: (controller) {
            mapController = controller;
            // Call _loadMap() here to ensure the map is fully created before loading it
            _loadMap();
          },
          initialCameraPosition: CameraPosition(
            target: location ?? const LatLng(20.5937, 78.9629),
            zoom: 10,
          ),
          onTap: (latLng) {
            setState(() {
              location = latLng;
            });
            widget.onLatLngSelected(location!);
          },
          markers: location != null
              ? <Marker>{
                  Marker(
                    markerId: const MarkerId('myLocation'),
                    position: location!,
                  ),
                }
              : {},
          mapType: MapType.terrain,
        ),
      ),
    );
  }
}
