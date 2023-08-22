import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../Customs/responsive.dart';
import '../../../riverpodstate/selected_workitem.dart';
import '../../../screens/main_screens/Inventory_details_screen.dart';
import '../../../screens/main_screens/home_screen.dart';
import '../../../screens/main_screens/lead_details_screen.dart';
import '../../../screens/main_screens/todo_details_screen.dart';

void navigateBasedOnId(BuildContext context, String id, WidgetRef ref) {
  final routePrefix = id.substring(0, 2);
  ref.read(selectedWorkItemId.notifier).addItemId(id);

  String route = '/inventory/inventory-details/$id';

  if (routePrefix == 'IN') {
    route = '/inventory/inventory-details/$id';
  } else if (routePrefix == 'LD') {
    route = '/lead/lead-details/$id';
  } else if (routePrefix == 'TD') {
    route = '/todo/todo-details/$id';
  }

  if (Responsive.isMobile(context)) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          if (routePrefix == 'IN') {
            return InventoryDetailsScreen(inventoryId: id);
          } else if (routePrefix == 'LD') {
            return LeadDetailsScreen(leadId: id);
          } else if (routePrefix == 'TD') {
            return TodoDetailsScreen(todoId: id);
          } else {
            return const HomeScreen();
          }
        },
      ),
    );
  } else {
    context.beamToNamed(route);
  }
}
