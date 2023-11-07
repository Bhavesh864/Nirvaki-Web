import 'package:flutter_riverpod/flutter_riverpod.dart';

final messgeForwardModeProvider = StateNotifierProvider<MessageForwardMode, bool>(
  (ref) => MessageForwardMode(),
);

class MessageForwardMode extends StateNotifier<bool> {
  MessageForwardMode() : super(false);

  void setForwardMode(bool currentState) {
    state = currentState;
  }
}

final selectedMessageProvider = StateNotifierProvider<SelectedMessage, List<int>>(
  (ref) => SelectedMessage(),
);

class SelectedMessage extends StateNotifier<List<int>> {
  SelectedMessage() : super([]);

  void addIndex(int selectedValue) {
    List<int> currentState = state;
    currentState.add(selectedValue);
    state = currentState;
  }

  void setToEmpty() {
    state = [];
  }

  void removeIndex(int selectedValue) {
    List<int> currentState = state;
    currentState.remove(selectedValue);
    state = currentState;
  }
}
