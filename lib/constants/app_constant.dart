import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_symbols/flutter_material_symbols.dart';
import 'package:yes_broker/constants/utils/colors.dart';
import 'package:yes_broker/constants/utils/constants.dart';

import 'firebase/detailsModels/card_details.dart';

class AppConst {
  static isIosDevice() {
    if (Platform.isIOS) {
      return true;
    } else {
      return false;
    }
  }

  static BuildContext? outerContext;
  static BuildContext? getOuterContext() {
    return outerContext;
  }

  static setOuterContext(BuildContext context) {
    outerContext = context;
  }

  static String? _fcmToken;
  static String? getFcmToken() {
    return _fcmToken;
  }

  static setFcmToken(String token) {
    _fcmToken = token;
  }

  static dynamic _accessToken;
  static dynamic getAccessToken() {
    return _accessToken;
  }

  static setAccessToken(dynamic token) {
    _accessToken = token;
  }

  static bool _isPublicView = false;
  static bool getPublicView() {
    return _isPublicView;
  }

  static setPublicView(bool val) {
    _isPublicView = val;
  }

  static bool _isAuthenticated = false;
  static bool getIsAuthenticated() {
    return _isAuthenticated;
  }

  static setIsAuthenticated(bool val) {
    _isAuthenticated = val;
  }

  static String role = "";
  static String getRole() {
    return role;
  }

  static setRole(String val) {
    role = val;
  }

  static showConsoleLog(message) {
    if (kDebugMode) {
      print(message);
    }
  }

  static String? noImage =
      'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAOEAAADhCAMAAAAJbSJIAAAAHlBMVEX09PTh4eH19fXg4ODk5OTw8PDs7Ozq6uru7u7n5+dZKxXMAAAELUlEQVR4nO2dWXKtMAwFwQMX9r/hB9RNMOARhCTyTv/kIxVQl4kHYZmuAwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADgAsZ03o9eA6OfwyH360bXWz30kyd2HHvbq8LaibQdJ2V+C7Yf6RSdQsEZOxApGqWCsyJNK5qPVsEZCsHOS1tksBNFI2rsZTY8gaG0QxaCRjRj0ITS4/wvW0judguaKbjaID1f+xLEZG8/psZtV6OeKF3GbH2DHW9fbDN0WgTn/j0wvBtVYEjSM9MAwxZgKAMMW4ChDLyGxoQ/eGA0NMYPk3O9c9PH80nyGZo1A/e9l3WEiZM8DxmeZm3GH/Ib1jFNXZna0AzntTFZcigPj2E8f2M/HIoshqkEFYsih+Fu7b9XZOhvWNow4bdw85YVMBjmkqg0Kb4sHG2YaUKaFF+W5w3zefDnO5vnR/wwPxXh8YwOw1Oaz4Pbmzct8ryhLxhe+EdsivRxw/RgePW2821a/uZ5w8ILt/auZp7Ct8Qqb9g6/17XKA3BKnhK227yswirjvZtPc22yqwN912jxW6bQGW87xrx93mCuoBfNWs7JkKqIuaYeWcf04brn3ey1ITMsXrK7F9oWD1Ft+pUxPyeFXB8L1I5aJYsRnKbTcM9E5utyleQzUTVz2eSu8mKYb8km5jbLleI+xUZ4cJ+wHzgr8jqFzY85iNnfPe0vJn5uVff8mamuKMzGzrn27Xu9+3a4Bu2JddsWc3Erv4NaeWe3HTw6t9yV246Tkev3bB6V3UyfOWGDdvGU/HrNmzbFx8X0GzYvPE/asA14l+hubIhqqC4DS+UbsQc9Bpeq005S2g1vFx8c7LQani5uuikIWhohnR5wI3yqaOHnOG8ZLQpxVv1YYd1p5jhuiZOKN4sgNsrShl+F/0xxfsVfjtFoRE/yGqcfkdQwhgqyrRhmLY5tiJJjWbwvkfEcJeXOjyoNEWoVrYND4m3UJGqyla2DU+ZxUCRqoxY1DCWOv3pbsjqpCUNo4LfVqQrBBc0jAquioaylF/OMCG4KlKW8j9vmBjxk4LUSLUhm6CUIZ+gkCGjoIwhp6CIIaughCGvoIAhsyC/Ibcg+4jPLsjdhvyCzIYCgryGEoK8hoV93u83lDn+i9VQ4iGFIQwrDN2fN/z7bQhDGMIQhjCEYdnwvxrxPyKnljIadn6QgNOwMxKwGgoDwxZgKAMMW4ChDE/N2kiCoyA4eYTgPO/t/PPluyc6COrICc5kDybZ1jodhPP+u4LFg1qkofjXyR9jIgzFaaKl84Rkoen9FDci1Tmb0h5JqM6gNFo7m2R5zgVFbd8kW5nHZzJOx0MowNqhHHiL4+h2H7ARZvl4HvUHAtfD1yfpycyX6TPSfwCxE8o+JXhADwAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAs/ANyGFT0fw3sTAAAAABJRU5ErkJggg==';

  static String? docTypeImage = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ9RsiK7WSMHn6rVq5pLvEgINRyVTNKJ7drsg&usqp=CAU';

  static String googlemapkey = 'AIzaSyD7KtQoq29-5TqELLdPBSQoqCD376-qGjA';
}

bool isTypeisTodo(CardDetails cardData) {
  if (cardData.cardType != "LD" && cardData.cardType != "IN") {
    return true;
  }
  return false;
}

dynamic checkIconByCategory(CardDetails carddata) {
  if (carddata.workitemId!.contains(ItemCategory.isInventory)) {
    return MaterialSymbols.location_home_outlined;
  } else if (carddata.workitemId!.contains(ItemCategory.isLead)) {
    return MaterialSymbols.location_away;
  } else if (carddata.linkedItemType!.contains(ItemCategory.isLead)) {
    return MaterialSymbols.location_away;
  } else if (carddata.linkedItemType!.contains(ItemCategory.isInventory)) {
    return MaterialSymbols.location_home_outlined;
  }
  return MaterialSymbols.location_away;
}

Color checkIconColorByCategory(CardDetails carddata) {
  // if (carddata.workitemId!.contains('TD')) {
  //   if (carddata.linkedItemId!.contains(ItemCategory.isInventory)) {
  //     return AppColor.inventoryIconColor;
  //   } else if (carddata.linkedItemId!.contains(ItemCategory.isLead)) {
  //     return AppColor.leadIconColor;
  //   } else if (carddata.linkedItemType!.contains(ItemCategory.isLead)) {
  //     return AppColor.leadIconColor;
  //   } else if (carddata.linkedItemType!.contains(ItemCategory.isInventory)) {
  //     return AppColor.inventoryIconColor;
  //   }
  // }

  if (carddata.workitemId!.contains(ItemCategory.isInventory)) {
    return AppColor.inventoryIconColor;
  } else if (carddata.workitemId!.contains(ItemCategory.isLead)) {
    return AppColor.leadIconColor;
  } else if (carddata.linkedItemType!.contains(ItemCategory.isLead)) {
    return AppColor.leadIconColor;
  } else if (carddata.linkedItemType!.contains(ItemCategory.isInventory)) {
    return AppColor.inventoryIconColor;
  }
  return AppColor.leadIconColor;
}

Color checkChipColorByCategory(CardDetails carddata) {
  if (carddata.workitemId!.contains(ItemCategory.isInventory)) {
    return AppColor.inventoryChipColor;
  } else if (carddata.workitemId!.contains(ItemCategory.isLead)) {
    return AppColor.leadChipColor;
  } else if (carddata.linkedItemType!.contains(ItemCategory.isLead)) {
    return AppColor.leadChipColor;
  } else if (carddata.linkedItemType!.contains(ItemCategory.isInventory)) {
    return AppColor.inventoryChipColor;
  }
  return AppColor.leadChipColor;
}

bool checkNotNUllItem(dynamic data) {
  if (data != null) {
    return true;
  } else {
    return false;
  }
}

String buildBedroomText(roomconfig) {
  final bedroom = roomconfig?.bedroom;
  final additionalRooms = roomconfig?.additionalroom;

  if (bedroom != null) {
    String bedroomText = "$bedroom BHK";

    if (additionalRooms != null && additionalRooms.isNotEmpty) {
      bedroomText += "+${additionalRooms[0]}";
    }

    return bedroomText;
  }

  return "";
}

String buildRoomsText(roomconfig, bool buildAdditionalRoom) {
  final bedroom = roomconfig?.bedroom;
  final additionalRooms = roomconfig?.additionalroom;
  final bathroom = roomconfig?.bathroom;
  final balcony = roomconfig?.balconies;

  List<String> roomTextList = [];

  if (!buildAdditionalRoom) {
    if (bedroom != null) {
      roomTextList.add("$bedroom BHK");
    }

    if (bathroom != null) {
      roomTextList.add("$bathroom Bathroom");
    }

    if (balcony != null) {
      roomTextList.add("$balcony Balcony");
    }
  }

  if (additionalRooms != null && additionalRooms is List && buildAdditionalRoom) {
    for (var room in additionalRooms) {
      roomTextList.add("$room Room");
    }
  }

  String allRoomsText = roomTextList.join(', ');

  return allRoomsText;
}
