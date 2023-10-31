import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/riverpodstate/header_text_state.dart';

import '../../../Customs/responsive.dart';
import '../../../riverpodstate/selected_workitem.dart';
import '../../../screens/main_screens/inventory_details_screen.dart';
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
  ref.read(headerTextProvider.notifier).addTitle(route);

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

String navigationUrl(BuildContext context, String id) {
  final routePrefix = id.substring(0, 2);

  String route = 'inventory/inventory-details/$id';

  if (routePrefix == 'IN') {
    route = 'inventory/inventory-details/$id';
  } else if (routePrefix == 'LD') {
    route = 'lead/lead-details/$id';
  } else if (routePrefix == 'TD') {
    route = 'todo/todo-details/$id';
  }

  return route;
}
