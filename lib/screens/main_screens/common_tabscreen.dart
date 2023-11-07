// import 'package:flutter/material.dart';

// import 'package:yes_broker/Customs/responsive.dart';
// import 'package:yes_broker/widgets/top_search_bar.dart';

// import '../../constants/utils/colors.dart';

// class CommonTabScreen extends StatelessWidget {
//   final String title;
//   final bool showFilter;
//   final Widget listView;

//   const CommonTabScreen({
//     super.key,
//     required this.title,
//     required this.showFilter,
//     required this.listView,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: AppColor.secondary,
//             spreadRadius: 12,
//             blurRadius: 4,
//             offset: Offset(5, 5),
//           ),
//         ],
//         color: Colors.white,
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             flex: 5,
//             child: Column(
//               children: [
//                 TopSerachBar(
//                   title: 'Common',
//                   isMobile: Responsive.isMobile(context),
//                   isFilterOpen: showFilter,
//                   onFilterClose: () {},
//                   onFilterOpen: () {
//                     // Handle filter button opened
//                   },
//                 ),
//                 Expanded(
//                   child: listView,
//                 ),
//               ],
//             ),
//           ),
//           // Specific content for each tab goes here
//           // You can add any specific content here for each tab
//           // For example, specific actions or additional widgets
//         ],
//       ),
//     );
//   }
// }
