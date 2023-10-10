// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:yes_broker/constants/functions/lat_lng_get.dart';

class CustomGoogleMap extends ConsumerStatefulWidget {
  final bool isEdit;
  final String? stateName;
  final String? cityName;
  final List<Map<String, dynamic>>? selectedValues;
  final String? address1;
  final String? address2;
  final String? locality;
  final bool isReadOnly;

  final LatLng? latLng;
  final void Function(LatLng) onLatLngSelected;

  const CustomGoogleMap({
    Key? key,
    this.isEdit = false,
    this.stateName,
    this.cityName,
    this.selectedValues,
    this.address1,
    this.address2,
    this.locality,
    this.isReadOnly = false,
    this.latLng,
    required this.onLatLngSelected,
  }) : super(key: key);

  @override
  ConsumerState<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends ConsumerState<CustomGoogleMap> {
  GoogleMapController? mapController;
  bool showMaps = true;
  LatLng? location;

  // @override
  // void initState() {
  //   super.initState();
  //   if (widget.isReadOnly || widget.isEdit) {
  //     // print('asldkjfasfd${widget.latLng!.latitude}');
  //     print('ReadOnly');
  //     _loadMap();
  //   } else {
  //     loadMap();
  //     print('NotReadOnly');
  //   }
  // }

  Future<void> _loadMap() async {
    location = LatLng(widget.latLng!.latitude, widget.latLng!.longitude);
    if (location != null && mapController != null) {
      mapController!.animateCamera(CameraUpdate.newLatLng(location!));
    }
    setState(() {});
  }

  Future<void> loadMap() async {
    final placeName = '${widget.stateName} ${widget.cityName} ${widget.locality} ${widget.address1 ?? ''} ${widget.address2 ?? ''}';
    location = await getLatLng(placeName);

    if (!widget.selectedValues!.any((element) => element['id'] == 31)) {
      mapController!.animateCamera(CameraUpdate.newLatLng(location!));
    } else {
      Map<String, dynamic>? latLngItem = widget.selectedValues!.firstWhere((item) => item["id"] == 31);
      List<dynamic> latLng = latLngItem["item"];
      if (latLng.length == 2) {
        double latitude = latLng[0];
        double longitude = latLng[1];
        mapController!.animateCamera(CameraUpdate.newLatLng(LatLng(latitude, longitude)));
        location = LatLng(latitude, longitude);
      }
    }
    widget.onLatLngSelected(location!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 307,
      width: 795,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: GoogleMap(
              onMapCreated: (controller) {
                mapController = controller;
                if (widget.isReadOnly || widget.isEdit) {
                  _loadMap();
                } else {
                  loadMap();
                }
              },
              initialCameraPosition: CameraPosition(
                target: location ?? const LatLng(20.5937, 78.9629),
                zoom: 15,
              ),
              onTap: widget.isReadOnly
                  ? null
                  : (latLng) {
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
              mapType: MapType.normal,
            ),
          ),
        ],
      ),
    );
  }
}
