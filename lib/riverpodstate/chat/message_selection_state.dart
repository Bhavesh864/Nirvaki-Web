import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/chat/models/message.dart';

// final messgeForwardModeProvider = StateNotifierProvider<MessageForwardMode, bool>(
//   (ref) => MessageForwardMode(),
// );

// class MessageForwardMode extends StateNotifier<bool> {
//   MessageForwardMode() : super(false);

//   void setForwardMode(bool currentState) {
//     state = currentState;
//   }
// }

final selectedMessageProvider = StateNotifierProvider<SelectedMessage, List<ChatMessage>>(
  (ref) => SelectedMessage(),
);

class SelectedMessage extends StateNotifier<List<ChatMessage>> {
  SelectedMessage() : super([]);

  void addMessage(ChatMessage selectedValue) {
    List<ChatMessage> currentState = state;
    currentState.add(selectedValue);
    state = currentState;
  }

  void setToEmpty() {
    state = [];
  }

  void removeMessge(ChatMessage selectedValue) {
    List<ChatMessage> currentState = state;
    currentState.remove(selectedValue);
    state = currentState;
  }
}
