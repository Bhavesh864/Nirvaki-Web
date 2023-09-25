import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/constants/utils/constants.dart';

class SelectedItemNotifier extends StateNotifier<ProfileMenuItems?> {
  SelectedItemNotifier() : super(profileMenuItems[0]);

  void setSelectedItem(ProfileMenuItems? item) {
    state = item;
  }
}
