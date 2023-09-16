import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yes_broker/Customs/snackbar.dart';

import '../../Customs/custom_chip.dart';
import '../../Customs/custom_text.dart';
import '../questionaries/google_maps.dart';

class MapViewWidget extends StatelessWidget {
  final String state;
  final String city;
  final String addressline1;
  final String? addressline2;
  final String? locality;
  const MapViewWidget({super.key, required this.state, required this.city, required this.addressline1, required this.addressline2, this.locality});

  String getGoogleMapsLink(LatLng latLng) {
    String link = 'https://www.google.com/maps/search/?api=1&query=${latLng.latitude},${latLng.longitude}';
    return link;
  }

  @override
  Widget build(BuildContext context) {
    String googleMapsLink = '';
    return Column(
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
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: googleMapsLink)).then((_) {
                    customSnackBar(context: context, text: "Google link copied to clipboard");
                  });
                },
                label: const Icon(
                  Icons.share_outlined,
                ),
                paddingHorizontal: 3,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200,
          child: CustomGoogleMap(
            isReadOnly: true,
            onLatLngSelected: (latLng) {
              googleMapsLink = getGoogleMapsLink(latLng);
            },
            stateName: state,
            cityName: city,
            address1: addressline1,
            address2: addressline2 ?? 'wtp',
            locality: locality!,
          ),
        ),
      ],
    );
  }
}
