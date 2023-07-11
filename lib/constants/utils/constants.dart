import 'package:flutter/material.dart';

import 'package:yes_broker/Customs/custom_text.dart';

// var pixelRatio = window.devicePixelRatio;

// var logicalScreenSize = window.physicalSize / pixelRatio;
// var width = logicalScreenSize.width;
// var height = logicalScreenSize.height;
double? height;
double? width;

// App constants

List<IconData> sideBarIcons = [
  Icons.home_outlined,
  Icons.list_outlined,
  Icons.person_pin_outlined,
  Icons.person_search_outlined,
  Icons.chat_outlined,
  Icons.calendar_month_outlined,
  // Icons.person_pin_circle,
];

final List bottomBarItems = [
  {
    "title": 'Home',
    "icon": Icons.home_outlined,
    "active_icon": Icons.home_rounded,
    "page": const CustomText(title: 'Home'),
  },
  {
    "title": 'Inventory',
    "icon": Icons.person_pin_outlined,
    "active_icon": Icons.search,
    "page": const CustomText(title: 'Lead'),
  },
  {
    "title": 'Lead',
    "icon": Icons.person_search_outlined,
    "active_icon": Icons.favorite_outlined,
    "page": const CustomText(title: 'Inventory'),
  },
  {
    "title": 'Chat',
    "icon": Icons.chat_outlined,
    "active_icon": Icons.forum_rounded,
    "page": const CustomText(title: 'Chat'),
  },
];

class todoItemModal {
  String? image;
  String? task;
  String? subtitle;
  String? name;
  String? time;
  String todoType;
  String todoStatus;
  bool isLead;

  todoItemModal({
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

class workItemModal {
  String bhk;
  String area;
  String price;
  String type;
  String? subtitle;
  String? title;
  String? name;
  String todoStatus;
  bool isLead;

  workItemModal({
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

final List<todoItemModal> userData = [
  todoItemModal(
    image: "user1",
    name: "Riya Sharma",
    task: "Collects documents from kishore",
    subtitle:
        'Make sure to collect all the documents from Kishor which we need for our meeting with DLF',
    time: 'Today at 9:12 AM',
    todoType: 'Task',
    todoStatus: 'New',
    isLead: true,
  ),
  todoItemModal(
    image: "user4",
    name: "Priya Singh",
    task: "Call to schedule physical visit",
    subtitle: "confirm for physical visit date and time...",
    time: 'Today at 9:30 AM',
    todoType: 'Task',
    todoStatus: 'In progress',
    isLead: false,
  ),
  todoItemModal(
    image: "user3",
    name: "Ganesh Gupta",
    task: "Collect copy of agreement",
    subtitle: "Get agreement signed by Riya mam",
    time: 'Today at 10:08 AM',
    todoType: 'Reminder',
    todoStatus: 'In progress',
    isLead: true,
  ),
  todoItemModal(
    image: "user2",
    name: "",
    task: "Discuss about physical visit",
    subtitle: "Physical visit status update and client reviews",
    time: 'Today at 11:00 AM',
    todoType: 'Follow up',
    todoStatus: 'New',
    isLead: false,
  ),
  todoItemModal(
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

List<workItemModal> workItemData = [
  workItemModal(
    bhk: '2BHK',
    area: '2000 sq ft',
    price: '2.5cr',
    type: 'Rent',
    todoStatus: 'New',
    isLead: false,
    name: 'Priya singh',
    title: 'Residential villa- Delhi',
    subtitle:
        'Looking for 360 sq yrd villa, preferred location Rohini and park facing.',
  ),
  workItemModal(
    bhk: '3BHK',
    area: '2000 sq ft',
    price: '2.5cr',
    type: 'Rent',
    todoStatus: 'New',
    isLead: true,
    name: 'Priya singh',
    title: 'Residential villa- Delhi',
    subtitle:
        'Looking for 360 sq yrd villa, preferred location Rohini and park facing.',
  ),
  workItemModal(
    bhk: '4BHK',
    area: '2000 sq ft',
    price: '2.5cr',
    type: 'Rent',
    todoStatus: 'New',
    isLead: false,
    name: 'Priya singh',
    title: 'Residential villa- Delhi',
    subtitle:
        'Looking for 360 sq yrd villa, preferred location Rohini and park facing.',
  ),
  workItemModal(
    bhk: '2BHK',
    area: '2000 sq ft',
    price: '2.5cr',
    type: 'Rent',
    todoStatus: 'New',
    isLead: true,
    name: 'Priya singh',
    title: 'Residential villa- Delhi',
    subtitle:
        'Looking for 360 sq yrd villa, preferred location Rohini and park facing.',
  ),
  workItemModal(
    bhk: '5BHK',
    area: '2000 sq ft',
    price: '2.5cr',
    type: 'Rent',
    todoStatus: 'New',
    isLead: false,
    name: 'Priya singh',
    title: 'Residential villa- Delhi',
    subtitle:
        'Looking for 360 sq yrd villa, preferred location Rohini and park facing.',
  ),
];

Color taskStatusColor(String title) {
  switch (title) {
    case 'New':
      return Colors.green;
    case 'In progress':
      return Colors.orangeAccent;
    case 'Location Finalised':
      return Colors.orangeAccent;
    default:
      return Colors.blue;
  }
}

List dropDownListData = [
  'New',
  'Location Finalised',
  'Negotiation',
  'Token',
  'Agreement',
  'Converted',
  'Closed',
];

String defaultValue = "New";
String selectedOption = "New";

List<Map<String, dynamic>> timelineData = [
  {
    'name': 'Ramesh Singh',
    'title': 'Property Details Added',
    'isInventory': false,
    'isFollowUp': false,
    'id': 'LD 938'
  },
  {
    'name': 'Ramesh Singh',
    'title': 'Property Details Added',
    'isInventory': true,
    'isFollowUp': true,
    'id': 'IN 938'
  },
  {
    'name': 'Ramesh Singh',
    'title': 'Property Details Added',
    'isInventory': true,
    'isFollowUp': true,
    'id': 'IN 938'
  },
  {
    'name': 'Ramesh Singh',
    'title': 'Property Details Added',
    'isInventory': false,
    'isFollowUp': false,
    'id': 'LD 235'
  },
];

final List<Map<String, dynamic>> inventoryFilterOtpion = [
  {
    "title": 'Swimming Pool',
    'selected': false,
  },
  {
    "title": 'Gym',
    'selected': true,
  },
  {
    "title": 'Gated Community',
    'selected': false,
  },
  {
    "title": 'Parking',
    'selected': true,
  },
  {
    "title": 'Washing Machine',
    'selected': true,
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

List<String> menuItems = [
  'Profile',
  'Team',
  'Settings',
  'Subscription',
  'Help',
  'Logout',
];


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