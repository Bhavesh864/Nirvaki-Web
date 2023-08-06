import 'package:flutter/material.dart';

import '../../constants/utils/colors.dart';

class TabBarWidget extends StatelessWidget {
  const TabBarWidget({
    super.key,
    required this.tabviewController,
  });

  final TabController tabviewController;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      margin: const EdgeInsets.only(top: 22),
      decoration: BoxDecoration(
        color: AppColor.secondary,
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: TabBar(
        controller: tabviewController,
        labelColor: Colors.white,
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelColor: Colors.black,
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        indicatorPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        splashBorderRadius: BorderRadius.circular(8),
        indicator: BoxDecoration(
          color: AppColor.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        tabs: const [
          Tab(
            child: Text(
              "Details",
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Tab(
            child: Text(
              "Activity",
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Tab(
            child: Text(
              "To-Do",
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Tab(
            child: Text(
              "Matches",
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
