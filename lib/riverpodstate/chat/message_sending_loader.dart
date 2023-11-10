import 'package:flutter_riverpod/flutter_riverpod.dart';

final messageSendingProvider = StateNotifierProvider<IsSending, bool>(
  (ref) => IsSending(),
);

class IsSending extends StateNotifier<bool> {
  IsSending() : super(false);
}
