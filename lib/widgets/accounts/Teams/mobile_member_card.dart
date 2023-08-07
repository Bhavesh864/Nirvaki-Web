import 'package:flutter/material.dart';
import 'package:yes_broker/constants/utils/constants.dart';

import '../../../constants/utils/colors.dart';

class MobileMemberCard extends StatelessWidget {
  const MobileMemberCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Card(
        elevation: 5,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                        child: Image.network(
                          noImg,
                          width: 25,
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Text("Raj Sharma"),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(color: AppColor.secondary, borderRadius: BorderRadius.circular(7)),
                        child: IconButton(
                          tooltip: "Edit",
                          iconSize: 14,
                          onPressed: () {},
                          icon: const Icon(Icons.edit),
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Text("200"),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text("Role - broker"), Text("Manager - ketki sharma")],
              )
            ],
          ),
        ),
      ),
    );
  }
}
