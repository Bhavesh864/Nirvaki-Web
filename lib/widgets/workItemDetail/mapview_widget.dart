import 'package:flutter/material.dart';

import '../../Customs/custom_chip.dart';
import '../../Customs/custom_text.dart';
import '../../Customs/responsive.dart';
import '../questionaries/google_maps.dart';

class MapViewWidget extends StatelessWidget {
  final String state;
  final String city;
  final String addressline1;
  final String? addressline2;
  const MapViewWidget({super.key, required this.state, required this.city, required this.addressline1, required this.addressline2});

  @override
  Widget build(BuildContext context) {
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
              if (!Responsive.isMobile(context))
                const CustomChip(
                  label: Icon(
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
            onLatLngSelected: (d) {},
            stateName: state,
            cityName: city,
            address1: addressline1,
            address2: addressline2 ?? 'wtp',
          ),
        ),
      ],
    );
  }
}
