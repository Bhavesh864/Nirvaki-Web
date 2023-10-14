// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:yes_broker/Customs/snackbar.dart';
import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/screens/main_screens/full_view_map_screen.dart';

import '../../Customs/custom_chip.dart';
import '../../Customs/custom_text.dart';
import '../questionaries/google_maps.dart';

class MapViewWidget extends StatefulWidget {
  final LatLng latLng;
  final String state;
  final String city;
  final String? addressline1;
  final String? addressline2;
  final String locality;

  const MapViewWidget({
    Key? key,
    required this.latLng,
    required this.state,
    required this.city,
    required this.addressline1,
    required this.addressline2,
    required this.locality,
  }) : super(key: key);

  @override
  State<MapViewWidget> createState() => _MapViewWidgetState();
}

class _MapViewWidgetState extends State<MapViewWidget> {
  void openFullScreenMap() {
    print(widget.latLng);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullViewGoogleScreen(
          onLatLngSelected: (k) {},
          isReadOnly: true,
          latLng: widget.latLng,
          // stateName: widget.state,
          // cityName: widget.city,
          // isReadOnly: true,
          // locality: widget.locality,
        ),
      ),
    );
  }

  String getGoogleMapsLink(LatLng latLng) {
    String link = 'https://www.google.com/maps/search/?api=1&query=${latLng.latitude},${latLng.longitude}';
    print(link);
    return link;
  }

  @override
  Widget build(BuildContext context) {
    String googleMapsLink = '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const CustomText(
                title: 'Location',
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(
                width: 10,
              ),
              CustomChip(
                paddingVertical: 6,
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: getGoogleMapsLink(widget.latLng))).then((_) {
                    customSnackBar(context: context, text: "Google link copied to clipboard");
                  }).catchError((e) {
                    print(e);
                  });
                },
                label: const Icon(
                  Icons.share_outlined,
                ),
                paddingHorizontal: 3,
              ),
              const SizedBox(
                width: 4,
              ),
              Tooltip(
                message: 'Open Full-Screen Map',
                child: InkWell(
                  onTap: openFullScreenMap,
                  child: const Icon(
                    Icons.fullscreen,
                    size: 25,
                  ),
                ),
              )
            ],
          ),
        ),
        CustomText(
          softWrap: true,
          title: !AppConst.getPublicView()
              ? '${widget.addressline1 ?? ''} ${widget.addressline2 ?? ""} ${widget.locality}, ${widget.city}, ${widget.state}'
              : "${widget.locality}, ${widget.city}, ${widget.state}",
          size: 12,
          color: Colors.grey,
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 200,
          child: CustomGoogleMap(
            isReadOnly: true,
            onLatLngSelected: (latLng) {
              googleMapsLink = getGoogleMapsLink(latLng);
            },
            latLng: LatLng(widget.latLng.latitude, widget.latLng.longitude),
            // stateName: widget.state,
            // cityName: widget.city,
            // address1: widget.addressline1 ?? '',
            // address2: widget.addressline2 ?? 'wtp',
            // locality: widget.locality,
          ),
        ),
      ],
    );
  }
}
