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

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    // _selectedLatLng = LatLng(_locationData.latitude!, _locationData.longitude!);
    setState(() {
      _selectedLatLng = LatLng(_locationData.latitude!, _locationData.longitude!);
      showMaps = true;
    });
    mapController.animateCamera(CameraUpdate.newLatLng(_selectedLatLng));
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
                  markers: Set<Marker>.of([
                    Marker(
                      markerId: const MarkerId('myLocation'),
                      position: _selectedLatLng,
                    ),
                  ]),
                  mapType: MapType.terrain,
                ),
              )
            : const CircularProgressIndicator());
  }
}




// import 'dart:html';

// import 'package:flutter/material.dart';
// import 'package:google_maps/google_maps.dart';
// import 'dart:ui' as ui;

// class GoogleMapCustom extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     String htmlId = "7";

//     // ignore: undefined_prefixed_name
//     ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
//       final myLatlng = LatLng(1.3521, 103.8198);

//       // another location
//       final myLatlng2 = LatLng(1.4521, 103.9198);

//       final mapOptions = MapOptions()
//         ..zoom = 10
//         ..center = LatLng(1.3521, 103.8198);

//       final elem = DivElement()
//         ..id = htmlId
//         ..style.width = "100%"
//         ..style.height = "100%"
//         ..style.border = 'none';

//       final map = GMap(elem, mapOptions);

//       final marker = Marker(MarkerOptions()
//         ..position = myLatlng
//         ..map = map
//         ..title = 'Hello World!'
//         ..label = 'h'
//         ..icon = 'https://developers.google.com/maps/documentation/javascript/examples/full/images/beachflag.png');

//       // Another marker
//       Marker(
//         MarkerOptions()
//           ..position = myLatlng2
//           ..map = map,
//       );

//       final infoWindow = InfoWindow(InfoWindowOptions()..content = 'contentString');
//       marker.onClick.listen((event) => infoWindow.open(map, marker));
//       return elem;
//     });

//     return HtmlElementView(viewType: htmlId);
//   }
// }


