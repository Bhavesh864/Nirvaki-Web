import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:yes_broker/routes/routes.dart';
import '../../constants/utils/colors.dart';

class CustomSpeedDialButton extends StatefulWidget {
  const CustomSpeedDialButton({super.key});

  @override
  State<CustomSpeedDialButton> createState() => _CustomSpeedDialButtonState();
}

class _CustomSpeedDialButtonState extends State<CustomSpeedDialButton> {
  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.add_event,
      foregroundColor: Colors.white,
      backgroundColor: AppColor.primary,
      overlayColor: Colors.black,
      // renderOverlay: false,
      overlayOpacity: 0.4,
      children: [
        SpeedDialChild(
          onTap: () {
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => const AddWorkItem(
            //       isInventory: true,
            //     ),
            //   ),
            // );
            context.beamToNamed(AppRoutes.addInventory);
          },
          labelShadow: [
            const BoxShadow(
              color: Colors.grey,
              blurRadius: 4,
              spreadRadius: 1,
            )
          ],
          child: const Icon(
            MaterialSymbols.location_home_outlined,
            color: Colors.white,
          ),
          label: 'Inventory',
          labelStyle: const TextStyle(color: AppColor.primary, fontWeight: FontWeight.w700),
          backgroundColor: AppColor.primary,
        ),
        SpeedDialChild(
          onTap: () {
            // Navigator.of(context).push(
            //   MaterialPageRoute(
            //     builder: (context) => const AddWorkItem(
            //       isInventory: false,
            //     ),
            //   ),
            // );
            context.beamToNamed(AppRoutes.addLead);
          },
          labelShadow: [
            const BoxShadow(
              color: Colors.grey,
              blurRadius: 4,
              spreadRadius: 1,
            )
          ],
          child: const Icon(
            Icons.person_search_outlined,
            color: Colors.white,
          ),
          label: 'Lead',
          labelStyle: const TextStyle(color: AppColor.primary, fontWeight: FontWeight.w700),
          backgroundColor: AppColor.primary,
        ),
        SpeedDialChild(
          onTap: () {
            context.beamToNamed(AppRoutes.addTodo);
          },
          labelShadow: [
            const BoxShadow(
              color: Colors.grey,
              blurRadius: 4,
              spreadRadius: 1,
            )
          ],
          child: const Icon(
            Icons.task_outlined,
            color: Colors.white,
          ),
          label: 'To-do',
          labelStyle: const TextStyle(color: AppColor.primary, fontWeight: FontWeight.w700),
          backgroundColor: AppColor.primary,
        ),
      ],
    );
  }
}
