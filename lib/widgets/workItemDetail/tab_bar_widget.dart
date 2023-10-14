import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/utils/colors.dart';

class TabBarWidget extends StatelessWidget {
  final TabController tabviewController;
  final Function(int) onTabChanged;

  const TabBarWidget({
    super.key,
    required this.tabviewController,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 62,
      margin: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        color: AppColor.secondary,
        borderRadius: BorderRadius.circular(
          10,
        ),
      ),
      child: TabBar(
        onTap: (value) {
          onTabChanged(value);
        },
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
        tabs: [
          Tab(
            child: Text(
              "Details",
              style: TextStyle(fontFamily: GoogleFonts.dmSans().fontFamily),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Tab(
            child: Text(
              "Activity",
              style: TextStyle(fontFamily: GoogleFonts.dmSans().fontFamily),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Tab(
            child: Text(
              "To-Do",
              style: TextStyle(fontFamily: GoogleFonts.dmSans().fontFamily),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Tab(
          //   child: Text(
          //     "Matches",
          //     overflow: TextOverflow.ellipsis,
          //   ),
          // ),
        ],
      ),
    );
  }
}
