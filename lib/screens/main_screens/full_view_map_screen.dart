// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:yes_broker/constants/functions/lat_lng_get.dart';
import 'package:yes_broker/constants/utils/colors.dart';

class FullViewGoogleScreen extends ConsumerStatefulWidget {
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

  const FullViewGoogleScreen({
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
  ConsumerState<FullViewGoogleScreen> createState() => FullViewGoogleScreenState();
}

class FullViewGoogleScreenState extends ConsumerState<FullViewGoogleScreen> {
  GoogleMapController? mapController;
  bool showMaps = true;
  LatLng? location;

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
    return Scaffold(
      body: Stack(
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
          Positioned(
            top: 20,
            left: 10,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
