import 'package:flutter/material.dart';
import 'package:yes_broker/constants/app_constant.dart';
import 'package:yes_broker/constants/utils/colors.dart';

import '../../screens/account_screens/Teams/team_screen.dart';

double? height = 707;
double? width = 1440;

// App constants
const noImg = "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png";

// const GOOGLE_MAPS_APIKEY = 'AIzaSyD7KtQoq29-5TqELLdPBSQoqCD376-qGjA';

class MenuItem {
  final String label;
  final IconData? iconData;
  final Widget screen;
  final String nav;

  MenuItem({
    this.nav = '',
    required this.label,
    this.iconData,
    required this.screen,
  });
}

class ProfileMenuItems {
  final int id;
  final String title;
  final Widget screen;

  ProfileMenuItems({required this.title, required this.screen, required this.id});
}

class BottomBarItem {
  final String label;
  final IconData? iconData;
  final Widget screen;

  BottomBarItem({
    required this.label,
    this.iconData,
    required this.screen,
  });
}

class TodoItemModal {
  String? image;
  String? task;
  String? subtitle;
  String? name;
  String? time;
  String todoType;
  String todoStatus;
  bool isLead;

  TodoItemModal({
    this.image,
    this.task,
    this.subtitle,
    this.name,
    this.time,
    required this.todoType,
    required this.todoStatus,
    required this.isLead,
  });
}

class WorkItemModal {
  String bhk;
  String area;
  String price;
  String type;
  String? subtitle;
  String? title;
  String? name;
  String todoStatus;
  bool isLead;

  WorkItemModal({
    required this.bhk,
    required this.area,
    required this.price,
    required this.type,
    this.subtitle,
    this.title,
    this.name,
    required this.todoStatus,
    required this.isLead,
  });
}

final List<TodoItemModal> userData = [
  TodoItemModal(
    image: "user1",
    name: "Riya Sharma",
    task: "Collects documents from kishore",
    subtitle: 'Make sure to collect all the documents from Kishor which we need for our meeting with DLF',
    time: 'Today at 9:12 AM',
    todoType: 'Task',
    todoStatus: 'New',
    isLead: true,
  ),
  TodoItemModal(
    image: "user4",
    name: "Priya Singh",
    task: "Call to schedule physical visit",
    subtitle: "confirm for physical visit date and time...",
    time: 'Today at 9:30 AM',
    todoType: 'Task',
    todoStatus: 'In progress',
    isLead: false,
  ),
  TodoItemModal(
    image: "user3",
    name: "Ganesh Gupta",
    task: "Collect copy of agreement",
    subtitle: "Get agreement signed by Riya mam",
    time: 'Today at 10:08 AM',
    todoType: 'Reminder',
    todoStatus: 'In progress',
    isLead: true,
  ),
  TodoItemModal(
    image: "user2",
    name: "",
    task: "Discuss about physical visit",
    subtitle: "Physical visit status update and client reviews",
    time: 'Today at 11:00 AM',
    todoType: 'Follow up',
    todoStatus: 'New',
    isLead: false,
  ),
  TodoItemModal(
    image: "user2",
    name: "Priya Singh",
    task: "Collect copy of agreement",
    subtitle: "Get agreement signed by Riya mam",
    time: 'Today at 11:00 AM',
    todoType: 'Task',
    todoStatus: 'In progress',
    isLead: true,
  ),
];

List<WorkItemModal> workItemData = [
  WorkItemModal(
    bhk: '2BHK',
    area: '2000 sq ft',
    price: '2.5cr',
    type: 'Rent',
    todoStatus: 'New',
    isLead: false,
    name: 'Priya singh',
    title: 'Residential villa- Delhi',
    subtitle: 'Looking for 360 sq yrd villa, preferred location Rohini and park facing.',
  ),
  WorkItemModal(
    bhk: '3BHK',
    area: '2000 sq ft',
    price: '2.5cr',
    type: 'Rent',
    todoStatus: 'New',
    isLead: true,
    name: 'Priya singh',
    title: 'Residential villa- Delhi',
    subtitle: 'Looking for 360 sq yrd villa, preferred location Rohini and park facing.',
  ),
  WorkItemModal(
    bhk: '4BHK',
    area: '2000 sq ft',
    price: '2.5cr',
    type: 'Rent',
    todoStatus: 'New',
    isLead: false,
    name: 'Priya singh',
    title: 'Residential villa- Delhi',
    subtitle: 'Looking for 360 sq yrd villa, preferred location Rohini and park facing.',
  ),
  WorkItemModal(
    bhk: '2BHK',
    area: '2000 sq ft',
    price: '2.5cr',
    type: 'Rent',
    todoStatus: 'New',
    isLead: true,
    name: 'Priya singh',
    title: 'Residential villa- Delhi',
    subtitle: 'Looking for 360 sq yrd villa, preferred location Rohini and park facing.',
  ),
  WorkItemModal(
    bhk: '5BHK',
    area: '2000 sq ft',
    price: '2.5cr',
    type: 'Rent',
    todoStatus: 'New',
    isLead: false,
    name: 'Priya singh',
    title: 'Residential villa- Delhi',
    subtitle: 'Looking for 360 sq yrd villa, preferred location Rohini and park facing.',
  ),
];

Color taskStatusColor(String title) {
  switch (title) {
    case 'New':
      return Colors.green;
    case 'In Progress':
      return AppColor.locationfinalizedstatuscolor;
    case 'Location Finalised':
      return AppColor.locationfinalizedstatuscolor;
    case "Token":
      return AppColor.tokenstatuscolor;
    case "Agreement":
      return AppColor.agreementstatuscolor;
    case "Negotiation":
      return AppColor.negotiationstatuscolor;
    case "Closed":
      return Colors.grey.shade900;
    default:
      return Colors.blue;
  }
}

List<String> dropDownStatusDataList = [
  'New',
  'In Progress',
  'Location Finalised',
  'Negotiation',
  'Token',
  'Agreement',
  'Converted',
  'Closed',
];

List<String> todoDropDownList = [
  'New',
  'In Progress',
  'Closed',
];

List<Map<String, dynamic>> dropDownDetailsList = [
  {'title': 'Edit', 'icon': Icons.edit},
  {'title': 'Preview Public View', 'icon': Icons.remove_red_eye_rounded}
];

String defaultValue = "New";
String selectedOption = "New";

List<Map<String, dynamic>> timelineData = [
  {'name': 'Ramesh Singh', 'title': 'Property Details Added', 'isInventory': false, 'isFollowUp': false, 'id': 'LD 938'},
  {'name': 'Ramesh Singh', 'title': 'Property Details Added', 'isInventory': true, 'isFollowUp': true, 'id': 'IN 938'},
  {'name': 'Ramesh Singh', 'title': 'Property Details Added', 'isInventory': true, 'isFollowUp': true, 'id': 'IN 938'},
  {'name': 'Ramesh Singh', 'title': 'Property Details Added', 'isInventory': false, 'isFollowUp': false, 'id': 'LD 235'},
];

final List<Map<String, dynamic>> inventoryFilterOtpion = [
  {
    "title": 'Swimming Pool',
    'selected': false,
  },
  {
    "title": 'Gym',
    'selected': false,
  },
  {
    "title": 'Gated Community',
    'selected': false,
  },
  {
    "title": 'Parking',
    'selected': false,
  },
  {
    "title": 'Washing Machine',
    'selected': false,
  },
  {
    "title": 'Dryer',
    'selected': false,
  },
  {
    "title": 'Pet Friendly',
    'selected': false,
  },
  {
    "title": 'Power Backup',
    'selected': false,
  },
  {
    "title": 'Smoke Alarm',
    'selected': true,
  },
  {
    "title": 'Front Garden',
    'selected': true,
  },
];

List<String> inventoryDetailsOverviewItems = [
  'Residential',
  'Apartment',
  'Floor Wise',
  '3BHK + Study',
  'Balcony',
  'In house Gym',
  '2 Car Parking',
  'Pool',
  'Power Backup',
  'Power Backup',
  'Power Backup',
  'Power Backup',
  'Power Backup',
  'Power Backup',
  'Power Backup',
];

List<String> inventoryDetailsImageUrls = [
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQdocsAtr24XQL5sydteSFs6VYwww-1bZQBOg&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTHzKnIon6D6PeqCBGxlroFP-bQzAGTi8fUkg&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSlt_j5QPoJpIFeO5ElGNRgoFQGYwM3Y7eotw&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRZyIq1luTkp60-ZSjz98D6KW6g32vxDL8rsA&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTQ1XKiCWaQNE_mEh7YXH7C8peeCk3QbeiXJA&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgZ3Sg7lP-k0OgUdnUtE0eNT7PmqmqklX8RA&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqxyJhTiyoXAk0KhLiBE6QBD2yyPyHHq1rfg&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSlt_j5QPoJpIFeO5ElGNRgoFQGYwM3Y7eotw&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTHzKnIon6D6PeqCBGxlroFP-bQzAGTi8fUkg&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTgZ3Sg7lP-k0OgUdnUtE0eNT7PmqmqklX8RA&usqp=CAU',
];

List<ProfileMenuItems> profileMenuItems = [
  ProfileMenuItems(title: "Profile", screen: const Center(child: Text('Screen for Item 1')), id: 1),
  ProfileMenuItems(title: "Team", screen: const TeamScreen(), id: 2),
  ProfileMenuItems(title: "Settings", screen: const Center(child: Text('Screen for Item 3')), id: 3),
  ProfileMenuItems(title: "Subscription", screen: const Center(child: Text('Screen for Item 4')), id: 4),
  ProfileMenuItems(title: "Help", screen: const Center(child: Text('Screen for Item 1')), id: 5),
  ProfileMenuItems(title: "Logout", screen: const Center(child: Text('Screen for Item 1')), id: 6),
];

// List<String> MenuItems = [
//   'Profile',
//   'Team',
//   'Settings',
//   'Subscription',
//   'Help',
//   'Logout',
// ];

// final _questions = [
//   'Which Property Category does this inventory Fall under ?',
//   'What Category does this inventory belong to?',
//   'What is the specific type of Property?',
//   'From where did you source this inventory?',
//   'What kind of property would you like to list?',
// ];

// List answers = [
//   ['Residential', 'Commercial'],
//   ['Rent', 'Sell'],
//   ['Direct', 'Broker'],
//   [
//     '99Acers',
//     'Magic Bricks',
//     'Housing.com',
//     'Social Media',
//     'Data Calling',
//     'Other',
//   ],
//   [
//     'Apartment',
//     'Independent House/Villa ',
//     'Builder Floor ',
//     'Plot',
//     'Farm House',
//   ],
// ];

class ItemCategory {
  static String isInventory = "IN";
  static String isLead = "LD";
  static String isTodo = "TD";
}
