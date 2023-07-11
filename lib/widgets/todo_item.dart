// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_material_symbols/flutter_material_symbols.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import 'package:yes_broker/constants/utils/colors.dart';
// import 'package:yes_broker/constants/utils/constants.dart';
// import 'package:yes_broker/Customs/custom_text.dart';
// import 'package:yes_broker/Customs/responsive.dart';

// import '../constants/utils/image_constants.dart';

// class TodoItem extends StatefulWidget {
//   const TodoItem({super.key});

//   @override
//   State<TodoItem> createState() => _TodoItemState();
// }

// class _TodoItemState extends State<TodoItem> {
//   final FirebaseAuth auth = FirebaseAuth.instance;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

//   PopupMenuItem popupMenuItem(String title) {
//     return PopupMenuItem(
//       onTap: () {
//         setState(() {
//           selectedOption = title;
//         });
//       },
//       height: 5,
//       padding: const EdgeInsets.symmetric(vertical: 2),
//       child: Center(
//         child: Container(
//           width: 200,
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//           decoration: BoxDecoration(
//             color: AppColor.secondary.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(5),
//           ),
//           child: Text(title),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       shrinkWrap: true,
//       physics: Responsive.isMobile(context)
//           ? const NeverScrollableScrollPhysics()
//           : const ClampingScrollPhysics(),
//       itemCount: userData.length,
//       itemBuilder: ((context, index) => Card(
//             color: Colors.white,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20.0),
//             ),
//             margin: EdgeInsets.only(
//               left: width! < 1280 && width! > 1200 ? 0 : 10,
//               right: width! < 1280 && width! > 1200 ? 0 : 10,
//               bottom: 15,
//             ),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//               child: SizedBox(
//                 height: Responsive.isMobile(context) ? 150 : 140,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           SizedBox(
//                             height: 30,
//                             width: Responsive.isMobile(context) ? 170 : 150,
//                             child: ListView(
//                               physics: const ClampingScrollPhysics(),
//                               scrollDirection: Axis.horizontal,
//                               // shrinkWrap: true,
//                               children: [
//                                 customChipWidget(
//                                   Icon(
//                                     userData[index].isLead
//                                         ? MaterialSymbols.location_home_outlined
//                                         : MaterialSymbols.location_away,
//                                     color: userData[index].isLead
//                                         ? AppColor.inventoryIconColor
//                                         : AppColor.leadIconColor,
//                                     size: 18,
//                                     // weight: 10.12,
//                                   ),
//                                   userData[index].isLead
//                                       ? AppColor.inventoryChipColor
//                                       : AppColor.leadChipColor,
//                                 ),
//                                 customChipWidget(
//                                   CustomText(
//                                     title: userData[index].todoType,
//                                     size: 10,
//                                     color: AppColor.blue,
//                                   ),
//                                   AppColor.blue.withOpacity(0.1),
//                                 ),
//                                 PopupMenuButton(
//                                   initialValue: selectedOption,
//                                   splashRadius: 0,
//                                   padding: EdgeInsets.zero,
//                                   color: Colors.white.withOpacity(1),
//                                   offset: const Offset(10, 40),
//                                   itemBuilder: (context) => dropDownListData
//                                       .map((e) => popupMenuItem(e.toString()))
//                                       .toList(),
//                                   child: customChipWidget(
//                                     Row(
//                                       children: [
//                                         CustomText(
//                                           title: selectedOption,
//                                           color:
//                                               taskStatusColor(selectedOption),
//                                           size: 10,
//                                         ),
//                                         Icon(
//                                           Icons.expand_more,
//                                           size: 18,
//                                           color:
//                                               taskStatusColor(selectedOption),
//                                         ),
//                                       ],
//                                     ),
//                                     taskStatusColor(selectedOption)
//                                         .withOpacity(0.1),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const Spacer(),
//                           Row(
//                             children: [
//                               Chip(
//                                 padding: EdgeInsets.zero,
//                                 labelPadding:
//                                     const EdgeInsets.symmetric(horizontal: 4),
//                                 side: BorderSide.none,
//                                 backgroundColor: Colors.grey.withOpacity(0.2),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 label: const Row(
//                                   children: [
//                                     Icon(
//                                       Icons.calendar_month_outlined,
//                                       color: Colors.black,
//                                       size: 12,
//                                     ),
//                                     FittedBox(
//                                       child: CustomText(
//                                         title: '23 May 2023',
//                                         size: 10,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const Icon(
//                                 Icons.chevron_right,
//                                 size: 20,
//                               )
//                             ],
//                           )
//                         ],
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     Text(
//                       userData[index].task!,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         color: Colors.black,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 5,
//                     ),
//                     Text(
//                       userData[index].subtitle!,
//                       style: const TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Text(
//                           userData[index].name!,
//                           style: const TextStyle(
//                             fontSize: 14,
//                             color: Colors.black,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                         customChipWidget(
//                           const Icon(
//                             Icons.call_outlined,
//                             color: Colors.black,
//                             size: 12,
//                           ),
//                           Colors.grey.withOpacity(0.2),
//                           paddingHorizontal: 8,
//                         ),
//                         customChipWidget(
//                           const FaIcon(
//                             FontAwesomeIcons.whatsapp,
//                             color: Colors.black,
//                             size: 12,
//                           ),
//                           Colors.grey.withOpacity(0.2),
//                           paddingHorizontal: 8,
//                         ),
//                         customChipWidget(
//                           const Icon(
//                             Icons.edit_outlined,
//                             color: Colors.black,
//                             size: 12,
//                           ),
//                           Colors.grey.withOpacity(0.2),
//                           paddingHorizontal: 8,
//                         ),
//                         customChipWidget(
//                           const Icon(
//                             Icons.share_outlined,
//                             color: Colors.black,
//                             size: 12,
//                           ),
//                           Colors.grey.withOpacity(0.2),
//                           paddingHorizontal: 8,
//                         ),
//                         Spacer(),
//                         Container(
//                           margin: EdgeInsets.only(right: 5),
//                           height: 20,
//                           width: 20,
//                           decoration: BoxDecoration(
//                             image: const DecorationImage(
//                                 image: AssetImage(profileImage)),
//                             borderRadius: BorderRadius.circular(40),
//                           ),
//                           // child: Text(width.toString()),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           )),
//     );
//   }

//   Widget customChipWidget(Widget label, Color color,
//       {double paddingHorizontal = 3}) {
//     return Container(
//       margin: EdgeInsets.only(
//           left: Responsive.isMobile(context) ? 0 : 1,
//           right: Responsive.isMobile(context) ? 0 : 8),
//       child: Chip(
//           padding:
//               EdgeInsets.symmetric(horizontal: paddingHorizontal, vertical: 0),
//           labelPadding: const EdgeInsets.all(0),
//           side: BorderSide.none,
//           backgroundColor: color,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(5),
//           ),
//           label: label),
//     );
//   }
// }
