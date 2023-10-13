import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:yes_broker/riverpodstate/arearange_state.dart';

import 'package:yes_broker/routes/routes.dart';
import '../../constants/app_constant.dart';
import '../../constants/utils/colors.dart';
import '../../pages/add_inventory.dart' as inventory;
import '../../pages/add_lead.dart' as lead;
import '../../pages/add_todo.dart';

class CustomSpeedDialButton extends ConsumerStatefulWidget {
  const CustomSpeedDialButton({super.key});

  @override
  CustomSpeedDialButtonState createState() => CustomSpeedDialButtonState();
}

class CustomSpeedDialButtonState extends ConsumerState<CustomSpeedDialButton> {
  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.add_event,
      foregroundColor: Colors.white,
      backgroundColor: AppColor.primary,
      // overlayColor: Colors.black.withOpacity(0.2),
      // renderOverlay: false,
      overlayOpacity: 0.4,
      children: [
        SpeedDialChild(
          onTap: () {
            AppConst.getOuterContext()!.beamToNamed(AppRoutes.addInventory);
            ref.read(inventory.myArrayProvider.notifier).resetState();
          },
          labelShadow: [
            const BoxShadow(
              color: Colors.grey,
              blurRadius: 4,
              spreadRadius: 1,
            )
          ],
          child: const Icon(
            inventoryIcon,
            color: Colors.white,
          ),
          label: 'Inventory',
          labelStyle: const TextStyle(color: AppColor.primary, fontWeight: FontWeight.w700),
          backgroundColor: AppColor.primary,
        ),
        SpeedDialChild(
          onTap: () {
            AppConst.getOuterContext()!.beamToNamed(AppRoutes.addLead);
            ref.read(lead.myArrayProvider.notifier).resetState();
            ref.read(defaultAreaRangeValuesNotifier.notifier).setRange(const RangeValues(100, 10000));
            ref.read(areaRangeSelectorState.notifier).setRange(const RangeValues(100, 10000));
            ref.read(selectedOptionNotifier.notifier).setRange("Sq ft");
          },
          labelShadow: [
            const BoxShadow(
              color: Colors.grey,
              blurRadius: 4,
              spreadRadius: 1,
            )
          ],
          child: const Icon(
            leadIcon,
            color: Colors.white,
          ),
          label: 'Lead',
          labelStyle: const TextStyle(color: AppColor.primary, fontWeight: FontWeight.w700),
          backgroundColor: AppColor.primary,
        ),
        SpeedDialChild(
          onTap: () {
            AppConst.getOuterContext()!.beamToNamed(AppRoutes.addTodo);
            ref.read(myArrayProvider.notifier).resetState();
          },
          labelShadow: [
            const BoxShadow(
              color: Colors.grey,
              blurRadius: 4,
              spreadRadius: 1,
            )
          ],
          child: const Icon(
            Icons.task,
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
