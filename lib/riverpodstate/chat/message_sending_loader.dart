import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:yes_broker/chat/enums/message.enums.dart';

final messageSendingProvider = StateNotifierProvider<IsSending, bool>(
  (ref) => IsSending(),
);

class IsSending extends StateNotifier<bool> {
  IsSending() : super(false);
}

final messageSendingTypeProivder = StateNotifierProvider<MessageType, MessageEnum?>(
  (ref) => MessageType(),
);

class MessageType extends StateNotifier<MessageEnum?> {
  MessageType() : super(null);
}
